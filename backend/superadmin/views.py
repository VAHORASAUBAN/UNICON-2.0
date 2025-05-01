# Imports
from .models import AttendanceSession, Student, AttendanceRecord
from .serializers import TimetableSerializer, PlacementSerializer
from .models import Student, Timetable, Course, department, Batch, Subject, Placement, Teacher
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.core.files.storage import FileSystemStorage
from django.shortcuts import render, redirect, get_object_or_404
from django.utils.timezone import now
import qrcode
import io
import base64
from django.shortcuts import render
from django.http import HttpResponse
from .models import AttendanceSession, Subject, Teacher


from django.shortcuts import render
from django.utils.timezone import now
import qrcode
import io
import base64
from django.http import HttpResponse
from .models import AttendanceSession
from django.contrib import messages
from django.contrib.auth.hashers import check_password, make_password
import pandas as pd
import os
from django.shortcuts import render, redirect
from django.contrib import messages
from django.core.files import File
from django.contrib.auth.hashers import make_password
from .models import Teacher, department, Course
from datetime import datetime
from django.http import HttpResponse, JsonResponse
from django.urls import reverse
from django.contrib.auth import authenticate, login, logout
import datetime
from django.utils import timezone
from django.core.files import File
from collections import defaultdict, OrderedDict
from django.utils.timezone import now  # Add this import
from .serializers import *
from django.contrib.auth.decorators import login_required
import qrcode
import io
import base64
from datetime import datetime, timedelta, time, date


from django.utils.dateparse import parse_datetime
from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Q
from django.views.decorators.csrf import csrf_exempt

from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken

from addcoordinator.models import coordinator

import pandas as pd
import os
import json
import traceback


def add_blog(request):
    return render(request, 'superadmin/add-blog.html')


def blog_details(request):
    return render(request, 'superadmin/blog-details.html')


def blog(request):
    return render(request, 'superadmin/blog.html')


def calendar(request):
    return render(request, 'superadmin/calendar.html')


def faculty_dash(request):
    faculty_id = request.session.get("faculty_id")

    if not faculty_id:
        return redirect('login')

    try:
        faculty = Teacher.objects.get(faculty_id=faculty_id)
    except Teacher.DoesNotExist:
        return redirect('login')

    today_day = now().strftime('%A')  # Use 'now' from timezone

    todays_lectures = Timetable.objects.filter(
        faculty_name=faculty,
        day=today_day
    ).select_related('timetable_subject_name', 'course', 'timetable_department')

    context = {
        'todays_lectures': todays_lectures,
    }

    return render(request, 'faculty/faculty_dash.html', context)


def edit_blog(request):
    return render(request, 'superadmin/edit-blog.html')


def edit_profile(request):
    return render(request, 'superadmin/edit-profile.html')


def edit_teacher(request, faculty_id):

    all_departments = department.objects.all()
    all_courses = Course.objects.all()
    teacher = Teacher.objects.get(faculty_id=faculty_id)
    context = {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'teacher': teacher
    }

    if request.method == "POST":

        teacher.firstname = request.POST.get('firstname')
        teacher.middlename = request.POST.get('middlename', '')
        teacher.lastname = request.POST.get('lastname')
        teacher.email = request.POST.get('email')
        new_password = request.POST.get('password')
        if new_password:
            teacher.password = make_password(new_password)
        teacher.mobile_number = request.POST.get('mobile_number')
        teacher.gender = request.POST.get('gender')
        teacher.birth_date = request.POST.get('birth_date')
        teacher.address_line_1 = request.POST.get('address_line_1')
        teacher.address_line_2 = request.POST.get('address_line_2', '')
        country = request.POST.get('country')
        if country:
            teacher.country = country
        else:
            print("No country provided!")

        state = request.POST.get('state')
        if state:
            teacher.state = state
        else:
            print("No state provided!")

        city = request.POST.get('city')
        if city:
            teacher.city = city
        else:
            print("No city provided!")

        teacher.pincode = request.POST.get('pincode')
        teacher.joining_date = request.POST.get('joining_date')
        department_id = request.POST.get('department')
        course_id = request.POST.get('course')
        teacher.designations = request.POST.get('designations')
        teacher.achievements = request.POST.get('achievements', '')
        teacher.qualification = request.POST.get('qualification')
        if department_id:
            teacher.department = department.objects.get(id=department_id)

        if course_id:
            teacher.course = Course.objects.get(id=course_id)
        if 'pic' in request.FILES:
            teacher.pic = request.FILES['pic']
        teacher.save()
        return redirect(f'/edit_teacher/{teacher.faculty_id}?success=1')

    return render(request, 'superadmin/edit-teacher.html', context)


def index(request):
    all_students = Student.objects.all()
    all_teachers = Teacher.objects.all()
    all_departments = department.objects.all()
    all_courses = Course.objects.all()
    context = {
        'all_students': all_students,
        'all_teachers': all_teachers,
        'all_departments': all_departments,
        'all_courses': all_courses
    }
    return render(request, 'superadmin/index.html', context)


def my_profile(request):
    return render(request, 'superadmin/my-profile.html')


def profile(request):

    username = request.session.get('username')

    if username:
        try:

            coordinator_data = coordinator.objects.get(username=username)
            return render(request, 'superadmin/profile.html', {'coordinator_data': coordinator_data})
        except coordinator.DoesNotExist:
            return render(request, 'superadmin/profile.html', {'error': 'Coordinator does not exist.'})
    else:
        return render(request, 'superadmin/login.html', {'error': 'You need to log in first.'})


def sidebar(request):
    return render(request, 'superadmin/sidebar.html')


def add_subject(request):
    return render(request, 'superadmin/add-subject.html')


def edit_subject(request, id):
    subject = Subject.objects.get(id=id)
    all_courses = Course.objects.all()
    all_batches = Batch.objects.all()
    all_departments = department.objects.all()
    context = {
        'subject': subject,
        'all_courses': all_courses,
        'all_batches': all_batches,
        'all_departments': all_departments
    }

    if request.method == "POST":
        subject.subject_code = request.POST.get('subject_code')
        subject.subject_name = request.POST.get('subject_name')
        department_id = request.POST.get('department')
        course_id = request.POST.get('course')
        batch_id = request.POST.get('batch')
        subject.semester = request.POST.get('semester')
        if department_id:
            subject.subject_department = department.objects.get(
                id=department_id)
        if course_id:
            subject.subject_course = Course.objects.get(id=course_id)

        if batch_id:
            subject.subject_batch = Batch.objects.get(id=batch_id)

        subject.save()
        return redirect(f'/edit_subject/{subject.id}?success=1')
    return render(request, 'superadmin/edit-subject.html', context)

def add_batch(request):
    all_courses = Course.objects.all()

    if request.method == "POST":
        batch_start_year = request.POST.get('batch_start_year')
        batch_end_year = request.POST.get('batch_end_year')
        course_id = request.POST.get('course')

        if not (batch_start_year and batch_end_year and course_id):
            context = {
                'add_batch_error': "Please fill all required fields.",
                'all_courses': all_courses
            }
            return render(request, 'superadmin/add-batch.html', context)
        else:
            Batch.objects.create(
                batch_start_year=batch_start_year,
                batch_end_year=batch_end_year,
                course=Course.objects.get(id=course_id)
            )
            return redirect('all_batch')  # Use POST-Redirect-GET
    else:
        context = {'all_courses': all_courses}
        return render(request, 'superadmin/add-batch.html', context)

