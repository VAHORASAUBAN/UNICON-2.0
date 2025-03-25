from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
import qrcode
import io
import base64
from superadmin.models import *
from django.contrib.auth.hashers import check_password

# for faculty


def faculty_my_profile(request):
    return render(request, 'faculty/faculty_my-profile.html')
# for faculty


def faculty_profile(request):
    return render(request, 'faculty/faculty_profile.html')
# for faculty


def faculty_sidebar(request):
    return render(request, 'faculty/faculty_sidebar.html')


def faculty_dash(request):
    return render(request, 'faculty/faculty_dash.html')


def faculty_all_student(request):
    return render(request, 'faculty/faculty_all-students.html')


def faculty_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        try:
            teacher = Teacher.objects.get(faculty_id=username)
            if check_password(password, teacher.password):
                return render(request, 'faculty/faculty_dash.html', {'teacher': teacher})
            else:
                return render(request, 'faculty/faculty_login.html', {'error': 'Invalid credentials. Please try again.'})
        except Teacher.DoesNotExist:
            return render(request, 'faculty/faculty_login.html', {'error': 'Teacher Does Not Exist.'})

    return render(request, 'faculty/faculty_login.html')


def qr_code(request):
    subject = request.GET.get('subject')
    course = request.GET.get('course')
    department = request.GET.get('department')
    division = request.GET.get('division')
    semester = request.GET.get('semester')

    qr_data = f"Subject: {subject}, Course: {course}, Department: {department}, Division: {division}, Semester: {semester}"
    img = qrcode.make(qr_data)
    buffer = io.BytesIO()
    img.save(buffer, format='PNG')
    buffer.seek(0)
    img_str = base64.b64encode(buffer.getvalue()).decode('utf-8')

    context = {
        'qr_data': qr_data,
        'qr_code_url': f"data:image/png;base64,{img_str}"
    }
    return render(request, 'faculty/qr_code.html', context)


def faculty_subject(request):
    return render(request, 'faculty/faculty_subject.html')


def faculty_all_students(request):
    return render(request, 'faculty/faculty_all-students.html')


def faculty_stud_edit(request):
    return render(request, 'faculty/faculty_stud_edit.html')


def faculty_attendence(request):
    return render(request, 'faculty/faculty_attendence.html')


def faculty_attendence_1(request):
    return render(request, 'faculty/faculty_attendence_1.html')
