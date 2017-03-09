from django.conf.urls import  url
from django.contrib import auth

from frontend.forms import LoginForm
from frontend.views import register_init
from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^order/$', views.list_merchants_index, name='frontend-order-index'),
    url(r'^detail/(?P<merchant_id>\d+)/$', views.store_merchant_index, name='frontend-order-merchant-index'),
    url(r'^order/add_cart/$', views.add_cart),
    url(r'^order/del_cart/(?P<cart_id>\d+)/$', views.del_cart),
    url(r'^order/checkout/$', views.checkout_index, name='checkout-index'),
    url(r'^order/checkout/confirm$', views.checkout_confirm_order, name='checkout-confirm-order'),

    url(r'^login/$', auth.views.login, {'template_name': 'auth/login.html', 'authentication_form': LoginForm},
        name='login'),
    url(r'^logout/$', auth.views.logout, {'next_page': '/frontend/login'}, name='frontend-logout'),
    url(r'^register/$', register_init, name='register'),

]