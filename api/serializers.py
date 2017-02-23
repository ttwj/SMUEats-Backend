from rest_framework import serializers
from .models import *
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError, ObjectDoesNotExist
from rest_framework.validators import UniqueTogetherValidator
from rest_framework.relations import PrimaryKeyRelatedField

''' Quick guide to custom serializers:

To serialize -- MySerializer(my_object).data
To deserialize -- s = MySerializer(data=my_raw_python_data); assert s.is_valid(); s.validated_data  
'''


class MerchantSerializer(serializer.ModelSerializer):
    menu = PrimaryKeyRelatedField(allow_empty=True, many=True,
        queryset=MenuItem.objects.all())
    class Meta:
        model = Merchant
        fields = ('id', 'name', 'image', 'location_str', 'menu')

class OrderSerializer()