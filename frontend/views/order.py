import logging

from decimal import Decimal

import datetime
from django.contrib.auth.decorators import login_required
from django.shortcuts import render

# Create your views here.
from django.utils import timezone
from django.views import generic
from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.models import Order, Merchant, MerchantLocation, MenuItem, OrderItem


def register_init(request):
    return render(request, "auth/register.html")


@login_required
def index(request):
    context = {}
    return render(request, "index.html", context)


@api_view(['POST'])
@login_required
def add_cart(request):
    request.session.modified = True
    try:
        item_id = request.POST['item_id']
        item = MenuItem.objects.get(id=item_id)
        cart_item = {
            'item_id': item_id,
            'quantity': request.POST['quantity'],
            'notes': request.POST['notes'],
            'price': str(item.price)
        }
        if 'cart' in request.session:
            print(request.session['cart'])
            total = Decimal(request.session['total'])
            total += (item.price * int(request.POST['quantity']))
            request.session['total'] = str(total)
            request.session['cart'].append(cart_item)
        else:
            total = (item.price * int(request.POST['quantity']))
            request.session['total'] = str(total)
            request.session['cart'] = [cart_item]

        print({'total': str(request.session['total'])})
        return Response({'total': str(request.session['total'])})

    except:
        logging.exception("exception 3")
        return Response({'error': 'Dunno what happened'})


@api_view(['GET'])
@login_required
def del_cart(request, cart_id):
    request.session.modified = True
    try:
        if 'cart' in request.session:
            item = request.session['cart'][int(cart_id)]
            print(item)
            total = Decimal(request.session['total'])
            total -= (Decimal(item['price']) * int(item['quantity']))
            request.session['total'] = str(total)
            request.session['cart'][int(cart_id)] = None

        print({'total': str(request.session['total'])})
        return Response({'total': str(request.session['total'])})

    except:
        logging.exception("exception 3")
        return Response({'error': 'Dunno what happened'})


@login_required
def store_merchant_index(request, merchant_id):
    merchant = Merchant.objects.get(id=merchant_id)
    items = MenuItem.objects.filter(merchant=merchant)
    return render(request, "order/store.html", {'merchant': merchant, 'items': items})


@login_required
def checkout_index(request):
    try:
        orders = []
        print(request.session['cart'])
        for idx, cart_item in enumerate(request.session['cart']):
            if cart_item is not None:
                orderid = cart_item['item_id']
                item = MenuItem.objects.get(id=orderid)
                orders.append({
                    'index': idx,
                    'item': item,
                    'quantity': cart_item['quantity'],
                    'notes': cart_item['notes']
                })
        context = {'orders': orders}
        print("Checkout context")
        print(context)
        return render(request, "order/checkout-view-cart.html", context)

    except:
        logging.exception("exception @ checkout")
        return render(request, "order/checkout-view-cart.html")


@login_required
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


@login_required
def checkout_confirm_order(request):
    try:
        payment_method = Order.WALLET
        if request.POST['payment'] == 'cash':
            payment_method = Order.CASH
        order = Order.objects.create(orderer=request.user, location=request.POST['location'],
                                     payment_method=payment_method,
                                     timeout_by=timezone.now() + datetime.timedelta(
                                         minutes=int(request.POST['minutes'])))

        for idx, cart_item in enumerate(request.session['cart']):
            if cart_item is not None:
                orderid = cart_item['item_id']
                menu_item = MenuItem.objects.get(id=orderid)
                order_item = OrderItem.objects.create(order=order, menu_item=menu_item,
                                                      quantity=int(cart_item['quantity']), notes=cart_item['notes'])
        context = {
            'order': order
        }
        print(order)
        del request.session['cart']
        del request.session['total']
        return render(request, "order/placed-success.html", context)





    except Exception as e:
        print("Error in ordering")
        print(e)
        return render(request, "order/placed-error.html")