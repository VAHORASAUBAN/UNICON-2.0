from django.urls import path
from faculty import views as faculty_views


urlpatterns = [
    path('faculty_my_profile/', faculty_views.faculty_my_profile,
         name="faculty_my_profile"),
    path('faculty_profile/', faculty_views.faculty_profile, name="faculty_profile"),
    path('faculty_sidebar/', faculty_views.faculty_sidebar, name="faculty_sidebar"),
    path('faculty_dash/', faculty_views.faculty_dash, name="faculty_dash"),
    path('qr_code/', faculty_views.qr_code, name="qr_code"),
    path('faculty_subject/', faculty_views.faculty_subject, name="faculty_subject"),
    path('faculty_all_student/', faculty_views.faculty_all_student,
         name="faculty_all_student"),
    path('faculty_stud_edit/', faculty_views.faculty_stud_edit,
         name="faculty_stud_edit"),
    path('faculty_attendence/', faculty_views.faculty_attendence,
         name="faculty_attendence"),
    path('faculty_attendence_1/', faculty_views.faculty_attendence_1,
         name="faculty_attendence_1"),
    path('faculty_login/', faculty_views.faculty_login, name='faculty_login'),

]
