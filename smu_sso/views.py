from django.contrib.auth import authenticate, login
from django.shortcuts import render, redirect

# Create your views here.
from rest_framework.decorators import api_view
from rest_framework.response import Response

from frontend import views


@api_view(['POST'])
def sso(request, format=None):

    try:
        nric = request.data['nric']
        details = request.data['details']
    except:
        return Response("Invalid username/details")


    if nric and details:
        user = authenticate(nric=nric, password=details)
        if user:
            # yay we're logged in!
            login(request, user) #give da cookiez
            print("we're logged in!")
            return redirect(views.index)
        else:
            return Response("Invalid username/password combination!")






