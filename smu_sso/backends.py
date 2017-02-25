import hashlib

from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User
import json
import logging
from smu_sso.models import SSOUser


def sso_authenticate(username=None, details=None):
    # md5 in 2017?????
    # password = hashlib.md5(json.dumps(details, sort_keys=True).encode('utf-8')).hexdigest()
    # print("password " + password)
    try:
        # Check if the user exists in Django's database
        user_details = json.loads(details)
        sso_user = SSOUser.objects.get(nric=username)

    except SSOUser.DoesNotExist:
        try:
            user = User.objects.create(username=username, password=password,
                                       first_name=user_details['Account Holder Name(s):'])
            user.set_password(password)


            sso_user = SSOUser.objects.create(account_holder_name=user_details['Account Holder Name(s):'],
                                              contact_number=user_details['Contact Number(s):'],
                                              bank_account_no=user_details['Bank Account Number:'], user=user, nric=user)
            return sso_user
        except Exception as e:
            logging.exception("Except 1")
            return None

    # Check password of the user we found
    print("checking password " + password + " " + sso_user.user.password)
    #if password == sso_user.user.password:
    if user.check_password(password):
        print("password correct!")
        return sso_user
    else:
        return None




