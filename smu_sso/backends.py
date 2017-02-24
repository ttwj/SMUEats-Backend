from django.contrib.auth.hashers import check_password

from smu_sso.models import SSOUser


class SSOBackend(object):
    """
  Custom Authentication backend for SMU
  """
    supports_object_permissions = False
    supports_anonymous_user = False
    supports_inactive_user = False

    def authenticate(self, username=None, password=None):
        try:
            # Check if the user exists in Django's database
            user = SSOUser.objects.get(nric=username)
        except SSOUser.DoesNotExist:
            user = SSOUser.objects.create(nric=username, password=password, sso_user=True)
            return user

        # Check password of the user we found

        print("checking password " + password + " " + user.password)
        if check_password(password, user.password):
            return user
        return None

    # Required for the backend to work properly - unchanged in most scenarios
    def get_user(self, user_id):
        try:
            return SSOUser.objects.get(pk=user_id)
        except SSOUser.DoesNotExist:
            return None
