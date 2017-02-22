from django.contrib import admin
from .models import *

class OrderItemInline(admin.TabularInline):
    model = OrderItem

class OrderAdmin(admin.ModelAdmin):
    inlines = [OrderItemInline]
    
admin.site.register([Merchant, MenuItem, OrderItem, OrderConfirmCode])
admin.site.register(Order, OrderAdmin)
