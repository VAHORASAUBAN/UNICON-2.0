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