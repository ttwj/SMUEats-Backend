from django.db import models
from django.db.models import F, Q, Sum, Count
from django.conf import settings
from django.utils import timezone
from django.db import transaction as dbtransaction
from django.core.exceptions import ValidationError

# This is a testing convenience. Do not directly reference the User type in code
from sms_sso.backends import SSOUser
from django.contrib.auth.models import User

from enum import Enum
import datetime as dt
from decimal import Decimal
import hashlib
import uuid

'''Issues:

1) Should be able to modify value of an item (for custom orders).
Think of a cai png stall; having multiple entries for various combinations of meat,
fish, and veg dishes is inelegant. Instead you could have a CaiPngMeatMixin,
CaiPngVegMixin etc (ok this is getting frivolous)


'''

MONEY_PRECISION = {'max_digits': 10, 'decimal_places': 2}

class NullableCharField(models.CharField):
    ''' A CharField that actually puts a null in the DB instead of an empty string
    when nothing is passed into the objects.create() method. Useful with unique=True.
    
    To make it clear: field='' and field=None both result in a db value of null,
    which is not counted in the unique constraint
    
    http://stackoverflow.com/questions/4838740/django-how-to-make-an-unique-blank-models-charfield
    '''
    description = 'CharField that obeys null=True'
    def to_python(self, value):
        if isinstance(value, models.CharField):
            return value
        return value or ''

    def get_db_prep_value(self, value, connection, prepared=False):
        return value or None
        
class Merchant(models.Model):
    '''Represents a food stall or restaurant that users can order from.
    '''
    
    name = models.CharField(max_length=100)
    image = models.ImageField('Image of store front', null=True, blank=True)
    location = models.ForeignKey('MerchantLocation', on_delete=models.PROTECT)
    location_str = models.CharField('Location (human readable)', max_length=100)
    # menu = 
    
    def __str__(self):
        return self.name

class MerchantLocation(models.Model):
    '''Represents a physical location for a merchant.
    '''
    name = models.CharField(max_length=100)
    image = models.ImageField('Image of location (eg. a food court)', null=True, blank=True)

    def __str__(self):
        return self.name

class MenuItem(models.Model):
    '''Represents an item on a Merchant's menu that can be ordered
    '''
    
    name = models.CharField(max_length=100)
    image = models.ImageField('Image of menu item', null=True, blank=True)
    price = models.DecimalField(**MONEY_PRECISION)
    merchant = models.ForeignKey('Merchant',
        on_delete=models.CASCADE, related_name='menu')
    
    def __str__(self):
        return '{} (${}) from {}'.format(self.name, self.price, self.merchant)
    
    class Meta:
        unique_together = (('name', 'merchant'),)
        index_together = (('name', 'merchant'),)

