from django.shortcuts import render
from addcoordinator.models import coordinator
from django.contrib.auth.models import User, auth, make_password
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from django.shortcuts import redirect
from django.http import HttpResponse
from .models import *
import pandas as pd


def front_page(request):
    return render(request, 'front_page.html')


def add_blog(request):
    return render(request, 'add-blog.html')


def all_teachers(request):
    return render(request, 'all-teachers.html')


def blog_details(request):
    return render(request, 'blog-details.html')


def blog(request):
    return render(request, 'blog.html')


def calendar(request):
    return render(request, 'calendar.html')


def edit_blog(request):
    return render(request, 'edit-blog.html')


def edit_profile(request):
    return render(request, 'edit-profile.html')


def edit_student(request):
    return render(request, 'edit-student.html')


def edit_teacher(request):
    return render(request, 'edit-teacher.html')


def index(request):
    return render(request, 'index.html')


def my_profile(request):
    return render(request, 'my-profile.html')


@login_required
def profile(request):
    # Get the logged-in user's coordinator details
    coordinator_data = coordinator.objects.get(user=request.user)

    return render(request, 'profile.html', {'coordinator_data': coordinator_data})


def sidebar(request):
    return render(request, 'sidebar.html')


def add_subject(request):
    return render(request, 'add-subject.html')


def add_batch(request):
    return render(request, 'add-batch.html')


def all_batch(request):
    return render(request, 'all-batch.html')


def all_subject(request):
    return render(request, 'all-subject.html')


def timetable(request):
    return render(request, 'timetable.html')


def show_timetable(request):
    return render(request, 'show_timetable.html')


def placement(request):
    return render(request, 'placement.html')


def show_placement(request):
    return render(request, 'show_placement.html')


# login

