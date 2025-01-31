from django.shortcuts import render
def index(request):
    return render(request, 'index.html')


def dashboard(request):
    # return render(request, '../faculty/templates/dashboard.html')
    return render(request, '../faculty/templates/dashboard.html')