from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractBaseUser
from django.db import models

# Create your models here.



class SSOUserManager(BaseUserManager):
    def create_user(self, nric, password=None):
        """
        Creates and saves a User with the given email, date of
        birth and password.
        """
        if not nric:
            raise ValueError('Users must have an NRIC')

        user = self.model(
            nric=nric
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, nric, password=None):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(
            nric=nric
        )
        user.is_admin = True
        user.set_password(password)
        user.save(using=self._db)
        return user


class SSOUser(AbstractBaseUser):
    sso_user = models.BooleanField('SSO user',
                                    editable=False,
                                    default=False)
    nric = models.CharField(max_length=40, unique=True)
    is_admin = models.BooleanField(default=False)
    USERNAME_FIELD = 'nric'

    objects = SSOUserManager()

    def get_full_name(self):
        # The user is identified by their email address
        return self.nric

    def get_short_name(self):
        # The user is identified by their email address
        return self.nric

    def __str__(self):
        return self.nric


    def has_perm(self, perm, obj=None):
        "Does the user have a specific permission?"
        # Simplest possible answer: Yes, always
        return True

    def has_module_perms(self, app_label):
        "Does the user have permissions to view the app `app_label`?"
        # Simplest possible answer: Yes, always
        return True

    @property
    def is_staff(self):
        "Is the user a member of staff?"
        # Simplest possible answer: All admins are staff
        return self.is_admin