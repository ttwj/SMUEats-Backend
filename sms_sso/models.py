from django.contrib.auth.models import User
from django.db import models

# Create your models here.

class SSOUser(models.Model):
    user = models.ForeignKey(User)
    bank_account_no = models.CharField(max_length=30)
    contact_number = models.CharField(max_length=10)