def coordinator_login(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')

        # Fix the query to filter by the related User model's username field
        login_data = coordinator.objects.filter(user__username=username)

        if login_data.exists():  # Check if the coordinator exists
            # Get the first result (in case of multiple)
            coordinator_data = login_data[0]

            # Authenticate the user using Django's built-in auth system
            user = auth.authenticate(username=username, password=password)

            if user is not None:
                auth.login(request, user)
                # Pass only the coordinator_data, not the entire login_data queryset
                return render(request, 'index.html', {'coordinator_data': coordinator_data})
            else:
                return HttpResponse("Invalid Credentials")
        else:
            return HttpResponse("Invalid Credentials")

    else:
        return render(request, 'login.html')


# logout
def logout_view(request):
    # Log the user out
    logout(request)

    # Redirect to the login page or any other page after logging out
    return render(request, 'login.html')
# Department


def add_department(request):
    if request.method == "POST":
        department_name = request.POST.get('department_name')
        department_start_date = request.POST.get('department_start_date')
        save_department = department(
            department_name=department_name,
            department_start_date=department_start_date
        )
        save_department.save()
        return render(request, 'add-department.html')

    else:
        return render(request, 'add-department.html')


def all_department(request):
    all_department = department.objects.all()
    print(all_department)
    return render(request, 'all-department.html', {'all_department': all_department})


def delete_department(request, id):
    deleteDepartment = department.objects.get(id=id)
    deleteDepartment.delete()
    return redirect('/all_department')


# Courses

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
        return render(request, 'add-course.html', {'all_department': all_department})

    else:
        return render(request, 'add-course.html', {'all_department': all_department})


def all_course(request):
    course = Course.objects.all()
    return render(request, 'all-course.html', {'course': course})


def delete_course(request, id):
    deleteCourse = Course.objects.get(id=id)
    deleteCourse.delete()
    return redirect('/all_course')


# Student
def add_student(request):
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    if request.method == "POST":
        enrollment = request.POST.get('enrollment')
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
        department_id = request.POST.get('student_department')
        course_id = request.POST.get('course')
        semester = request.POST.get('semester')
        division = request.POST.get('division')
        student_image = request.FILES.get('student_image')

        student_department = department.objects.get(id=department_id)
        course = Course.objects.get(id=course_id)

        student = Student.objects.create(
            enrollment=enrollment,
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
            student_department=student_department,
            course=course,
            semester=semester,
            division=division,
            student_image=student_image
        )

        return redirect('add_student')
    else:
        context = {
            'all_departments': all_departments,
            'all_courses': all_courses,
        }
        return render(request, 'add-student.html', context)


def all_students(request):
    all_students = Student.objects.all()
    all_departments = department.objects.all()
    all_courses = Course.objects.all()
    context = {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'all_students': all_students
    }
    return render(request, 'all-students.html', context)


def edit_student(request, id):
    student = Student.objects.get(id=id)
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
        student.country = request.POST.get('country')
        student.state = request.POST.get('state')
        student.city = request.POST.get('city')
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
    else:
        context = {
            'all_departments': all_departments,
            'all_courses': all_courses,
            'all_students': student
        }
        return render(request, 'edit-student.html', context)


def edit_student(request, id):
    student = Student.objects.get(id=id)
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    if request.method == "POST":
        new_enrollment = request.POST.get('enrollment')
        new_firstname = request.POST.get('firstname')
        new_middlename = request.POST.get('middlename')
        new_lastname = request.POST.get('lastname')
        new_email = request.POST.get('email')
        new_password = request.POST.get('password')
        new_mobile_number = request.POST.get('mobile_number')
        new_gender = request.POST.get('gender')
        new_birth_date = request.POST.get('birth_date')
        new_address_line_1 = request.POST.get('address_line_1')
        new_address_line_2 = request.POST.get('address_line_2')
        new_country = request.POST.get('country')
        new_state = request.POST.get('state')
        new_city = request.POST.get('city')
        new_pincode = request.POST.get('pincode')
        new_department_id = request.POST.get('student_department')
        new_course_id = request.POST.get('course')
        new_semester = request.POST.get('semester')
        new_division = request.POST.get('division')

        student.enrollment = new_enrollment
        student.firstname = new_firstname
        student.middlename = new_middlename
        student.lastname = new_lastname
        student.email = new_email
        if new_password:
            student.password = make_password(new_password)
        student.mobile_number = new_mobile_number
        student.gender = new_gender
        student.birth_date = new_birth_date
        student.address_line_1 = new_address_line_1
        student.address_line_2 = new_address_line_2
        student.country = new_country
        student.state = new_state
        student.city = new_city
        student.pincode = new_pincode
        student.semester = new_semester
        student.division = new_division

        if new_department_id:
            student.student_department = department.objects.get(
                id=new_department_id)
        if new_course_id:
            student.course = Course.objects.get(id=new_course_id)

        if 'student_image' in request.FILES:
            student.student_image = request.FILES['student_image']

        student.save()
        return redirect('/display')

    else:
        context = {
            'all_departments': all_departments,
            'all_courses': all_courses,
            'all_students': student
        }

        return render(request, 'edit-student.html', {'student': student})


def delete_student(request, id):
    deleteStudent = Student.objects.get(id=id)
    deleteStudent.delete()
    return redirect('/all_students')
# Teacher


def add_teacher(request):
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    if request.method == "POST":
        faculty_id = request.POST.get('faculty_id')
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
        achievements = request.POST.get('achievements')
        qualification = request.POST.get('qualification')
        pic = request.FILES.get('pic')

        teacher_department = department.objects.get(id=department_id)
        course = Course.objects.get(id=course_id)

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
        return redirect('add_teacher')
    else:
        context = {
            'all_departments': all_departments,
            'all_courses': all_courses,
        }
        return render(request, 'add-teacher.html', context)


def all_teachers(request):
    all_teachers = Teacher.objects.all()
    all_departments = department.objects.all()
    all_courses = Course.objects.all()
    context = {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'all_teachers': all_teachers
    }
    return render(request, 'all-teachers.html', context)


def delete_teacher(request, id):
    deleteTeacher = Teacher.objects.get(id=id)
    deleteTeacher.delete()
    return redirect('/all_teachers')