class Order(models.Model):
    '''Represents an order for food from a Merchant that can be placed and fulfilled
    '''
    
    orderer = models.ForeignKey(settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT, related_name='placed_orders')
    fulfiller = models.ForeignKey(settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT, related_name='fulfilled_orders',
        null=True, blank=True)
    location = models.TextField(blank=True)
    # this doesnt seem like a good idea...????
    # items = models.ManyToManyField('MenuItem', through='OrderItem')
    
    # total_price = models.DecimalField(**MONEY_PRECISION, default=Decimal(0), blank=True)
    # ^ this is a f**kwarg'in bad idea
    
    # property or no? http://stackoverflow.com/questions/17429159/idiomatic-python-property-or-method
    @property
    def total_price(self):
        return self.items.aggregate(
            price_total=Sum(
                F('menu_item__price') * F('quantity'),
                output_field=models.DecimalField())
        )['price_total'] or Decimal(0)

    DEFAULT_TIMEOUT_LENGTH = dt.timedelta(hours=0.5)

    # timestamps
    time_placed = models.DateTimeField(default=timezone.now)
    timeout_by = models.DateTimeField(null=True)
    time_committed = models.DateTimeField(null=True, blank=True)
    time_fulfilled = models.DateTimeField(null=True, blank=True)
    is_paid = models.BooleanField(default=False)
    
    class Stage(Enum):
        PLACED = 1
        COMMITTED = 2
        FULFILLED = 3
        TIMEOUT = 4
        PAID = 5
        UNSAVED = 6
    
    @property
    def stage(self):
        if self.pk is None:
            return self.Stage.UNSAVED
        elif self.time_fulfilled is not None:
            return self.Stage.FULFILLED
        elif self.time_committed is not None:
            return self.Stage.COMMITTED
        elif self.timeout_by < timezone.now():
            return self.Stage.TIMEOUT
        elif self.is_paid is True:
            return self.Stage.PAID
        elif self.time_placed is not None:
            return self.Stage.PLACED
        else:
            assert False, 'if/elif fallthrough in stage property'

    @property
    def unique_merchants(self):
        return self.items.aggregate(
            merchant_count=Count('menu_item__merchant', distinct=True)
        )['merchant_count']

    # payment method
    NONE = 0
    WALLET = 1
    CASH = 2
    method_choices = (
        (NONE, 'There *is* such a thing as a free lunch'),
        (WALLET, 'Stored value wallet'),
        (CASH, 'Cash on delivery')
    )
    payment_method = models.SmallIntegerField(choices=method_choices)
    
    # order creation
    # def create_order(self, *items):
        
    
    # confirm code
    DEFAULT_CODE_VALIDITY = dt.timedelta(minutes=5)
    
    def _create_code(self):
        '''Please don't call this
        '''
        now = timezone.now()
        exp = now + self.DEFAULT_CODE_VALIDITY
        return OrderConfirmCode.objects.create(
            time_created=now, expire_by=exp, order=self)
    
    def get_code(self):
        '''Get the current code in use if it's valid, otherwise create one
        '''
        try:
            if self.confirm_code.is_expired:
                self.confirm_code.delete()
                return self._create_code().short_code
            else:
                return self.confirm_code.short_code
        except OrderConfirmCode.DoesNotExist:
            # create it
            return self._create_code().short_code
            
    def check_code(self, foreign_code):
        '''Check a foreign code with the confirm code. Takes a string.
        '''
        if self.confirm_code.is_expired:
            return False
        else:
            return self.confirm_code.short_code == foreign_code
    
    def fulfil_order(self, new_fulfiller):
        '''Try and associate a fulfilling user to this order
        
        Possible concurrency problems here!!!!
        '''

        if new_fulfiller == self.orderer:
            raise ValueError('You cannot fufil your own order ~_~')
        now = timezone.now()
        if self.timeout_by < now:
            raise ValueError('This order has expired')
        
        with dbtransaction.atomic():
            # only one at a time
            if new_fulfiller.fulfilled_orders.select_for_update().filter(time_fulfilled__isnull=True).exists():
                print("hi")
                #raise ValueError("You've already committed to fulfil another order, please complete that first")

            if self.fulfiller is None:
                self.fulfiller = new_fulfiller
            else:
                print("hi")
                #raise ValueError('Order is already fulfilled')
                
            self.time_committed = now
            self.save()
        return
    
    def close_order(self):
        '''Close the order (handle the code matching yourself)
        '''
        if self.stage is not self.Stage.COMMITTED:
            raise ValueError('Can\'t close an uncommitted order')
        
        assert self.time_fulfilled is None, 'time fulfilled is not none (stage check should have caught this)'
        self.time_fulfilled = timezone.now()
        
        return
    
    def __str__(self):
        return 'Order opened by {} on {}, stage: {}'.format(
            self.orderer, self.time_placed, self.stage)
    
    def clean(self):
        # TODO make a foreign key that links here, trigger the clean check
        unique_merchants = self.unique_merchants
        assert unique_merchants >= 0, 'Negative merchants?'
        if unique_merchants > 1:
            raise ValidationError('Only zero or one unique merchant(s) allowed')
    
    def save(self, DEFAULT_TIMEOUT_LENGTH=dt.timedelta(hours=1), *args, **kwargs):
        # default value doesn't work; don't ask
        if self.timeout_by is None:
            self.timeout_by = self.time_placed + DEFAULT_TIMEOUT_LENGTH
        self.clean()
        
        super().save(*args, **kwargs)


class OrderItem(models.Model):
    '''Represents an item in an order. The glue between Order and MenuItem.
    This is basically a custom ManyToManyField.
    
    http://www.vertabelo.com/blog/technical-articles/serving-delicious-food-and-data-a-data-model-for-restaurants
    '''
    
    order = models.ForeignKey('Order', on_delete=models.CASCADE, related_name='items')
    menu_item = models.ForeignKey('MenuItem', on_delete=models.PROTECT)
    quantity = models.IntegerField(default=1)
    notes = models.TextField(blank=True)

class OrderConfirmCode(models.Model):
    '''Represents the order confirmation code for an order
    '''
    # pretty good candidate for redis-ing
    
    # the code is by default, big-endian
    code = models.UUIDField(primary_key=True, default=uuid.uuid4)
    order = models.OneToOneField('Order', on_delete=models.CASCADE,
        related_name='confirm_code')
    time_created = models.DateTimeField(default=timezone.now)
    expire_by = models.DateTimeField()
    
    @property
    def is_expired(self):
        return timezone.now() > self.expire_by
    
    @property
    def short_code(self):
        '''Get the short form of the code
        '''
        return str(int.from_bytes(self.code.bytes, byteorder='big'))[:10]
    
    def __str__(self):
        return 'Code for order by {} placed on {}, expired: {}'.format(
            self.order.orderer, self.order.time_placed, self.is_expired)
