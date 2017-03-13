from time import timezone, localtime

import pytz
from django.contrib.auth.decorators import login_required
from django.db import transaction
from django.shortcuts import render
from pytz.reference import Local
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from api.models import MerchantLocation, Merchant, Order, OrderItem
from api.tasks import send_sms, update_escrow_with_token, perform_escrow, create_escrow


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
        if order_item.menu_item.merchant.name not in order_items_grouped:
            order_items_grouped[order_item.menu_item.merchant.name] = [order_item]
        else:
            order_items_grouped[order_item.menu_item.merchant.name].append(order_item)

    return render(request, "deliver/details.html", {'order': order, 'order_items_grouped': order_items_grouped})


@api_view(['POST'])
@login_required
def fulfil_order(request, order_id):
    try:
        with transaction.atomic():
            order = Order.objects.get(id=order_id)

            #  order.timeout_by.astimezone(timezone('Asia/Singapore')

            # create_escrow(order)
            order.fulfil_order(request.user)

            # generate the escrow (synchronous)
            escrow_token = update_escrow_with_token(order)

            if escrow_token is False:
                raise ValueError('Could not create escrow')

            print(order.timeout_by)
            msg = "SMOOeats: You have agreed to fulfil order #{0} ($${1}) to {2} before {3}. Contact {4} @ $NUMBER".format(
                order_id, order.total_price, order.orderer.username, str(order.timeout_by.astimezone(Local)),
                order.orderer.username)
            send_sms.delay(request.user.id, msg, order.orderer.id)

            wait_duration_min = (order.timeout_by - order.time_committed).minutes
            msg = "SMOOeats: {0} ($NUMBER) has accepted your order #{1} ($${2}). " \
                  "Your order should arrive within {3} mins. " \
                  "Your confirmation token is {4}. ONLY show your confirmation token to {5} AFTER you have received your food/drinks from them.".format(
                order.fulfiller.username, order.id, order.total_price, wait_duration_min, escrow_token,
                order.fulfiller.username
            )

            send_sms.delay(order.orderer_id, msg, order.fulfiller_id)

            return Response({'success': True})
    except ValueError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        # except Exception as e:
        #   print(e)
        #   return Response({'error': 'Internal error'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@login_required
def completed_order(request):
    try:
        order = request.user.fulfilled_orders.filter(time_fulfilled__isnull=True).first()
        if str(order.token) == request.POST['token']:
            with transaction.atomic():

                order.close_order()
                escrow_result = perform_escrow(order)
                new_balance = escrow_result['balance']

                fulfiler_balance = None

                if order.fulfiller.username in new_balance['dest_balances']:
                    fulfiler_balance = new_balance['dest_balances'][order.fulfiller.username]


                if escrow_result is False:
                    raise ValueError('Could not perform escrow')

                msg = "SMOOeats: Your order is completed! You paid {0} to {1} and have {2} left in your wallet. " \
                      "Thanks for using SMOOeats :)".format(
                    order.total_price, order.fulfiller.username, str(new_balance))
                send_sms.delay(order.orderer_id, msg, None)

                if fulfiler_balance is None:
                    msg = "SMOOeats: Your delivery is completed! You received a wallet transfer from {0}. Thanks for " \
                          "using SMOOeats :)".format(
                        order.orderer.username)
                    send_sms.delay(order.fulfiller_id, msg, None)
                else:
                    msg = "SMOOeats: Your delivery is completed! You received a wallet transfer from {0} and " \
                          "have {1} now!" \
                          " Thanks for using SMOOeats :)".format(
                        order.orderer.username, str(fulfiler_balance))
                    send_sms.delay(order.fulfiller_id, msg, None)


                return Response({'success': True})
        else:
            return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)

    except ValueError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
