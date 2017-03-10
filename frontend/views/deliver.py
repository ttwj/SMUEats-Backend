from time import timezone

from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.models import MerchantLocation, Merchant, Order, OrderItem
from api.tasks import send_sms


@login_required
def deliver_index(request):
    unfufilled_orders = Order.objects.filter(time_committed=None)
    print(unfufilled_orders)
    orders = []
    for order in unfufilled_orders:
        if order.stage == Order.Stage.PLACED:
            orders.append(order)

    print(orders)

    # get paid orders, then filter the orders
    return render(request, "deliver/index.html", {'orders': orders})


@login_required
def deliver_order_details(request, order_id):
    order = Order.objects.filter(id=order_id).first()
    order_items = OrderItem.objects.filter(order=order)
    order_items_grouped = {

    }
    for order_item in order_items:
        if order_item.menu_item.merchant.name is not order_items_grouped:
            order_items_grouped[order_item.menu_item.merchant.name] = [order_item]
        else:
            order_items_grouped[order_item.menu_item.merchant.name].append(order_item)

    return render(request, "deliver/details.html", {'order': order, 'order_items_grouped': order_items_grouped})


@api_view(['GET'])
@login_required
def fulfil_order(request, order_id):
    try:
        order = Order.objects.get(id=order_id)
        order.fulfil_order(request.user)
        msg = "SMUEats: You have agreed to fulfil order #{0} ($${1}) to {2} before {3}. Contact {4} @ $NUMBER".format(
            order_id, order.total_price, order.orderer.username, timezone.localtime(order.timeout_by), order.orderer.username)
        send_sms(request.user, msg, order.orderer)
        return Response({'success': True})
    except ValueError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        print(e)
        return Response({'error': 'Internal error'}, status=status.HTTP_400_BAD_REQUEST)
