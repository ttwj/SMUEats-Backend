from django.conf.urls import  url

from . import views

urlpatterns = [
    url(r'^$', views.index),
    url(r'^order/$', views.list_merchants_index, name='frontend-order-index'),
    url(r'^detail/(?P<merchant_id>\d+)/$', views.store_merchant_index, name='frontend-order-merchant-index'),
]