from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User
import json
import logging
from smu_sso.models import SSOUser


def sso_authenticate(username=None, password=None):
    try:
        # Check if the user exists in Django's database
        dict = json.loads(password)
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        try:
            print(dict)
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

    print("checking password " + password + " " + user.password)
    if check_password(password, user.password):
        try:
            sso_user = SSOUser.objects.get(user=user)
            assert isinstance(sso_user, object)
            return sso_user
        except:
            print("Except occured 2")
            return None
    else:
        return None




