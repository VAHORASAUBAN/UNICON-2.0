from django.contrib import admin
from django.urls import path
from faculty import views as faculty_views
from superadmin import views as superadmin_views
urlpatterns = [
    path('admin/', admin.site.urls),
    path('add_blog/', superadmin_views.add_blog),
    path('add_student/', superadmin_views.add_student),
    path('add_teacher/', superadmin_views.add_teacher),
    path('all_students/', superadmin_views.all_students),
    path('all_teachers/', superadmin_views.all_teachers),
    path('blog_details/', superadmin_views.blog_details),
    path('blog/', superadmin_views.blog),
    path('calendar/', superadmin_views.calendar),
    path('edit_blog/', superadmin_views.edit_blog),
    path('edit_profile/', superadmin_views.edit_profile),
    path('edit_student/', superadmin_views.edit_student),
    path('edit_teacher/', superadmin_views.edit_teacher),
    path('index/', superadmin_views.index),
    path('my_profile/', superadmin_views.my_profile),
    path('profile/', superadmin_views.profile),
    path('add_subject/', superadmin_views.add_subject),
    path('add_department/', superadmin_views.add_department),
    path('sidebar/', superadmin_views.sidebar),
    path('add_course/', superadmin_views.add_course),
    path('add_batch/', superadmin_views.add_batch),
    path('all_batch/', superadmin_views.all_batch),
    path('all_department/', superadmin_views.all_department),
    path('all_course/', superadmin_views.all_course),
    path('all_subject/', superadmin_views.all_subject),
    path('timetable/', superadmin_views.timetable),

    
    path('faculty_my_profile/', faculty_views.faculty_my_profile),
    path('faculty_profile/', faculty_views.faculty_profile),
    path('faculty_sidebar/', faculty_views.faculty_sidebar),
    path('faculty_dash/', faculty_views.faculty_dash),
    path('qr_code/', faculty_views.qr_code),
    path('faculty_subject/', faculty_views.faculty_subject),
    path('faculty_all_student/', faculty_views.faculty_all_student),
    

    

   
]
