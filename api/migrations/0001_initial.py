# -*- coding: utf-8 -*-
# Generated by Django 1.10.5 on 2017-02-24 13:44
from __future__ import unicode_literals

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import uuid


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='MenuItem',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('image', models.ImageField(blank=True, null=True, upload_to='', verbose_name='Image of menu item')),
                ('price', models.DecimalField(decimal_places=2, max_digits=10)),
            ],
        ),
        migrations.CreateModel(
            name='Merchant',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('image', models.ImageField(blank=True, null=True, upload_to='', verbose_name='Image of store front')),
                ('location_str', models.CharField(max_length=100, verbose_name='Location (human readable)')),
            ],
        ),
        migrations.CreateModel(
            name='MerchantLocation',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('image', models.ImageField(blank=True, null=True, upload_to='', verbose_name='Image of location (eg. a food court)')),
            ],
        ),
        migrations.CreateModel(
            name='Order',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('location', models.TextField(blank=True)),
                ('time_placed', models.DateTimeField(default=django.utils.timezone.now)),
                ('timeout_by', models.DateTimeField(null=True)),
                ('time_committed', models.DateTimeField(blank=True, null=True)),
                ('time_fulfilled', models.DateTimeField(blank=True, null=True)),
                ('is_paid', models.BooleanField(default=False)),
                ('fulfiller', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='fulfilled_orders', to=settings.AUTH_USER_MODEL)),
                ('orderer', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='placed_orders', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='OrderConfirmCode',
            fields=[
                ('code', models.UUIDField(default=uuid.uuid4, primary_key=True, serialize=False)),
                ('time_created', models.DateTimeField(default=django.utils.timezone.now)),
                ('expire_by', models.DateTimeField()),
                ('order', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='confirm_code', to='api.Order')),
            ],
        ),
        migrations.CreateModel(
            name='OrderItem',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('quantity', models.IntegerField(default=1)),
                ('notes', models.TextField(blank=True)),
                ('menu_item', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='api.MenuItem')),
                ('order', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items', to='api.Order')),
            ],
        ),
        migrations.AddField(
            model_name='merchant',
            name='location',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='api.MerchantLocation'),
        ),
        migrations.AddField(
            model_name='menuitem',
            name='merchant',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='menu', to='api.Merchant'),
        ),
        migrations.AlterUniqueTogether(
            name='menuitem',
            unique_together=set([('name', 'merchant')]),
        ),
        migrations.AlterIndexTogether(
            name='menuitem',
            index_together=set([('name', 'merchant')]),
        ),
    ]
