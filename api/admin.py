from django.contrib import admin
from .models import *

class OrderItemInline(admin.TabularInline):
    model = OrderItem

class OrderAdmin(admin.ModelAdmin):
    inlines = [OrderItemInline]
    readonly_fields = ['stage', 'total_price', 'escrow_uuid']

class MenuItemInline(admin.TabularInline):
    model = MenuItem

class MerchantAdmin(admin.ModelAdmin):
    inlines = [MenuItemInline]

class OrderConfirmCodeAdmin(admin.ModelAdmin):
    readonly_fields = ['is_expired', 'short_code']

admin.site.register([MerchantLocation])
admin.site.register(Order, OrderAdmin)
admin.site.register(Merchant, MerchantAdmin)
admin.site.register(OrderConfirmCode, OrderConfirmCodeAdmin)