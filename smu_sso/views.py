from django.contrib.auth import login
from django.contrib.auth.backends import ModelBackend

from django.shortcuts import render, redirect

# Create your views here.
from rest_framework.decorators import api_view
from rest_framework.response import Response

from frontend import views
from smu_sso.backends import sso_authenticate


@api_view(['POST'])
def sso(request, format=None):

    try:
        nric = request.data['nric']
        details = request.data['details']
    except:
        return Response("Invalid username/details")


    if nric and details:
        sso_user = sso_authenticate(username=nric, details=details)
        if sso_user:
            # yay we're logged in!
            #sso_user.user.backend = ModelBackend
            login(request, sso_user.user) #give da cookiez
            print("we're logged in!")
            #return Response("Logged in!")
            return redirect(views.index)
        else:
            return Response("Invalid username/password combination!")






