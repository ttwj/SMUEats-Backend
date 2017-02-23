from django.shortcuts import render

# Create your views here.
from django.views import generic

from api.models import Order, Merchant


def index(request):
    context = {}
    return render(request, "index.html", context)


class OrderView(generic.ListView):
    template_name = 'order/index.html'
    context_object_name = 'order_merchant_list'

    def get_queryset(self):
        """
        Return the last five published polls (not including those set to be
        published in the future).
        """

        return Merchant.objects.order_by('location').all()
