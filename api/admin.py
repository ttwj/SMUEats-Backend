from django.contrib import admin
from .models import *

class OrderItemInline(admin.TabularInline):
    model = OrderItem

class OrderAdmin(admin.ModelAdmin):
    inlines = [OrderItemInline]

class MenuItemInline(admin.TabularInline):
    model = MenuItem

class MerchantAdmin(admin.ModelAdmin):
    inlines = [MenuItemInline]

admin.site.register([OrderConfirmCode, MerchantLocation])
admin.site.register(Order, OrderAdmin)
admin.site.register(Merchant, MerchantAdmin)