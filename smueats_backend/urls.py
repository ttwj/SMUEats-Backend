"""smueats_backend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.10/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django import contrib
from django.conf.urls import url, include
from django.contrib import admin
from django.conf.urls.static import static
from django.contrib.auth import views
import frontend.urls
import sms_sso.urls
from simple_sso.sso_client.client import Client
from smueats_backend import settings


sso_client = Client(settings.SSO_SERVER, settings.SSO_PUBLIC_KEY, settings.SSO_PRIVATE_KEY)


urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^frontend/', include(frontend.urls.urlpatterns)),
    url(r'^sms_sso/', include(sms_sso.urls.urlpatterns)),
    url(r'^sso/', include(sso_client.get_urls())),





] + static(settings.STATIC_URL)
