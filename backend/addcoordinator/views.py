from django.http import HttpResponse
from django.contrib import messages
from django.contrib.auth.models import make_password
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User, auth, make_password
from django.shortcuts import render
from .models import coordinator


def add_coordinator(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        first_name = request.POST.get('first_name')
        middle_name = request.POST.get('middle_name')
        last_name = request.POST.get('last_name')
        email = request.POST.get('email')
        mobile_number = request.POST.get('mobile_number')
        gender = request.POST.get('gender')
        birth_date = request.POST.get('birth_date')
        address_line_1 = request.POST.get('address_line_1')
        address_line_2 = request.POST.get('address_line_2')
        country = request.POST.get('country')
        state = request.POST.get('state')
        city = request.POST.get('city')
        pincode = request.POST.get('pincode')
        joining_date = request.POST.get('joining_date')
        course = request.POST.get('course')
        department = request.POST.get('department')
        designation = request.POST.get('designation')
        achievements = request.POST.get('achievements')
        qualification = request.POST.get('qualification')
        coordinator_image = request.FILES['coordinator_image']

        add_coord = coordinator.objects.create(
            username=username,
            password=make_password(password),
            first_name=first_name,
            middle_name=middle_name,
            last_name=last_name,
            email=email,
            mobile_number=mobile_number,
            gender=gender,
            birth_date=birth_date,
            address_line_1=address_line_1,
            address_line_2=address_line_2,
            country=country,
            state=state,
            city=city,
            pincode=pincode,
            joining_date=joining_date,
            course=course,
            department=department,
            designation=designation,
            achievements=achievements,
            qualification=qualification,
            coordinator_image=coordinator_image
        )


<< << << < HEAD
addcoordinator.save()
return HttpResponse("Coordinator Added Successfully")
== == == =
return render(request, 'addcoordinator/add_coordinator.html', {'message': 'Coordinator added successfully'})
>>>>>> > e25313a43fb3c2575daa984b9b60d8fb844562cb
else:
    return render(request, 'addcoordinator/add_coordinator.html')
