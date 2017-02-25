import hashlib

from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User
import json
import logging
from smu_sso.models import SSOUser


def sso_authenticate(username=None, details=None):
    password = hashlib.md5(json.dumps(details, sort_keys=True).encode('utf-8')).hexdigest()
    print("password " + password)
    try:
        # Check if the user exists in Django's database
        dict = json.loads(details)
        sso_user = SSOUser.objects.get(nric=username)

    except SSOUser.DoesNotExist:
        try:
            #print(dict)
            user = User.objects.create(username=username, password=password,
                                       first_name=dict['Account Holder Name(s):'])


            sso_user = SSOUser.objects.create(account_holder_name=dict['Account Holder Name(s):'],
                                              contact_number=dict['Contact Number(s):'],
                                              bank_account_no=dict['Bank Account Number:'], user=user, nric=user)
            return sso_user
        except Exception as e:
            logging.exception("Except 1")
            return None


            # Check password of the user we found

    print("checking password " + password + " " + sso_user.user.password)
    if password == sso_user.user.password:
        print("password correct!")
        return sso_user
    else:
        return None




