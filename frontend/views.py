from django.shortcuts import render

# Create your views here.
from django.views import generic

from api.models import Order, Merchant, MerchantLocation


def index(request):
    context = {}
    return render(request, "index.html", context)


def list_merchants_index(request):
    locations = MerchantLocation.objects.all()
    merchant_dict = {}
    for location in locations:
        merchant_dict[location.name] = Merchant.objects.filter(location=location).all()
    context = {
        'locations': merchant_dict
    }

    return render(request, "order/index.html", context)

