from django.shortcuts import render
from django.http import HttpResponse

def facultyIndex(request):
    return HttpResponse("Faculty Index Page")