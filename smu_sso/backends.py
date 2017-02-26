import hashlib
import json

from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User

import logging
from smu_sso.models import SSOUser


def sso_authenticate(username=None, details=None):
    # md5 in 2017?????
    # password = hashlib.md5(json.dumps(details, sort_keys=True).encode('utf-8')).hexdigest()
    # print("password " + password)
    try:
        # Check if the user exists in Django's database
<<<<<<< HEAD
=======
        user_details = json.loads(details)
>>>>>>> 59abe0a5769930554530f62dca09b628fc31fd7c
        sso_user = SSOUser.objects.get(nric=username)

    except SSOUser.DoesNotExist:
        try:
            user = User.objects.create(username=username, password=password,
<<<<<<< HEAD
                                       first_name=details['Account Holder Name(s):'])


            sso_user = SSOUser.objects.create(account_holder_name=details['Account Holder Name(s):'],
                                              contact_number=details['Contact Number(s):'],
                                              bank_account_no=details['Bank Account Number:'], user=user, nric=user)
=======
                                       first_name=user_details['Account Holder Name(s):'])
            user.set_password(password)


            sso_user = SSOUser.objects.create(account_holder_name=user_details['Account Holder Name(s):'],
                                              contact_number=user_details['Contact Number(s):'],
                                              bank_account_no=user_details['Bank Account Number:'], user=user, nric=user)
>>>>>>> 59abe0a5769930554530f62dca09b628fc31fd7c
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




