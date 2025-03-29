from django.shortcuts import render
from addcoordinator.models import coordinator
from django.contrib.auth.models import User, auth, make_password
from django.contrib.auth.hashers import check_password
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect
from django.http import HttpResponse
from .models import *
import pandas as pd
from datetime import datetime
from django.core.files import File
import os
import json


def front_page(request):
    return render(request, 'superadmin/front_page.html')


def add_blog(request):
    return render(request, 'superadmin/add-blog.html')


def all_teachers(request):
    all_faculty = Teacher.objects.all()
    context = {'all_faculty': all_faculty}
    return render(request, 'superadmin/all-teachers.html', context)


def blog_details(request):
    return render(request, 'superadmin/blog-details.html')


def blog(request):
    return render(request, 'superadmin/blog.html')


def calendar(request):
    return render(request, 'superadmin/calendar.html')


def edit_blog(request):
    return render(request, 'superadmin/edit-blog.html')


def edit_profile(request):
    return render(request, 'superadmin/edit-profile.html')


def edit_teacher(request):
    return render(request, 'superadmin/edit-teacher.html')


def index(request):
    return render(request, 'superadmin/index.html')


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


def add_batch(request):

    all_courses = Course.objects.all()
    if request.method == "POST":
        batch_start_date = request.POST.get('batch_start_date')
        batch_end_date = request.POST.get('batch_end_date')
        course_id = request.POST.get('course')

        course = Course.objects.get(id=course_id)

        save_batch = Batch.objects.create(
            batch_start_date=batch_start_date,
            batch_end_date=batch_end_date,
            course=course
        )
        save_batch.save()
        return render(request, 'superadmin/add-batch.html', {'all_courses': all_courses})
    return render(request, 'superadmin/add-batch.html', {'all_courses': all_courses})


def all_batch(request):
    all_batches = Batch.objects.all()
    all_courses = Course.objects.all()
    context = {
        'all_batches': all_batches,
        'all_courses': all_courses
    }
    return render(request, 'superadmin/all-batch.html', context)


def all_subject(request):
    all_subject = Subject.objects.all()

    return render(request, 'superadmin/all-subject.html', {'all_subjects': all_subject})


def timetable(request):
    return render(request, 'superadmin/timetable.html')


def show_timetable(request):
    return render(request, 'superadmin/show_timetable.html')


