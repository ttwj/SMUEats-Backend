import hashlib
import hmac
import json

import requests
from celery.schedules import crontab
from celery.task import periodic_task
from celery.task import task
from celery.utils.log import get_task_logger
from decimal import Decimal
from django.contrib.auth.models import User

logger = get_task_logger(__name__)

BB_SERVER = "http://beta.beepbeep.rocks"

def create_escrow(order, api_auth_token, pay_cash=False):
    if pay_cash:
        amount = "0.00"
    else:
        amount = str(order.total_price)

    r = perform_webhook_with_headers({
        'amount': amount
    }, BB_SERVER + "/v1/webhooks/create_escrow", {'Authorization': 'Token ' + api_auth_token})

    jsonResponse = r.json()
    print(jsonResponse)
    print (r.status_code);
    if r.status_code != 200 or jsonResponse['success'] != True:
        return False
    else:
        # extract the return Response({'success': True, 'escrow_uuid': job.id})
        order.escrow_uuid = jsonResponse['escrow_uuid']
        order.save()
        print("Updated order")
        print(order)
        return order.escrow_uuid


def perform_escrow(order):
    r = perform_webhook({
        'escrow_uuid': str(order.escrow_uuid),
    }, BB_SERVER + "/v1/webhooks/perform_escrow")

    jsonResponse = r.json()
    print(jsonResponse)
    print (r.status_code);
    if r.status_code != 200 or jsonResponse['success'] != True:
        return False
    else:
        return jsonResponse['balance']


def update_escrow_with_token(order):
    '''
     { 'destinations': [{'username': username, 'amount': '1.20'}, ..], 'verify':'token',
        'token_user': username
        'referrer': SMUEats, 'referrer_data': 'json pls'}

    '''
    commission_percentage = Decimal(0.1)  # 10%
    commission = commission_percentage * order.total_price
    amount_received = order.total_price - commission

    destinations = [
        {
            'username': order.fulfiller.username,
            'amount': str(amount_received)
        },
        {
            'username': 'smueats',
            'amount': str(commission)
        }
    ]

    referrer_data = {
        'order_id': order.id
    }

    print({
        'escrow_uuid': str(order.escrow_uuid),
        'destinations': destinations,
        'verify': 'token',
        'token_user': order.fulfiller.username,
        'referrer': 'SMUEats',
        'referrer_data': json.dumps(referrer_data),
    })
    r = perform_webhook({
        'escrow_uuid': str(order.escrow_uuid),
        'destinations': destinations,
        'verify': 'token',
        'token_user': order.fulfiller.username,
        'referrer': 'SMUEats',
        'referrer_data': json.dumps(referrer_data),
    }, BB_SERVER + "/v1/webhooks/update_escrow")

    jsonResponse = r.json()
    print(jsonResponse)
    print (r.status_code);
    if r.status_code != 200 or jsonResponse['success'] != True:
        return False
    else:
        # extract the token response
        order.token = int(jsonResponse['token'])
        order.save()
        return jsonResponse['token']


def perform_webhook_with_headers(payload, url, headers):
    json_str = json.dumps(payload)
    signature = generate_webhook_signature(json_str)
    print("signature " + signature)
    headers['X-Webhook-Signature'] = signature
    print("headers")
    print(headers)
    r = requests.post(url, data={'json': json_str}, headers=headers);
    return r


def perform_webhook(payload, url):
    json_str = json.dumps(payload)
    signature = generate_webhook_signature(json_str)
    print("signature " + signature)
    r = requests.post(url, data={'json': json_str}, headers={
        'X-Webhook-Signature': signature
    });
    return r


def generate_webhook_signature(data):
    secret = b'eatpotatoes'
    digester = hmac.new(secret, msg=data.encode('utf-8'), digestmod=hashlib.sha256)
    return digester.hexdigest()


@task(name="send_sms")
def send_sms(user_id, message, get_number_user_id):
    user = User.objects.get(id=user_id).cache()

    """sends an email when feedback form is filled successfully"""

    if get_number_user_id is None:
        payload = {
            'username': user.username,
            'message': message,
        }
    else:
        get_number_user = User.objects.get(id=get_number_user_id).cache()
        payload = {
            'username': user.username,
            'message': message,
            'get_number_user': get_number_user.username,
        }

    json_str = json.dumps(payload)
    signature = generate_webhook_signature(json_str)
    print("signature " + signature)
    r = requests.post(BB_SERVER + '/v1/webhooks/sms', data={'json': json_str}, headers={
        'X-Webhook-Signature': signature
    });

    jsonResponse = r.json()
    print(jsonResponse)
    print (r.status_code);
    if r.status_code != 200 or jsonResponse['result'] != 'successful':
        logger.warning("Failed to send SMS")
    else:
        logger.info("Sent SMS successfully")


@periodic_task(run_every=(crontab(minute='*/2')), name="check_order_status_change", ignore_result=True)
def task_check_order_status_change():
    """
    Saves latest image from Flickr
    """

    logger.info("Checking for shit ")
