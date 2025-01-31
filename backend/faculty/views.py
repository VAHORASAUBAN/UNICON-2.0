from django.shortcuts import render
from django.http import HttpResponse

def facultyIndex(request):
    return render(request, 'faculty.html')

def dashboard(request):
    return render(request, 'dashboard.html')

def facultyprofile(request):
    return render(request, 'facultyprofile.html')
# def dashboard(request):
#     return render(request, 'faculty.html')

def facultysubjects(request):
    return render(request, 'facultysubjects.html')

def attendance(request):
    return render(request, 'attendance.html')

def subjects(request):
    return render(request, 'subjects.html')

def logout(request):
    return render(request, '../root/templates/index.html')