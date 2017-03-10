import requests
from celery.decorators import task
from celery.schedules import crontab
from celery.task import periodic_task
from celery.utils.log import get_task_logger

logger = get_task_logger(__name__)


@task(name="send_sms")
def send_sms(user, message, get_number_user):
    """sends an email when feedback form is filled successfully"""
    logger.info("Sent SMS successfully")
    payload={
        'username': user.username,
        'message': message,
        'get_number_user': get_number_user.username,
        'password': "supersecurepassword1234",
    }
    r = requests.post('http://localhost:3000/v1/sms', data=payload);

    jsonResponse = r.json()
    print(jsonResponse)
    print (r.status_code);
    if r.status_code != 200 or jsonResponse['result'] != 'successful':
        logger.warning("Failed to send SMS")

@periodic_task(run_every=(crontab(minute='*/2')), name="check_order_status_change", ignore_result=True)
def task_check_order_status_change():
    """
    Saves latest image from Flickr
    """

    logger.info("Checking for shit ")
