import logging

from decimal import Decimal
from django.shortcuts import render

# Create your views here.
from django.views import generic
from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.models import Order, Merchant, MerchantLocation, MenuItem


def index(request):
    context = {}
    return render(request, "index.html", context)


@api_view(['GET'])
def add_cart(request, item_id):
    try:
        item = MenuItem.objects.get(id=item_id)
        if 'cart' in request.session:
            total = Decimal(request.session['total'])
            total += item.price
            request.session['total'] = str(total)
            request.session['cart'].append(item_id)
        else:
            request.session['total'] = str(item.price)
            request.session['cart'] = [item_id]
        print({'total': str(request.session['total'])})
        return Response({'total': str(request.session['total'])})

    except:
        logging.exception("exception 3")
        return Response({'error': 'Dunno what happened'})


@api_view(['GET'])
def del_cart(request, item_id):
    try:
        item = MenuItem.objects.get(id=item_id)
        if 'cart' in request.session:
            total = Decimal(request.session['total'])
            total -= item.price
            request.session['total'] = str(total)
            request.session['cart'].remove(item_id)

        print({'total': str(request.session['total'])})
        return Response({'total': str(request.session['total'])})

    except:
        logging.exception("exception 3")
        return Response({'error': 'Dunno what happened'})


def store_merchant_index(request, merchant_id):
    merchant = Merchant.objects.get(id=merchant_id)
    items = MenuItem.objects.filter(merchant=merchant)
    return render(request, "order/store.html", {'merchant': merchant, 'items': items})


def checkout_index(request):
    try:
        orders = []
        print(request.session['cart'])
        for orderid in request.session['cart']:
            orders.append(MenuItem.objects.get(id=orderid))
        context = {'orders': orders}
        return render(request, "order/checkout-view-cart.html", context)

    except:
        logging.exception("exception @ checkout")
        return render(request, "order/checkout-view-cart.html")


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


def place_order(request):
    order = Order.objects.create({

    })
    return render(request, "order/placed.html", context)