def coordinator_login(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')

        try:
            coord = coordinator.objects.get(username=username)
            if check_password(password, coord.password):

                request.session['username'] = coord.username

                return render(request, 'superadmin/index.html')
            else:
                return render(request, 'superadmin/login.html', {'error': 'Invalid credentials. Please try again.'})
        except coordinator.DoesNotExist:
            return render(request, 'superadmin/login.html', {'error': 'Coordinator does not exist.'})

    return render(request, 'superadmin/login.html')


def logout_view(request):

    request.session.flush()

    return render(request, 'superadmin/login.html', {'message': 'You have been logged out.'})


def add_department(request):
    if request.method == "POST":
        department_name = request.POST.get('department_name')
        department_start_date = request.POST.get('department_start_date')
        save_department = department(
            department_name=department_name,
            department_start_date=department_start_date
        )
        save_department.save()
        return render(request, 'superadmin/add-department.html')

    else:
        return render(request, 'superadmin/add-department.html')


def all_department(request):
    all_department = department.objects.all()
    print(all_department)
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
    course = Course.objects.all()
    return render(request, 'superadmin/all-course.html', {'course': course})


def delete_course(request, id):
    deleteCourse = Course.objects.get(id=id)
    deleteCourse.delete()
    return redirect('/all_course')


def add_student(request):
    all_departments = department.objects.all()
    all_courses = Course.objects.all()

    if request.method == "POST":
        try:
            enrollment = int(request.POST.get('enrollment')
                             )
            if enrollment <= 0:
                raise ValueError("Enrollment number must be positive")

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
            semester = int(request.POST.get('semester'))
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

        except ValueError as e:
            return render(request, 'superadmin/add-student.html', {
                'error': f'Error: {str(e)}',
                'all_departments': all_departments,
                'all_courses': all_courses
            })

    else:
        return render(request, 'superadmin/add-student.html', {
            'all_departments': all_departments,
            'all_courses': all_courses
        })


def all_students(request):
    all_students = Student.objects.all()
    all_departments = department.objects.all()
    all_courses = Course.objects.all()
    context = {
        'all_departments': all_departments,
        'all_courses': all_courses,
        'all_students': all_students
    }
    return render(request, 'superadmin/all-students.html', context)


def edit_student(request, id):
    print("HEllo")
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
        return render(request, 'superadmin/edit-student.html', context)


def delete_student(request, id):
    deleteStudent = Student.objects.get(id=id)
    deleteStudent.delete()
    return redirect('/all_students')


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
        return render(request, 'superadmin/add-teacher.html', context)


def all_teachers(request):
    all_teachers = Teacher.objects.all()
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


def add_teachers_bulk(request):
    if request.method == "POST":
        IMAGE_UPLOAD_PATH = "media/teacher_images/"
        csv_file = request.FILES.get('csv_file')

        if not csv_file.name.endswith('.csv'):
            return render(request, 'superadmin/add_teachers_bulk.html', {
                'error': 'Invalid format!',
            })

        try:

            data = pd.read_csv(csv_file).fillna('')
        except Exception as e:
            return render(request, 'superadmin/add_teachers_bulk.html', {
                'error': f'Error in reading CSV file: {str(e)}',
            })

        teacher_objects = []
        image_files = []

        for index, row in data.iterrows():
            try:

                teacher_department = department.objects.get(
                    id=row['department'])
                course = Course.objects.get(id=row['course'])

                pic_path = row['pic']
                pic_file = None
                if pic_path and os.path.exists(os.path.join(IMAGE_UPLOAD_PATH, pic_path)):

                    img_file = open(os.path.join(
                        IMAGE_UPLOAD_PATH, pic_path), 'rb')
                    pic_file = File(img_file, name=pic_path)

                    image_files.append(img_file)

                teacher = Teacher(
                    faculty_id=row['faculty_id'],
                    firstname=row['firstname'],
                    lastname=row['lastname'],
                    email=row['email'],
                    password=make_password(row['password']),
                    mobile_number=row['mobile_number'],
                    gender=row['gender'],
                    birth_date=parse_date(row['birth_date']),
                    address_line_1=row['address_line_1'],
                    address_line_2=row['address_line_2'],
                    country=row['country'],
                    state=row['state'],
                    city=row['city'],
                    pincode=row['pincode'],
                    joining_date=parse_date(row['joining_date']),
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
                return render(request, 'superadmin/add_teachers_bulk.html', {
                    'error': f'Row {index + 1} error in processing: {str(e)}',
                })

        try:
            Teacher.objects.bulk_create(teacher_objects)

            for img_file in image_files:
                img_file.close()

            return render(request, 'superadmin/add_teachers_bulk.html', {
                'success': 'Teachers have been added successfully!',
            })
        except Exception as e:
            return render(request, 'superadmin/add_teachers_bulk.html', {
                'error': f'Error saving teachers to the database: {str(e)}',
            })

    return render(request, 'superadmin/add_teachers_bulk.html')


def add_students_bulk(request):
    if request.method == "POST":
        IMAGE_UPLOAD_PATH = "media/student_images/"

        csv_file = request.FILES.get('csv_file')

        if not csv_file.name.endswith('.csv'):
            return render(request, 'superadmin/add_students_bulk.html', {
                'error': 'Invalid format!',
            })

        try:

            data = pd.read_csv(csv_file).fillna('')
        except Exception as e:
            return render(request, 'superadmin/add_students_bulk.html', {
                'error': f'Error in reading CSV file: {str(e)}',
            })

        student_objects = []
        image_files = []

        for index, row in data.iterrows():
            try:
                student_department = department.objects.get(
                    id=row['student_department'])
                course = Course.objects.get(id=row['course'])

                birth_date = parse_date(row['birth_date'])

                pic_path = row['student_image']
                pic_file = None
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

                    semester=row['semester'] if row['semester'] else '1',

                    division=row['division'] if row['division'] else 'A',
                )

                if pic_file:
                    student.student_image.save(pic_path, pic_file)

                student_objects.append(student)
            except Exception as e:
                return render(request, 'superadmin/add_students_bulk.html', {
                    'error': f'Row {index + 1} error in processing: {str(e)}',
                })

        try:
            Student.objects.bulk_create(student_objects)

            for img_file in image_files:
                img_file.close()

            return render(request, 'superadmin/add_students_bulk.html', {
                'success': 'Students have been added successfully!',
            })
        except Exception as e:
            return render(request, 'superadmin/add_students_bulk.html', {
                'error': f'Error saving students to the database: {str(e)}',
            })

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


def show_placement(request):
    all_placement = list(Placement.objects.values())

    placement_json = json.dumps(all_placement, default=str)
    print("Placement Data:", all_placement)

    return render(request, 'superadmin/show_placement.html', {'all_placement': placement_json})
