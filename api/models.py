from django.db import models
from django.db.models import F, Q, Sum
from django.conf import settings
from django.utils import timezone

# This is a testing convenience. Do not directly reference the User type in code
from django.contrib.auth.models import User

from enum import Enum
import datetime as dt
from decimal import Decimal

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
    location_str = models.CharField('Location (human readable)', max_length=100)
    # menu = 
    
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
    # items =
    
    # total_price = models.DecimalField(**MONEY_PRECISION, default=Decimal(0), blank=True)
    # ^ this is a f**kwarg'in bad idea
    
    @property
    def total_price(self):
        return self.items.aggregate(
            price_total=Sum(F('menu_item__price') * F('quantity'),
                output_field=models.DecimalField())
        )['price_total'] or Decimal(0)

    DEFAULT_TIMEOUT_LENGTH = {'hours': 1}

    # timestamps
    time_placed = models.DateTimeField(default=timezone.now)
    timeout_by = models.DateTimeField(null=True)
    time_committed = models.DateTimeField(null=True, blank=True)
    time_fulfilled = models.DateTimeField(null=True, blank=True)

    
    class Stage(Enum):
        PLACED = 1
        COMMITTED = 2
        FULFILLED = 3
        TIMEOUT = 4
    
    @property
    def stage(self):
        if self.time_fulfilled is not None:
            return self.Stage.FULFILLED
        elif self.time_committed is not None:
            return self.Stage.COMMITTED
        elif self.timeout_by < timezone.now():
            return self.Stage.TIMEOUT
        elif self.time_placed is not None:
            return self.Stage.PLACED
        else:
            raise ValueError('if/elif fallthrough in stage property')

    def save(self, *args, **kwargs):
        # default value doesn't work; don't ask
        if self.timeout_by is None:
            self.timeout_by = self.time_placed + dt.timedelta(**self.DEFAULT_TIMEOUT_LENGTH)
        
        super().save(*args, **kwargs)


class OrderItem(models.Model):
    '''Represents an item in an order. The glue between Order and MenuItem.
    This is basically a custom ManyToManyField.
    
    http://www.vertabelo.com/blog/technical-articles/serving-delicious-food-and-data-a-data-model-for-restaurants
    '''
    
    order = models.ForeignKey('Order',
        on_delete=models.CASCADE, related_name='items')
    menu_item = models.ForeignKey('MenuItem', on_delete=models.PROTECT)
    quantity = models.IntegerField(default=1)
    notes = models.TextField(blank=True)

class BeepBeepAccount(models.Model):
    '''Represents a user's BeepBeep account
    '''
    user = models.OneToOneField(settings.AUTH_USER_MODEL,
        on_delete=models.PROTECT)
    account_id = models.IntegerField()
    # how to store this??
    #token = models.CharField()
    

