# -*- coding: utf-8 -*-
# Generated by Django 1.10.5 on 2017-03-12 14:36
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0010_remove_menuitem_category'),
    ]

    operations = [
        migrations.AlterField(
            model_name='menuitem',
            name='remarks',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]