def delete_batch(request, id):
    delete_batch_id = Batch.objects.get(id=id)
    delete_batch_id.delete()
    return redirect('/all_batch')


def all_batch(request):
    try:
        all_batches = Batch.objects.all()
        all_courses = Course.objects.all()

        start_year = request.GET.get('start_year')
        end_year = request.GET.get('end_year')
        course_id = request.GET.get('course')

        if start_year:
            all_batches = all_batches.filter(batch_start_year=start_year)
        if end_year:
            all_batches = all_batches.filter(batch_end_year=end_year)
        if course_id:
            all_batches = all_batches.filter(course__id=course_id)

        context = {
            'all_batches': all_batches,
            'all_courses': all_courses,
        }
        return render(request, 'superadmin/all-batch.html', context)

    except Exception as e:
        messages.error(request, f"An error occurred: {str(e)}")
        return render(request, 'superadmin/all-batch.html', {'all_batches': [], 'all_courses': []})


def all_subject(request):
    try:
        all_subjects = Subject.objects.all()

        # Get filter values
        subject_id = request.GET.get('subject_id')
        subject_name = request.GET.get('subject_name')
        department_id = request.GET.get('department')
        course_id = request.GET.get('course')
        batch_id = request.GET.get('batch')

        if subject_id:
            all_subjects = all_subjects.filter(
                subject_code__icontains=subject_id)
        if subject_name:
            all_subjects = all_subjects.filter(
                subject_name__icontains=subject_name)
        if department_id:
            all_subjects = all_subjects.filter(
                subject_department__id=department_id)
        if course_id:
            all_subjects = all_subjects.filter(subject_course__id=course_id)
        if batch_id:
            all_subjects = all_subjects.filter(subject_batch__id=batch_id)

        context = {
            'all_subjects': all_subjects,
            'all_departments': department.objects.all(),
            'all_courses': Course.objects.all(),
            'all_batches': Batch.objects.all(),
        }
        return render(request, 'superadmin/all-subject.html', context)

    except Exception as e:
        messages.error(request, f"Error fetching subjects: {str(e)}")
        return render(request, 'superadmin/all-subject.html', {'all_subjects': []})


def timetable(request):
    return render(request, 'superadmin/timetable.html')


def format_time_to_am_pm(time_str):
    """Helper function to format time in 'HH:MM' format to 'H:MM AM/PM' format."""
    time_obj = datetime.strptime(time_str, '%H:%M')
    return time_obj.strftime('%I:%M %p')


def parse_time_string(time_str):
    fmt = "%I.%M %p"
    return datetime.strptime(time_str.strip(), fmt).time()


def show_timetable(request):
    # Get selected filter values from request
    department_name = request.GET.get('department', '')
    course = request.GET.get('course', '')
    semester = request.GET.get('semester', '')
    division = request.GET.get('division', '')

    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

    time_slots = OrderedDict([
        ("7:30 AM - 8:25 AM", (parse_time_string("7.30 AM"), parse_time_string("8.25 AM"))),
        ("8:25 AM - 9:20 AM", (parse_time_string("8.25 AM"), parse_time_string("9.20 AM"))),
        ("9:30 AM - 10:25 AM", (parse_time_string("9.30 AM"),
         parse_time_string("10.25 AM"))),
        ("10:25 AM - 11:20 AM",
         (parse_time_string("10.25 AM"), parse_time_string("11.20 AM"))),
        ("11:30 AM - 12:25 PM",
         (parse_time_string("11.30 AM"), parse_time_string("12.25 PM"))),
        ("12:25 PM - 1:20 PM",
         (parse_time_string("12.25 PM"), parse_time_string("1.20 PM"))),
    ])

    timetable = Timetable.objects.all()

    if department_name:
        try:
            dept_obj = department.objects.get(department_name=department_name)
            timetable = timetable.filter(timetable_department=dept_obj)
        except department.DoesNotExist:
            timetable = Timetable.objects.none()

    if course:
        try:
            course_obj = Course.objects.get(course_name=course)
            timetable = timetable.filter(course=course_obj)
        except Course.DoesNotExist:
            timetable = Timetable.objects.none()
    if semester:
        timetable = timetable.filter(semester=semester)
    if division:
        timetable = timetable.filter(division=division)

    timetable_matrix = []

    for slot_label, (slot_start, slot_end) in time_slots.items():
        row = {'time': slot_label}
        for day in days:
            lecture = None
            for entry in timetable:
                if entry.day != day:
                    continue
                entry_start = parse_time_string(entry.lecture_start_time)
                entry_end = parse_time_string(entry.lecture_end_time)
                if entry_start and entry_end and slot_start <= entry_start < slot_end:
                    lecture = entry
                    break
            row[day] = lecture
        timetable_matrix.append(row)

    context = {
        'timetable_matrix': timetable_matrix,
        'days': days,
        'department': department_name,
        'course': course,
        'semester': semester,
        'division': division,
        'departments': department.objects.all(),
        'courses': Course.objects.all(),
    }

    return render(request, 'superadmin/show_timetable.html', context)


