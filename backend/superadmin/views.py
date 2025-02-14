from django.shortcuts import render
def add_blog(request):
    return render(request, 'add-blog.html')
def add_student(request):
    return render(request, 'add-student.html')
def add_teacher(request):
    return render(request, 'add-teacher.html')
def all_students(request):
    return render(request, 'all-students.html')
def all_teachers(request):
    return render(request, 'all-teachers.html')
def all_department(request):
    return render(request, 'all-department.html')
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
def profile(request):
    return render(request, 'profile.html')
def sidebar(request):
    return render(request, 'sidebar.html')
def add_subject(request):
    return render(request, 'add-subject.html')
def add_department(request):
    return render(request, 'add-department.html')
def add_course(request):
    return render(request, 'add-course.html')
def add_batch(request):
    return render(request, 'add-batch.html')
def all_batch(request):
    return render(request, 'all-batch.html')
def all_course(request):
    return render(request, 'all-course.html')
def all_subject(request):
    return render(request, 'all-subject.html')
def timetable(request):
    return render(request, 'timetable.html')
def show_timetable(request):
    return render(request, 'show_timetable.html')
