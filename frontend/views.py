from django.shortcuts import render

# Create your views here.
from django.views import generic

from api.models import Order, Merchant, MerchantLocation, MenuItem


def index(request):
    context = {}
    return render(request, "index.html", context)


def store_merchant_index(request, merchant_id):
    merchant = Merchant.objects.get(id=merchant_id)
    items = MenuItem.objects.filter(merchant=merchant)
    return render(request, "order/store.html", {'merchant': merchant, 'items': items})

def list_merchants_index(request):
    locations = MerchantLocation.objects.all()
    merchant_dict = {}
    for location in locations:
        merchant_dict[location.name] = Merchant.objects.filter(location=location).all()
    context = {
        'locations': merchant_dict
    }

    print(context)

    return render(request, "order/index.html", context)

