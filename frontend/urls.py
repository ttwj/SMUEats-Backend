from django.conf.urls import  url
from django.contrib import auth

from frontend.forms import LoginForm
from frontend.views import order, deliver
from frontend.views.order import register_init

urlpatterns = [
    url(r'^$', order.index, name='index'),
    url(r'^order/$', order.list_merchants_index, name='frontend-order-index'),
    url(r'^detail/(?P<merchant_id>\d+)/$', order.store_merchant_index, name='frontend-order-merchant-index'),
    url(r'^order/add_cart/$', order.add_cart),
    url(r'^order/del_cart/(?P<cart_id>\d+)/$', order.del_cart),
    url(r'^order/checkout/$', order.checkout_index, name='checkout-index'),
    url(r'^order/checkout/confirm$', order.checkout_confirm_order, name='checkout-confirm-order'),

    url(r'^login/$', auth.views.login, {'template_name': 'auth/login.html', 'authentication_form': LoginForm},
        name='login'),
    url(r'^logout/$', auth.views.logout, {'next_page': '/frontend/login'}, name='frontend-logout'),
    url(r'^register/$', register_init, name='register'),

    url(r'^deliver/$', deliver.deliver_index, name='frontend-deliver-index'),
    url(r'^deliver/details/(?P<order_id>\d+)/$', deliver.deliver_order_details, name='frontend-deliver-details'),
    url(r'^deliver/fulfil/(?P<order_id>\d+)/$', deliver.fulfil_order, name='frontend-fulfil-order')

]