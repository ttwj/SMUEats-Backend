# -*- coding: utf-8 -*-
# Generated by Django 1.10.5 on 2017-03-11 03:59
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_auto_20170311_1149'),
    ]

    operations = [
        migrations.AlterField(
            model_name='order',
            name='escrow_id',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]
