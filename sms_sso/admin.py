from django.contrib import admin

from sms_sso.models import SSOUser

admin.site.register(SSOUser)