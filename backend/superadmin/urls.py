from django.urls import path
from superadmin import views as superadmin_views
urlpatterns = [
    path("", superadmin_views.login_view, name="login_view"),
    path("login_view/", superadmin_views.login_view, name="login_view"),
    path('add_blog/', superadmin_views.add_blog, name='add_blog'),
    path('add_student/', superadmin_views.add_student, name='add_student'),
    path('add_teacher/', superadmin_views.add_teacher, name="add_teacher"),
    path('all_students/', superadmin_views.all_students, name='all_students'),
    path('all_teachers/', superadmin_views.all_teachers, name='all_teachers'),
    path('blog_details/', superadmin_views.blog_details, name='blog_details'),
    path('blog/', superadmin_views.blog, name='blog'),
    path('calendar/', superadmin_views.calendar, name='calendar'),
    path('edit_blog/', superadmin_views.edit_blog, name='edit_blog'),
    path('edit_profile/', superadmin_views.edit_profile, name='edit_profile'),
    path('edit_student/<int:id>/',
         superadmin_views.edit_student, name='edit_student'),
    path('edit_teacher/<str:faculty_id>/',
         superadmin_views.edit_teacher, name='edit_teacher'),
    path('index/', superadmin_views.index, name="index"),
    path('my_profile/', superadmin_views.my_profile, name='my_profile'),
    path('profile/', superadmin_views.profile, name='profile'),
    path('add_subject/', superadmin_views.add_subject, name='add_subject'),
    path('edit_subject/<int:id>/',
         superadmin_views.edit_subject, name='edit_subject'),
    path('bulk_add_subjects/', superadmin_views.bulk_add_subjects,
         name='bulk_add_subjects'),
    path('add_department/', superadmin_views.add_department, name='add_department'),
    path('sidebar/', superadmin_views.sidebar, name='sidebar'),
    path('add_course/', superadmin_views.add_course, name='add_course'),
    path('add_batch/', superadmin_views.add_batch, name='add_batch'),
    path('delete_batch/<int:id>/',
         superadmin_views.delete_batch, name='delete_batch'),
    path('all_batch/', superadmin_views.all_batch, name='all_batch'),
    path('all_department/', superadmin_views.all_department, name='all_department'),
    path('all_course/', superadmin_views.all_course, name='all_course'),
    path('all_subject/', superadmin_views.all_subject, name='all_subject'),
    path('add_timetable_bulk', superadmin_views.add_timetable_bulk,
         name='add_timetable_bulk'),
    path('delete_timetable', superadmin_views.delete_timetable,
         name='delete_timetable'),
    path('add_timetable/', superadmin_views.add_timetable, name='add_timetable'),
    path('show_timetable/', superadmin_views.show_timetable, name='show_timetable'),
    #     path('coordinator_login/', superadmin_views.coordinator_login,
    #          name="coordinator_login"),
    # path('faculty_login/', superadmin_views.faculty_login),
    path('show_placement/', superadmin_views.show_placement, name='show_placement'),
    path('edit_placement/<int:id>/',
         superadmin_views.edit_placement, name='edit_placement'),
    path('delete_placement/<int:id>/',
         superadmin_views.delete_placement, name='delete_placement'),
    path('logout/', superadmin_views.logout_view, name='logout'),
    path('delete_course/<int:id>/',
         superadmin_views.delete_course, name='delete_course'),
    path('delete_department/<int:id>/',
         superadmin_views.delete_department, name='delete_department'),
    path('delete_teacher/<int:id>/',
         superadmin_views.delete_teacher, name='delete_teacher'),
    path('delete_student/<int:id>/',
         superadmin_views.delete_student, name='delete_student'),
    path('delete_subject/<int:id>/',
         superadmin_views.delete_subject, name='delete_subject'),
    path('faculty_individual_profile/<str:faculty_id>/',
         superadmin_views.faculty_individual_profile, name='faculty_individual_profile'),
    path('add_teachers_bulk/', superadmin_views.add_teachers_bulk,
         name='add_teachers_bulk'),
    path('add_students_bulk/', superadmin_views.add_students_bulk,
         name='add_students_bulk'),
    path("add_placement/", superadmin_views.add_placement, name="add_placement"),
    path("navbar/", superadmin_views.navbar, name="navbar"),






    # Faculty URLs
    path('faculty_my_profile/', superadmin_views.faculty_my_profile,
         name="faculty_my_profile"),
    path('faculty_profile/', superadmin_views.faculty_profile,
         name="faculty_profile"),
    path('faculty_sidebar/', superadmin_views.faculty_sidebar,
         name="faculty_sidebar"),
    path('faculty_dash/', superadmin_views.faculty_dash, name="faculty_dash"),

    path('qr_code/', superadmin_views.qr_code, name="qr_code"),
    path('faculty_subject/', superadmin_views.faculty_subject,
         name="faculty_subject"),
    path('faculty_all_student/', superadmin_views.faculty_all_student,
         name="faculty_all_student"),
    path('faculty_stud_edit/', superadmin_views.faculty_stud_edit,
         name="faculty_stud_edit"),
    path('faculty_attendence/', superadmin_views.faculty_attendence,
         name="faculty_attendence"),
    path('faculty_attendence_1/', superadmin_views.faculty_attendence_1,
         name="faculty_attendence_1"),
    path('update_attendance/', superadmin_views.update_attendance,
         name="update_attendance"),

    #     path('faculty_login/', superadmin_views.faculty_login, name='faculty_login'),
    path('faculty_logout_view/', superadmin_views.faculty_logout_view,
         name='faculty_logout_view'),


    # APIs

    path('student/login/', superadmin_views.student_login, name='student_login'),
    path('student/profile/', superadmin_views.student_profile,
         name='student_profile'),


    path('teacher/profile/', superadmin_views.teacher_profile,
         name='teacher_profile'),
    path('teacher/login/', superadmin_views.teacher_login, name='teacher_login'),
    path('teacher/students/', superadmin_views.all_students_api,
         name='all_students_api'),


    path('teacher/faculty_today_sessions/', superadmin_views.faculty_today_sessions,
         name='faculty_today_sessions'),
    path('teacher/faculty_week_sessions/', superadmin_views.faculty_week_sessions,
         name='faculty_week_sessions'),


    path('student/today-sessions/', superadmin_views.student_today_sessions,
         name='student-today-sessions'),
    path('student/student_week_sessions/', superadmin_views.student_week_sessions,
         name='student-student_week_sessions'),


    path('student/placements/', superadmin_views.student_placement_list,
         name='student-placements'),
    path('student/mark-attendance/',
         superadmin_views.mark_attendance, name='mark_attendance'),


]