def login_view(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        role = request.POST.get('role')

        try:
            if role == "faculty":
                user = Teacher.objects.get(faculty_id=username)
                if check_password(password, user.password):
                    request.session['faculty_id'] = user.faculty_id
                    print(f"Logged in as: {user.faculty_id}")
                    messages.success(request, "Login successful!")
                    # Use redirect with reverse
                    # Redirect to the main page
                    return redirect('/faculty_dash/')

            if role == "coordinator":
                user = coordinator.objects.get(username=username)
                if check_password(password, user.password):
                    request.session['username'] = user.username
                    messages.success(request, "Login successful!")
                    return redirect('index')  # Redirect to the main page
                else:
                    messages.error(
                        request, "Invalid credentials. Please try again.")

            else:
                messages.error(request, "Invalid role selected.")

        except coordinator.DoesNotExist:
            messages.error(request, "Coordinator does not exist.")
        except Teacher.DoesNotExist:
            messages.error(request, "Teacher does not exist.")
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")

        # Always render login page after handling POST
        return render(request, 'superadmin/login.html')
    else:
        # For GET requests, render the login form
        return render(request, 'superadmin/login.html')


def logout_view(request):
    request.session.flush()
    messages.success(request, "You have been logged out successfully.")
    return render(request, 'superadmin/login.html')


def add_department(request):
    if request.method == "POST":
        department_name = request.POST.get('department_name')
        department_start_date = request.POST.get('department_start_date')

        try:
            if not department_name or not department_start_date:
                messages.warning(request, "All fields are required.")
                return render(request, 'superadmin/add-department.html')

            save_department = department(
                department_name=department_name,
                department_start_date=department_start_date
            )
            save_department.save()
            messages.success(request, "Department added successfully!")
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")

    return render(request, 'superadmin/add-department.html')


def all_department(request):
    try:
        all_department = department.objects.all()
        if not all_department:
            messages.warning(request, "No departments found.")
    except Exception as e:
        messages.error(
            request, f"An error occurred while fetching departments: {str(e)}")
        all_department = []

    return render(request, 'superadmin/all-department.html', {'all_department': all_department})


def delete_department(request, id):
    deleteDepartment = department.objects.get(id=id)
    deleteDepartment.delete()
    return redirect('/all_department')


def add_course(request):
    all_department = department.objects.all()
    if request.method == "POST":
        course_name = request.POST.get('course_name')
        course_total_semesters = request.POST.get('course_total_semesters')
        department_id = request.POST.get('course_department')

        save_department = department.objects.get(id=department_id)

        course = Course.objects.create(
            course_name=course_name,
            course_total_semesters=course_total_semesters,
            course_department=save_department,
        )
        return render(request, 'superadmin/add-course.html', {'all_department': all_department})

    else:
        return render(request, 'superadmin/add-course.html', {'all_department': all_department})


def all_course(request):
    courses = Course.objects.all()
    all_departments = department.objects.all()

    name = request.GET.get('name')
    dept_id = request.GET.get('department')

    if name:
        courses = courses.filter(course_name__icontains=name)
    if dept_id:
        courses = courses.filter(course_department__id=dept_id)

    return render(request, 'superadmin/all-course.html', {
        'course': courses,
        'all_departments': all_departments
    })


def delete_course(request, id):
    deleteCourse = Course.objects.get(id=id)
    deleteCourse.delete()
    return redirect('/all_course')


def add_student(request):
    all_departments = department.objects.all()
    all_courses = Course.objects.all()
    error_message = None  # Initialize error message

    if request.method == "POST":
        try:
            # DEBUG: Show POST data in terminal
            print("=== POST DATA ===")
            print(request.POST)
            print("=== FILES DATA ===")
            print(request.FILES)

            # Validate and extract basic fields
            enrollment = request.POST.get('enrollment')
            if not enrollment or not enrollment.isdigit():
                raise ValueError("Enrollment number must be a valid number.")
            enrollment = int(enrollment)

            firstname = request.POST.get('firstname')
            lastname = request.POST.get('lastname')
            email = request.POST.get('email')
            password = request.POST.get('password')

            if not all([firstname, lastname, email, password]):
                raise ValueError(
                    "Firstname, Lastname, Email, and Password are required.")

            # ForeignKey validation
            department_id = request.POST.get('student_department')
            course_id = request.POST.get('course')

            # Handling department and course lookup
            try:
                student_department = department.objects.get(id=department_id)
                course = Course.objects.get(id=course_id)
            except ObjectDoesNotExist:
                raise ValueError("Invalid department or course selected.")

            # Create the Student
            student = Student.objects.create(
                enrollment=enrollment,
                firstname=firstname,
                middlename=request.POST.get('middlename', ''),
                lastname=lastname,
                email=email,
                password=password,  # Will be hashed in model's save()
                mobile_number=request.POST.get('mobile_number'),
                gender=request.POST.get('gender'),
                birth_date=request.POST.get('birth_date'),
                address_line_1=request.POST.get('address_line_1'),
                address_line_2=request.POST.get('address_line_2', ''),
                country=request.POST.get('country'),
                state=request.POST.get('state'),
                city=request.POST.get('city'),
                pincode=request.POST.get('pincode'),
                student_department=student_department,
                course=course,
                semester=int(request.POST.get('semester')),
                division=request.POST.get('division'),
                student_image=request.FILES.get('student_image')
            )

            # Success page redirection (you can change this as needed)
            return redirect('add_student')

        except ValueError as ve:
            # Value errors should be user-friendly
            error_message = str(ve)
        except Exception as e:
            # General errors
            print("Error in form submission:", e)
            error_message = "There was an issue with your submission. Please try again."

    return render(request, 'superadmin/add-student.html', {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'error_message': error_message  # Passing error message to template
    })


def all_students(request):
    all_students = Student.objects.all()
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    student_id = request.GET.get('student_id')
    dept_name = request.GET.get('department')
    course_name = request.GET.get('course')
    semester = request.GET.get('semester')
    division = request.GET.get('division')

    if student_id:
        all_students = all_students.filter(enrollment__icontains=student_id)

    if dept_name:
        try:
            dept_obj = department.objects.get(department_name=dept_name)
            all_students = all_students.filter(student_department=dept_obj)
        except department.DoesNotExist:
            all_students = Student.objects.none()

    if course_name:
        try:
            course_obj = Course.objects.get(course_name=course_name)
            all_students = all_students.filter(course=course_obj)
        except Course.DoesNotExist:
            all_students = Student.objects.none()

    if semester:
        all_students = all_students.filter(semester=semester)

    if division:
        all_students = all_students.filter(division=division)

    context = {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'all_students': all_students
    }
    return render(request, 'superadmin/all-students.html', context)


def edit_student(request, id):
    student = get_object_or_404(Student, id=id)
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    if request.method == "POST":

        student.enrollment = request.POST.get('enrollment')
        student.firstname = request.POST.get('firstname')
        student.middlename = request.POST.get('middlename')
        student.lastname = request.POST.get('lastname')
        student.email = request.POST.get('email')

        new_password = request.POST.get('password')
        if new_password:
            student.password = make_password(new_password)

        student.mobile_number = request.POST.get('mobile_number')
        student.gender = request.POST.get('gender')
        student.birth_date = request.POST.get('birth_date')
        student.address_line_1 = request.POST.get('address_line_1')
        student.address_line_2 = request.POST.get('address_line_2')

        # Fallbacks for country/state/city
        country = request.POST.get('country')
        if country:
            student.country = country
        else:
            print("No country provided!")

        state = request.POST.get('state')
        if state:
            student.state = state
        else:
            print("No state provided!")

        city = request.POST.get('city')
        if city:
            student.city = city
        else:
            print("No city provided!")

        student.pincode = request.POST.get('pincode')
        department_id = request.POST.get('student_department')
        course_id = request.POST.get('course')
        student.semester = request.POST.get('semester')
        student.division = request.POST.get('division')

        if department_id:
            student.student_department = department.objects.get(
                id=department_id)
        if course_id:
            student.course = Course.objects.get(id=course_id)

        if 'student_image' in request.FILES:
            student.student_image = request.FILES['student_image']

        student.save()
        return redirect('edit_student', id=student.id)

    context = {
        'student': student,
        'all_departments': all_departments,
        'all_courses': all_courses
    }
    return render(request, 'superadmin/edit-student.html', context)


def delete_student(request, id):
    deleteStudent = Student.objects.get(id=id)
    deleteStudent.delete()
    return redirect('/all_students')


def add_teacher(request):
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    if request.method == "POST":
        try:
            # Faculty ID Validation
            faculty_id = request.POST.get('faculty_id')
            if not faculty_id:
                raise ValueError("Faculty ID is required.")

            firstname = request.POST.get('firstname')
            middlename = request.POST.get('middlename')
            lastname = request.POST.get('lastname')
            email = request.POST.get('email')
            password = request.POST.get('password')
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
            course_id = request.POST.get('course')
            department_id = request.POST.get('department')
            designations = request.POST.get('designations')
            achievements = request.POST.get('achievements', '')
            qualification = request.POST.get('qualification')
            pic = request.FILES.get('pic')

            # Validate Foreign Keys
            teacher_department = department.objects.get(id=department_id)
            course = Course.objects.get(id=course_id)

            # Create Teacher
            teacher = Teacher.objects.create(
                faculty_id=faculty_id,
                firstname=firstname,
                middlename=middlename,
                lastname=lastname,
                email=email,
                password=make_password(password),
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
                department=teacher_department,
                designations=designations,
                achievements=achievements,
                qualification=qualification,
                pic=pic
            )
            print(f"Teacher created: {teacher}")
            return redirect('add_teacher')

        except department.DoesNotExist as e:
            print("Department does not exist:", e)
        except Course.DoesNotExist as e:
            print("Course does not exist:", e)
        except ValueError as e:
            print("Validation error:", e)
        except Exception as e:
            print("Unexpected error:", e)

    return render(request, 'superadmin/add-teacher.html', {
        'all_departments': all_departments,
        'all_courses': all_courses
    })


def all_teachers(request):
    all_teachers = Teacher.objects.all()

    faculty_id = request.GET.get('faculty_id')
    course = request.GET.get('course')
    department_id = request.GET.get('department')
    faculty_name = request.GET.get('faculty_name')

    if faculty_id:
        all_teachers = all_teachers.filter(faculty_id__icontains=faculty_id)

    if course:
        all_teachers = all_teachers.filter(course_id=course)

    if department_id:
        all_teachers = all_teachers.filter(department_id=department_id)

    if faculty_name:
        all_teachers = all_teachers.filter(
            models.Q(firstname__icontains=faculty_name) |
            models.Q(middlename__icontains=faculty_name) |
            models.Q(lastname__icontains=faculty_name)
        )

    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    context = {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'all_teachers': all_teachers
    }
    return render(request, 'superadmin/all-teachers.html', context)


def delete_teacher(request, id):
    deleteTeacher = Teacher.objects.get(id=id)
    deleteTeacher.delete()
    return redirect('/all_teachers')


def faculty_individual_profile(request, faculty_id):

    print(f"Looking for teacher with faculty_id: {faculty_id}")
    try:
        teacher = Teacher.objects.get(faculty_id=faculty_id)
        print(f"Retrieved teacher: {teacher}")
        return render(request, 'superadmin/faculty_individual_profile.html', {'teacher': teacher})
    except Teacher.DoesNotExist:
        print("Teacher does not exist.")
        return render(request, 'superadmin/faculty_individual_profile.html', {'error': 'Teacher does not exist.'})


def parse_date(date_value):
    try:
        if pd.isna(date_value) or date_value == '':
            return None

        if isinstance(date_value, pd.Timestamp):
            return date_value.strftime('%Y-%m-%d')

        possible_formats = ['%d-%m-%Y', '%m-%d-%Y', '%Y-%m-%d']

        for fmt in possible_formats:
            try:

                return datetime.strptime(date_value, fmt).strftime('%Y-%m-%d')
            except ValueError:
                continue

        raise ValueError(f"Invalid date format: {date_value}")

    except Exception as e:
        return None

# Date parser


def parse_custom_date(date_str):
    try:
        return datetime.strptime(date_str, "%d-%m-%Y").date()
    except Exception as e:
        print(f"Date parsing error for '{date_str}': {e}")
        return None


def parse_custom_date(date_str):
    """ Safely parse multiple date formats """
    for fmt in ("%Y-%m-%d", "%d-%m-%Y", "%m/%d/%Y"):
        try:
            return datetime.strptime(date_str, fmt).date()
        except ValueError:
            continue
    return None  # Will be stored as NULL if invalid


def add_teachers_bulk(request):
    if request.method == "POST":
        IMAGE_UPLOAD_PATH = "media/teacher_images/"
        uploaded_file = request.FILES.get('file')

        # ✅ Support for CSV and Excel files
        if not uploaded_file or not (
            uploaded_file.name.endswith(
                '.csv') or uploaded_file.name.endswith(('.xlsx', '.xls'))
        ):
            messages.error(
                request, "Invalid file format! Please upload a CSV or Excel file.")
            return redirect('add_teachers_bulk')

        # ✅ Read file using pandas
        try:
            if uploaded_file.name.endswith('.csv'):
                data = pd.read_csv(uploaded_file).fillna('')
            else:
                data = pd.read_excel(uploaded_file).fillna('')
        except Exception as e:
            messages.error(request, f"Error reading file: {str(e)}")
            return redirect('add_teachers_bulk')

        teacher_objects = []
        image_files = []

        for index, row in data.iterrows():
            try:
                row = row.apply(lambda x: x.strip()
                                if isinstance(x, str) else x)
                print(f"Processing row {index + 1}: {row.to_dict()}")

                # ✅ Validate department
                try:
                    teacher_department = department.objects.get(
                        id=row['department'])
                except department.DoesNotExist:
                    messages.error(
                        request, f"Row {index + 1}: Department ID {row['department']} does not exist.")
                    continue

                # ✅ Validate course
                try:
                    course = Course.objects.get(id=row['course'])
                except Course.DoesNotExist:
                    messages.error(
                        request, f"Row {index + 1}: Course ID {row['course']} does not exist.")
                    continue

                # ✅ Handle image
                pic_path = row['pic']
                pic_file = None
                try:
                    full_pic_path = os.path.join(IMAGE_UPLOAD_PATH, pic_path)
                    if pic_path and os.path.exists(full_pic_path):
                        img_file = open(full_pic_path, 'rb')
                        pic_file = File(img_file, name=pic_path)
                        image_files.append(img_file)
                    else:
                        print(
                            f"Row {index + 1}: Image not found at {full_pic_path}")
                except Exception as e:
                    print(f"Row {index + 1}: Error loading image: {e}")

                # ✅ Create Teacher object
                teacher = Teacher(
                    faculty_id=row['faculty_id'],
                    firstname=row['firstname'],
                    middlename=row['middlename'],
                    lastname=row['lastname'],
                    email=row['email'],
                    password=make_password(row['password']),
                    mobile_number=row['mobile_number'],
                    gender=row['gender'],
                    birth_date=parse_custom_date(row['birth_date']),
                    address_line_1=row['address_line_1'],
                    address_line_2=row['address_line_2'],
                    country=row['country'],
                    state=row['state'],
                    city=row['city'],
                    pincode=row['pincode'],
                    joining_date=parse_custom_date(row['joining_date']),
                    course=course,
                    department=teacher_department,
                    designations=row['designations'],
                    achievements=row['achievements'],
                    qualification=row['qualification'],
                )

                if pic_file:
                    teacher.pic.save(pic_path, pic_file)

                teacher_objects.append(teacher)

            except Exception as e:
                messages.error(
                    request, f"Row {index + 1}: Unexpected error: {str(e)}")
                print(f"Unexpected error at row {index + 1}: {e}")

        try:
            for teacher in teacher_objects:
                teacher.save()

            for img_file in image_files:
                img_file.close()

            messages.success(
                request, f"{len(teacher_objects)} teacher(s) added successfully!")

        except Exception as e:
            messages.error(request, f"Error saving teachers: {str(e)}")
            print("❌ Database save error:", str(e))

        return render(request, 'superadmin/add_teachers_bulk.html')

    return render(request, 'superadmin/add_teachers_bulk.html')


def add_students_bulk(request):
    if request.method == "POST":
        IMAGE_UPLOAD_PATH = "media/student_images/"
        uploaded_file = request.FILES.get('file')

        # Validate File Type
        if not uploaded_file:
            messages.error(request, "No file uploaded.")
            return redirect('add_students_bulk')

        try:
            if uploaded_file.name.endswith('.csv'):
                data = pd.read_csv(uploaded_file).fillna('')
            elif uploaded_file.name.endswith(('.xlsx', '.xls')):
                data = pd.read_excel(uploaded_file).fillna('')
            else:
                messages.error(
                    request, "Unsupported file format. Upload CSV or Excel.")
                return redirect('add_students_bulk')
        except Exception as e:
            messages.error(request, f"Error reading file: {str(e)}")
            return redirect('add_students_bulk')

        student_objects = []
        image_files = []

        for index, row in data.iterrows():
            try:
                student_department = department.objects.get(
                    id=row['student_department'])
                course = Course.objects.get(id=row['course'])
                birth_date = parse_date(str(row['birth_date']))

                if not birth_date:
                    raise ValueError(f"Invalid date format at row {index + 1}")

                pic_file = None
                pic_path = row['student_image']
                if pic_path and os.path.exists(os.path.join(IMAGE_UPLOAD_PATH, pic_path)):
                    img_file = open(os.path.join(
                        IMAGE_UPLOAD_PATH, pic_path), 'rb')
                    pic_file = File(img_file, name=pic_path)
                    image_files.append(img_file)

                student = Student(
                    enrollment=row['enrollment'],
                    firstname=row['firstname'],
                    middlename=row['middlename'],
                    lastname=row['lastname'],
                    email=row['email'],
                    password=make_password(row['password']),
                    mobile_number=row['mobile_number'],
                    gender=row['gender'],
                    birth_date=birth_date,
                    address_line_1=row['address_line_1'],
                    address_line_2=row['address_line_2'],
                    country=row['country'],
                    state=row['state'],
                    city=row['city'],
                    pincode=row['pincode'],
                    student_department=student_department,
                    course=course,
                    semester=int(row['semester']) if row['semester'] else 1,
                    division=row['division'] if row['division'] else 'A',
                )

                if pic_file:
                    student.student_image.save(pic_path, pic_file)

                student_objects.append(student)

            except department.DoesNotExist:
                messages.error(
                    request, f"Row {index + 1}: Invalid department ID: {row['student_department']}")
            except Course.DoesNotExist:
                messages.error(
                    request, f"Row {index + 1}: Invalid course ID: {row['course']}")
            except Exception as e:
                messages.error(request, f"Row {index + 1}: {str(e)}")

        try:
            Student.objects.bulk_create(student_objects)

            for img in image_files:
                img.close()

            messages.success(request, "Students have been added successfully!")

        except Exception as e:
            messages.error(request, f"Error saving students: {str(e)}")

        return redirect('add_students_bulk')

    return render(request, 'superadmin/add_students_bulk.html')


def add_subject(request):
    all_courses = Course.objects.all()
    all_departments = department.objects.all()
    all_batches = Batch.objects.all()

    if request.method == "POST":
        subject_code = request.POST.get('subject_code')
        subject_name = request.POST.get('subject_name')
        department_id = request.POST.get('department')
        batch_id = request.POST.get('batch')
        semester = request.POST.get('semester')
        course_id = request.POST.get('course')

        course = Course.objects.get(id=course_id)
        subject_department = department.objects.get(id=department_id)
        batch = Batch.objects.get(id=batch_id)

        subject = Subject.objects.create(
            subject_name=subject_name,
            subject_code=subject_code,
            subject_course=course,
            subject_department=subject_department,
            subject_batch=batch,
            subject_semester=semester,

        )

        return render(request, 'superadmin/add-subject.html', {
            'all_departments': all_departments,
            'all_batches': all_batches,
            'all_courses': all_courses,
            'success': 'Subject added successfully!'
        })

    else:
        context = {
            'all_departments': all_departments,
            'all_batches': all_batches,
            'all_courses': all_courses,
        }
        return render(request, 'superadmin/add-subject.html', context)


def bulk_add_subjects(request):
    if request.method == "POST":
        # Make sure to match the file input name
        csv_file = request.FILES.get('csv_file')

        # Check if file exists and is of correct format
        if not csv_file:
            messages.error(request, "No file uploaded.")
            return redirect('bulk_add_subjects')

        # Validate file format
        if not csv_file.name.endswith(('.csv', '.xlsx', '.xls')):
            messages.error(
                request, "Invalid file format! Please upload a CSV, XLS, or XLSX file.")
            return redirect('bulk_add_subjects')

        try:
            # Handle CSV and Excel files
            if csv_file.name.endswith('.csv'):
                data = pd.read_csv(csv_file).fillna('')
            else:
                data = pd.read_excel(csv_file).fillna('')

        except Exception as e:
            messages.error(request, f"Error reading file: {str(e)}")
            return redirect('bulk_add_subjects')

        subject_objects = []

        # Process the rows in the uploaded file
        for index, row in data.iterrows():
            try:
                # Make sure that the foreign key lookups are correct
                subject_department = department.objects.get(
                    id=row['subject_department'])
                subject_course = Course.objects.get(id=row['subject_course'])
                subject_batch = Batch.objects.get(id=row['subject_batch'])

                subject = Subject(
                    subject_code=row['subject_code'],
                    subject_name=row['subject_name'],
                    subject_department=subject_department,
                    subject_batch=subject_batch,
                    subject_semester=row['subject_semester'],
                    subject_course=subject_course,

                )

                subject_objects.append(subject)
            except Exception as e:
                messages.error(
                    request, f"Error processing row {index}: {str(e)}")

        if subject_objects:
            try:
                Subject.objects.bulk_create(subject_objects)
                messages.success(request, "Subjects successfully added.")
            except Exception as e:
                messages.error(request, f"Error saving subjects: {str(e)}")

        else:
            messages.error(request, "No valid subjects to add.")

    return render(request, 'superadmin/add_subjects_bulk.html')


def delete_subject(request, id):
    deleteSubject = Subject.objects.get(id=id)
    deleteSubject.delete()
    return render(request, 'superadmin/all-subject.html')


def add_placement(request):
    if request.method == "POST":
        placement_company_name = request.POST.get("placement_company_name")
        job_role = request.POST.get("job_role")
        placement_company_location = request.POST.get(
            "placement_company_location")
        placement_company_package = request.POST.get(
            "placement_company_package")
        interview_date = request.POST.get("interview_date")
        deadline_date = request.POST.get("deadline_date")

        placement_company_logo = request.FILES.get("placement_company_logo")
        placement_job_description = request.FILES.get(
            "placement_job_description")

        placement = Placement.objects.create(
            placement_company_name=placement_company_name,
            job_role=job_role,
            placement_company_location=placement_company_location,
            placement_company_package=placement_company_package,
            interview_date=interview_date,
            deadline_date=deadline_date,
            placement_company_logo=placement_company_logo,
            placement_job_description=placement_job_description
        )

        return render(request, "superadmin/add-placement.html", {'success': "Placement Add Successfully"})

    return render(request, "superadmin/add-placement.html")


def edit_placement(request, id):
    placement = Placement.objects.get(id=id)
    dict = {
        'placement': placement
    }
    if request.method == "POST":
        placement.placement_company_name = request.POST.get(
            "placement_company_name")
        placement.job_role = request.POST.get("job_role")
        placement.placement_company_location = request.POST.get(
            "placement_company_location")
        placement.placement_company_package = request.POST.get(
            "placement_company_package")
        placement.interview_date = request.POST.get("interview_date")
        placement.deadline_date = request.POST.get("deadline_date")

        if 'placement_company_logo' in request.FILES:
            placement.placement_company_logo = request.FILES['placement_company_logo']

        if 'placement_job_description' in request.FILES:
            placement.placement_job_description = request.FILES['placement_job_description']

        placement.save()
        return redirect(f'/edit_placement/{placement.id}?success=1')
    return render(request, 'superadmin/edit_placement.html', dict)


def delete_placement(request, id):
    deletePlacement = Placement.objects.get(id=id)
    deletePlacement.delete()
    return redirect('/show_placement')


def show_placement(request):
    all_placement = list(Placement.objects.values())

    placement_json = json.dumps(all_placement, default=str)
    print("Placement Data:", all_placement)

    return render(request, 'superadmin/show_placement.html', {'all_placement': placement_json})


def delete_timetable(request, id):
    deleteTimetable = Timetable.objects.get(id=id)
    deleteTimetable.delete()
    return render(request, 'superadmin/show_timetable.html')


def add_timetable_bulk(request):
    if request.method == "POST":
        csv_file = request.FILES.get('csv_file')

        # Validate File Type
        if not csv_file or not csv_file.name.endswith('.csv'):
            messages.error(
                request, "Invalid file format! Please upload a CSV file.")
            return redirect('add_timetable_bulk')

         # Validate file format
        if not csv_file.name.endswith(('.csv', '.xlsx', '.xls')):
            messages.error(
                request, "Invalid file format! Please upload a CSV, XLS, or XLSX file.")
            return redirect('add_timetable_bulk')
        try:
            # Handle CSV and Excel files
            if csv_file.name.endswith('.csv'):
                data = pd.read_csv(csv_file).fillna('')
            else:
                data = pd.read_excel(csv_file).fillna('')
        except Exception as e:
            messages.error(request, f"Error reading file: {str(e)}")
            return redirect('add_timetable_bulk')

        timetable_objects = []

        # Process the rows in the uploaded file
        for index, row in data.iterrows():
            try:
                timetable_subject_name = Subject.objects.get(
                    id=row['timetable_subject_name'])
                faculty_name = Teacher.objects.get(id=row['faculty_name'])
                course = Course.objects.get(id=row['course'])
                batch = Batch.objects.get(id=row['batch'])
                timetable_department = department.objects.get(
                    id=row['timetable_department'])
                semester = row['semester']
                timetable = Timetable(
                    timetable_subject_name=timetable_subject_name,
                    faculty_name=faculty_name,
                    day=row['day'],
                    lecture_start_time=row['lecture_start_time'],
                    lecture_end_time=row['lecture_end_time'],
                    course=course,
                    timetable_department=timetable_department,
                    batch=batch,
                    division=row['division'],
                    semester=semester
                )
                timetable_objects.append(timetable)
            except Exception as e:
                messages.error(
                    request, f"Error processing row {index}: {str(e)}")

        if timetable_objects:
            try:
                Timetable.objects.bulk_create(timetable_objects)
                messages.success(request, "Timetable successfully added.")
            except Exception as e:
                messages.error(request, f"Error saving timetable: {str(e)}")

        else:
            messages.error(request, "No valid timetable to add.")

    return render(request, 'superadmin/add_timetable_bulk.html')


def add_timetable(request):
    all_subjects = Subject.objects.all()
    # print(all_subjects)
    all_courses = Course.objects.all()
    all_departments = department.objects.all()
    all_batches = Batch.objects.all()
    all_teachers = Teacher.objects.all()

    if request.method == "POST":
        timetable_subject_name = request.POST.get('timetable_subject_name')
        faculty_name = request.POST.get('faculty_name')
        day = request.POST.get('day')
        lecture_start_time = request.POST.get('lecture_start_time')
        lecture_end_time = request.POST.get('lecture_end_time')
        course_id = request.POST.get('course')
        timetable_department_id = request.POST.get('timetable_department')
        print(all_subject)
        batch = request.POST.get('batch')
        division = request.POST.get('division')
        course = Course.objects.get(id=course_id)
        timetable_department = department.objects.get(
            id=timetable_department_id)
        semester = request.POST.get('semester')
        # semester = request.POST.get('semester')
        timetable = Timetable.objects.create(
            timetable_subject_name=Subject.objects.get(
                id=timetable_subject_name),
            faculty_name=Teacher.objects.get(id=faculty_name),
            day=day,
            lecture_start_time=lecture_start_time,
            lecture_end_time=lecture_end_time,
            batch=Batch.objects.get(id=batch),
            course=course,
            division=division,
            timetable_department=timetable_department,
            semester=semester
        )

        return render(request, 'superadmin/timetable.html', {
            'all_subjects': all_subjects,
            'all_departments': all_departments,
            'all_batches': all_batches,
            'all_courses': all_courses,
            'success': 'Timetable added successfully!'
        })

    else:
        context = {
            'all_departments': all_departments,
            'all_batches': all_batches,
            'all_courses': all_courses,
            'all_subjects': all_subjects,
            'all_teachers': all_teachers
        }
        return render(request, 'superadmin/timetable.html', context)


def navbar(request):
    return render(request, 'superadmin/navbar.html')


# Faculty Views


def faculty_my_profile(request):
    return render(request, 'faculty/faculty_my-profile.html')
# for faculty


def faculty_profile(request):
    # Get the faculty_id from the session
    faculty_id = request.session.get('faculty_id')

    if faculty_id:
        try:
            # Retrieve the teacher's details using the faculty_id
            teacher = Teacher.objects.get(faculty_id=faculty_id)
            return render(request, 'faculty/faculty_profile.html', {'teacher': teacher})
        except Teacher.DoesNotExist:
            return render(request, 'faculty/faculty_profile.html', {'error': 'Teacher does not exist.'})
    else:
        # If the faculty_id is not in the session, redirect to the login page
        return render(request, 'faculty/faculty_login.html', {'error': 'Please login to view your profile.'})
# for faculty


def faculty_logout_view(request):

    request.session.flush()

    return redirect('/login_view/')


def faculty_sidebar(request):
    return render(request, 'faculty/faculty_sidebar.html')


def faculty_all_student(request):

    all_students = Student.objects.all()
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    student_id = request.GET.get('student_id')
    dept_name = request.GET.get('department')
    course_name = request.GET.get('course')
    semester = request.GET.get('semester')
    division = request.GET.get('division')

    if student_id:
        all_students = all_students.filter(enrollment__icontains=student_id)

    if dept_name:
        try:
            dept_obj = department.objects.get(department_name=dept_name)
            all_students = all_students.filter(student_department=dept_obj)
        except department.DoesNotExist:
            all_students = Student.objects.none()
    if course_name:
        try:
            course_obj = Course.objects.get(course_name=course_name)
            all_students = all_students.filter(course=course_obj)
        except Course.DoesNotExist:
            all_students = Student.objects.none()

    if semester:
        all_students = all_students.filter(semester=semester)

    if division:
        all_students = all_students.filter(division=division)

    context = {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'all_students': all_students
    }
    return render(request, 'faculty/faculty_all-students.html', context)

# views.py


def get_subject_and_faculty_from_id(subject_raw, faculty_raw):
    """
    Function to get the Subject and Faculty by their IDs.
    """
    if not subject_raw or not faculty_raw:
        return None, None, "Missing subject or faculty ID"

    try:
        # Convert to integers and fetch records from the database
        subject_id = int(subject_raw)
        faculty_id = int(faculty_raw)

        # Fetch the Subject and Teacher based on their IDs
        subject = Subject.objects.get(id=subject_id)
        faculty = Teacher.objects.get(id=faculty_id)

        return subject, faculty, None
    except (ValueError, Subject.DoesNotExist, Teacher.DoesNotExist) as e:
        return None, None, f"Error: {str(e)}"


def generate_qr_code(token):
    """
    Helper function to generate a QR code from the token.
    """
    img = qrcode.make(token)
    buffer = io.BytesIO()
    img.save(buffer, format='PNG')
    buffer.seek(0)
    return base64.b64encode(buffer.getvalue()).decode('utf-8')


def qr_code(request):
    subject_raw = request.GET.get('subject')
    faculty_raw = request.GET.get('faculty')

    if not subject_raw or not faculty_raw:
        return HttpResponse("Error: Missing subject or faculty ID", status=400)

    try:
        subject_id = int(subject_raw)
        faculty_id = int(faculty_raw)
        subject = Subject.objects.get(id=subject_id)
        faculty = Teacher.objects.get(id=faculty_id)
    except (ValueError, Subject.DoesNotExist, Teacher.DoesNotExist) as e:
        return HttpResponse(f"Error: {str(e)}", status=400)

    try:
        # Create a session with 5-minute expiry
        session = AttendanceSession.objects.create(
            subject=subject,
            faculty=faculty,
            date=now().date(),
            token_expiry=timezone.now() + timedelta(minutes=5)
        )

        token = str(session.token)
        print(f"[DEBUG] Generated Token: {token}")  # for debugging

        # Generate QR Code
        img = qrcode.make(token)
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        buffer.seek(0)
        img_str = base64.b64encode(buffer.getvalue()).decode('utf-8')

        context = {
            'qr_data': f"Subject: {subject.subject_name}, Date: {session.date}",
            'qr_code_url': f"data:image/png;base64,{img_str}",
        }

        return render(request, 'faculty/qr_code.html', context)

    except Exception as e:
        return HttpResponse(f"Error: {str(e)}", status=500)


def faculty_subject(request):
    faculty_id = request.session.get("faculty_id")

    if not faculty_id:
        return render(request, "superadmin/login.html", {"error": "Please log in first."})

    try:
        faculty = Teacher.objects.get(faculty_id=faculty_id)
    except Teacher.DoesNotExist:
        return render(request, "superadmin/login.html", {"error": "Faculty not found."})

    # Filters from GET
    department_name = request.GET.get('department')
    course_name = request.GET.get('course')
    semester = request.GET.get('semester')
    division = request.GET.get('division')

    # Base timetable filtering based on logged-in faculty
    timetable = Timetable.objects.filter(
        faculty_name=faculty)  # Only this faculty's timetable

    # Filteration based on department, course, semester, and division
    if department_name:
        timetable = timetable.filter(
            timetable_department__department_name=department_name)  # Corrected filter
    if course_name:
        timetable = timetable.filter(course__course_name=course_name)
    if semester:
        timetable = timetable.filter(semester=semester)
    if division:
        timetable = timetable.filter(division=division)

    # Days and time slots
    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    time_slots = OrderedDict([  # Define time slots for timetable matrix
        ("7:30 AM - 8:25 AM", (parse_time_string("7.30 AM"), parse_time_string("8.25 AM"))),
        ("8:25 AM - 9:20 AM", (parse_time_string("8.25 AM"), parse_time_string("9.20 AM"))),
        ("9:30 AM - 10:25 AM", (parse_time_string("9.30 AM"),
         parse_time_string("10.25 AM"))),
        ("10:25 AM - 11:20 AM",
         (parse_time_string("10.25 AM"), parse_time_string("11.20 AM"))),
        ("11:30 AM - 12:25 PM",
         (parse_time_string("11.30 AM"), parse_time_string("12.25 PM"))),
        ("12:25 PM - 1:20 PM",
         (parse_time_string("12.25 PM"), parse_time_string("1.20 PM"))),
    ])

    timetable_matrix = []

    for slot_label, (slot_start, slot_end) in time_slots.items():
        row = {'time': slot_label}
        for day in days:
            lecture = None
            for entry in timetable:
                if entry.day != day:
                    continue
                entry_start = parse_time_string(entry.lecture_start_time)
                entry_end = parse_time_string(entry.lecture_end_time)
                if entry_start and entry_end and slot_start <= entry_start < slot_end:
                    lecture = entry
                    break
            row[day] = lecture
        timetable_matrix.append(row)

    # Fetch courses and departments for dropdown (filtered by the faculty's department)
    all_departments = department.objects.all()  # Fetch all departments for dropdown
    # Fetch courses related to faculty's department
    courses = Course.objects.filter(
        course_department__department_name=faculty.department.department_name)

    context = {
        'timetable_matrix': timetable_matrix,
        'days': days,
        'all_departments': all_departments,  # All departments for dropdown
        'courses': courses,  # Courses related to this faculty's department
        'department_name': department_name,
        'course_name': course_name,
        'semester': semester,
        'division': division,
    }

    return render(request, 'faculty/faculty_subject.html', context)


def faculty_all_students(request):
    return render(request, 'faculty/faculty_all-students.html')


def faculty_stud_edit(request):
    return render(request, 'faculty/faculty_stud_edit.html')


def faculty_attendence(request):
    faculty_id = request.session.get("faculty_id")

    if not faculty_id:
        return redirect("login")

    try:
        faculty = Teacher.objects.get(faculty_id=faculty_id)
    except Teacher.DoesNotExist:
        return redirect("login")
    subject_links = SubjectTeacher.objects.filter(
        teacher=faculty).select_related('subject')
    subjects = [link.subject for link in subject_links]

    context = {
        'subjects': subjects
    }
    return render(request, 'faculty/faculty_attendence.html', context)


def faculty_attendence_1(request):
    return render(request, 'faculty/faculty_attendence_1.html')


# Serializers Views


# Disable CSRF for testing (consider better security in production)
@csrf_exempt
def student_login(request):
    if request.method == 'POST':
        try:
            # Parse JSON body
            data = json.loads(request.body)
            print("Login request data:", data)

            enrollment = data.get('enrollment')
            password = data.get('password')

            # Check for required fields
            if not enrollment or not password:
                return JsonResponse(
                    {"error": "Enrollment and password are required"},
                    status=400
                )

            # Try to find student
            student = Student.objects.get(enrollment=enrollment)
            print("Student found:", student)

            # Validate password (must be hashed in DB)
            if check_password(password, student.password):
                return JsonResponse({
                    "message": "Login successful",
                    "student_id": student.id,
                    "firstname": student.firstname,
                }, status=200)
            else:
                return JsonResponse({"error": "Invalid password"}, status=401)

        except Student.DoesNotExist:
            return JsonResponse({"error": "Student not found"}, status=404)

        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON format"}, status=400)

        except Exception as e:
            print("Unexpected error:", str(e))
            print(traceback.format_exc())
            return JsonResponse({"error": "Internal server error"}, status=500)

    return JsonResponse({"error": "Invalid request method"}, status=400)


@csrf_exempt
def student_profile(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            student_id = data.get('student_id')

            if not student_id:
                return JsonResponse({"error": "Student ID is required"}, status=400)

            student = Student.objects.get(id=student_id)
            serializer = StudentProfileSerializer(
                student, context={'request': request})
            return JsonResponse(serializer.data, safe=False)

        except Student.DoesNotExist:
            return JsonResponse({"error": "Student not found"}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON"}, status=400)

    return JsonResponse({"error": "Invalid request method"}, status=400)


# @csrf_exempt
# def teacher_profile(request):
#     if request.method == 'POST':
#         try:
#             json_data = request.body
#             stream = io.BytesIO(json_data)
#             python_data = JSONParser().parse(stream)
#             teacher_id = python_data.get('id', None)

#             if teacher_id is not None:
#                 teacher = Teacher.objects.get(id=teacher_id)
#                 serializer = TeacherSerializer(
#                     teacher, context={'request': request})
#                 return JsonResponse(serializer.data, status=200)
#             else:
#                 teachers = Teacher.objects.all()
#                 serializer = TeacherSerializer(
#                     teachers, many=True, context={'request': request})
#                 return JsonResponse(serializer.data, safe=False, status=200)

#         except Teacher.DoesNotExist:
#             return JsonResponse({'error': 'Teacher not found'}, status=404)
#         except Exception as e:
#             return JsonResponse({'error': str(e)}, status=500)

#     return JsonResponse({'error': 'Invalid request method'}, status=400)
@csrf_exempt
def teacher_profile(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            teacher_id = data.get('id')

            if teacher_id:
                teacher = Teacher.objects.get(id=teacher_id)
                serializer = TeacherSerializer(teacher, context={'request': request})
                return JsonResponse(serializer.data, status=200)
            else:
                teachers = Teacher.objects.all()
                serializer = TeacherSerializer(teachers, many=True, context={'request': request})
                return JsonResponse(serializer.data, safe=False, status=200)

        except Teacher.DoesNotExist:
            return JsonResponse({'error': 'Teacher not found'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=400)

@csrf_exempt
def teacher_login(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            faculty_id = data.get('faculty_id')
            password = data.get('password')

            if not faculty_id or not password:
                return JsonResponse({"error": "faculty_id and password are required"}, status=400)

            teacher = Teacher.objects.get(faculty_id=faculty_id)

            if check_password(password, teacher.password):
                return JsonResponse({
                    "message": "Login successful",
                    "faculty_id": teacher.faculty_id,
                    "firstname": teacher.firstname
                }, status=200)
            else:
                return JsonResponse({"error": "Invalid password"}, status=401)

        except Teacher.DoesNotExist:
            return JsonResponse({"error": "Teacher not found"}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON format"}, status=400)
        except Exception as e:
            print("Unexpected error:", str(e))
            print(traceback.format_exc())
            return JsonResponse({"error": "Internal server error"}, status=500)

    return JsonResponse({"error": "Invalid request method"}, status=400)


@api_view(['GET'])
def all_students_api(request):
    students = Student.objects.all()
    serializer = StudentListSerializer(
        students, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['GET'])
def student_today_sessions(request):
    try:
        student_id = request.query_params.get('student_id')

        if not student_id:
            return Response({'error': 'Student ID required'}, status=400)

        student = Student.objects.get(id=student_id)

        today_day = datetime.today().strftime('%A')
        print(f"Student ID: {student.id}, Today: {today_day}")
        print(
            f"Semester: {student.semester}, Division: {student.division}, Course ID: {student.course.id}")

        # Filter without batch
        timetable_qs = Timetable.objects.filter(
            day=today_day,
            semester=student.semester,
            division=student.division,
            course=student.course,
            timetable_department=student.student_department
        )

        if timetable_qs.exists():
            # Sort by lecture_start_time (handle '8.25 AM' as '8:25 AM')
            sorted_timetable = sorted(
                timetable_qs,
                key=lambda x: datetime.strptime(
                    x.lecture_start_time.replace('.', ':'), "%I:%M %p")
            )

            serializer = TimetableSerializer(
                sorted_timetable, many=True, context={'request': request})
            return Response({'today_subjects': serializer.data}, status=200)

        else:
            return Response({'message': 'No subjects for today'}, status=404)

    except Student.DoesNotExist:
        return Response({'error': 'Student not found'}, status=404)
    except Exception as e:
        return Response({'error': str(e)}, status=400)


@api_view(['GET'])
def student_placement_list(request):
    try:
        placements = Placement.objects.all().order_by('-interview_date')  # latest first
        serializer = PlacementSerializer(
            placements, many=True, context={'request': request})
        return Response({'placements': serializer.data}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def mark_attendance(request):
    try:
        token = request.data.get('token')
        student_id = request.data.get('student_id')

        if not token or not student_id:
            return Response({"error": "Missing token or student ID"}, status=status.HTTP_400_BAD_REQUEST)

        # Fetch session using token
        session = AttendanceSession.objects.get(token=token)

        # ✅ Check if token has expired
        if session.is_expired():
            return Response({"error": "Attendance session expired"}, status=status.HTTP_400_BAD_REQUEST)

        student = Student.objects.get(id=student_id)

        # Check for duplicate attendance
        if AttendanceRecord.objects.filter(session=session, student=student).exists():
            return Response({"message": "Attendance already marked"}, status=status.HTTP_200_OK)

        # Mark attendance
        AttendanceRecord.objects.create(session=session, student=student)

        return Response({"message": "Attendance marked successfully"}, status=status.HTTP_201_CREATED)

    except AttendanceSession.DoesNotExist:
        return Response({"error": "Invalid session token"}, status=status.HTTP_400_BAD_REQUEST)
    except Student.DoesNotExist:
        return Response({"error": "Invalid student ID"}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
