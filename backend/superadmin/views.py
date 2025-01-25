from django.shortcuts import render
from django.http import HttpResponse

def superadminIndex(request):
    return HttpResponse("Superadmin Index Page")