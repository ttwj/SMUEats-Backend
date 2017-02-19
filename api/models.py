from django.db import models
from django.conf import settings

'''Issues:

1) Should be able to modify value of an item (for custom orders). Think of a cai png stall; having multiple entries for various combinations of meat, fish, and veg dishes is inelegant. Instead you could have a CaiPngMeatMixin, CaiPngVegMixin etc (ok this is getting frivolous)


'''

MONEY_PRECISION = {'max_digits': 10, 'decimal_places': 2}

class NullableCharField(models.CharField):
    ''' A CharField that actually puts a null in the DB instead of an empty string when nothing is passed into the objects.create() method. Useful with unique=True.
    
    To make it clear:
    field='' and field=None both result in a db value of null, which is not counted in the unique constraint
    
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
    
    name = models.CharField()
    image = models.ImageField('Image of store front')
    location_str = models.CharField('Location (human readable)')
    # menu = 

class MenuItem(models.Model):
    '''Represents an item on a Merchant's menu that can be ordered
    '''
    
    name = models.CharField()
    image = models.ImageField('Image of menu item')
    price = models.DecimalField(**MONEY_PRECISION)
    merchant = models.ForeignKey('Merchant', on_delete=models.CASCADE, related_name='menu')

class Order(models.Model):
    '''Represents an order for food from a Merchant that can be placed and fulfilled
    '''
    
    orderer = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.PROTECT, related_name='placed_orders')
    fulfiller = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.PROTECT, related_name='fulfilled_orders')
    # items =
    # breaks DRY... but necessary for efficiency
    total_price = models.DecimalField(**MONEY_PRECISION)
    
    # timestamps
    time_placed = models.DateTimeField()
    timeout_by = models.DurationField()
    time_committed = models.DateTimeField()
    time_fulfilled = models.DateTimeField()

class OrderItem(models.Model):
    '''Represents an item in an order. The glue between Order and MenuItem. This is basically a custom ManyToManyField.
    
    http://www.vertabelo.com/blog/technical-articles/serving-delicious-food-and-data-a-data-model-for-restaurants
    '''
    
    order = models.ForeignKey('Order', on_delete=models.CASCADE, related_name='items')
    menu_item = models.ForeignKey('MenuItem', on_delete=models.PROTECT)
    quantity = models.IntegerField()
    notes = models.TextField()

class Wallet(models.Model):
    '''Represents a user's stored value wallet. Can be decoupled from the User eventually
    '''
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.PROTECT)
    balance = models.DecimalField(**MONEY_PRECISION)
    
class TransactionMixin(models.Model):
    '''Represents movement of money in and/or out of a Wallet (Do not instantiate)
    '''
    debit = models.ForeignKey('Debitable', on_delete=models.PROTECT)
    credit = models.ForeignKey('Creditable', on_delete=models.PROTECT)
    amount = models.DecimalField(**MONEY_PRECISION)
    notes = models.TextField()
    
    class Meta:
        abstract = True

class PeerToPeerTransaction(TransactionMixin):
    '''
    '''
    debit_wallet = models.ForeignKey('Wallet', on_delete=models.PROTECT)
    credit_wallet = models.ForeignKey('Wallet', on_delete=models.PROTECT)

class WalletEzlinkTopupTransaction(TransactionMixin):
    '''
    '''
    #debit_ezlink = models.ForeignKey('', on_delete=models.PROTECT)
    credit_wallet = models.ForeignKey('Wallet', on_delete=models.PROTECT)

class WalletFASTTopupTransaction(Trans)
