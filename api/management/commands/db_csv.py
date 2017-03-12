import csv

from decimal import Decimal
from django.core.management.base import BaseCommand
from django.template import Template, Context
from django.conf import settings

from api.models import MenuItem, Merchant


class Command(BaseCommand):
    def handle(self, *args, **options):
        with open('new_db.csv', 'r') as csvfile:
            data = csv.reader(csvfile)
            for row in data:
                print(row)
                merchant = Merchant.objects.get(id=row[1])
                item = MenuItem.objects.create(name=row[2], price=Decimal(row[3]), remarks=row[4], merchant=merchant)

