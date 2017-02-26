import logging
from django.contrib.auth import login
from django.contrib.auth.backends import ModelBackend
import json
from django.shortcuts import render, redirect

# Create your views here.
from rest_framework.decorators import api_view
from rest_framework.response import Response

from frontend import views
from smu_sso.backends import sso_authenticate


@api_view(['POST'])
def sso(request, format=None):

    try:
        print(request.POST)
        jsonstr = request.POST['json']
        print(jsonstr)
        json_dict = json.loads(jsonstr)
        if json_dict['Campus ID:']:
            sso_user = sso_authenticate(username=json_dict['Campus ID:'], details=json_dict)
            if sso_user:
                # yay we're logged in!
                # sso_user.user.backend = ModelBackend
                login(request, sso_user.user)  # give da cookiez
                print("we're logged in!")
                # return Response("Logged in!")
                return redirect(views.index)
            else:
                return Response("Invalid username/password combination!")
    except:
        logging.exception("exception 3")
        return Response("Invalid username/details")




