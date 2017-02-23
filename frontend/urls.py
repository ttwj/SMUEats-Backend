from django.conf.urls import  url

from . import views

urlpatterns = [
    url(r'^$', views.index),
    url(r'^order/$', views.OrderView.as_view())
]