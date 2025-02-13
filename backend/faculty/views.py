from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
import qrcode
import io
import base64

# for faculty
def faculty_my_profile(request):
    return render(request, 'faculty_my-profile.html')
# for faculty
def faculty_profile(request):
    return render(request, 'faculty_profile.html')
# for faculty
def faculty_sidebar(request):
    return render(request, 'faculty_sidebar.html')
def faculty_dash(request):
    return render(request, 'faculty_dash.html')
def faculty_all_student(request):
    return render(request, 'faculty_all-students.html')

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
    return render(request, 'qr_code.html', context)

def faculty_subject(request):
    return render(request, 'faculty_subject.html')

def faculty_all_students(request):
    return render(request, 'faculty_all-students.html')

def faculty_stud_edit(request):
    return render(request, 'faculty_stud_edit.html')

def faculty_attendence(request):
    return render(request, 'faculty_attendence.html')