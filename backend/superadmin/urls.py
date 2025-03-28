from django.urls import path
from superadmin import views as superadmin_views
urlpatterns = [
    path('', superadmin_views.front_page, name='front_page'),
    path('add_blog/', superadmin_views.add_blog),
    path('add_student/', superadmin_views.add_student, name='add_student'),
    path('add_teacher/', superadmin_views.add_teacher, name="add_teacher"),
    path('all_students/', superadmin_views.all_students),
    path('all_teachers/', superadmin_views.all_teachers),
    path('blog_details/', superadmin_views.blog_details),
    path('blog/', superadmin_views.blog),
    path('calendar/', superadmin_views.calendar),
    path('edit_blog/', superadmin_views.edit_blog),
    path('edit_profile/', superadmin_views.edit_profile),
    path('edit_student/<int:id>/',
         superadmin_views.edit_student, name='edit_student'),
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
    path('show_timetable/', superadmin_views.show_timetable),
    path('coordinator_login/', superadmin_views.coordinator_login),
    # path('faculty_login/', superadmin_views.faculty_login),
    path('placement/', superadmin_views.placement),
    path('show_placement/', superadmin_views.show_placement),
    path('logout/', superadmin_views.logout_view, name='logout'),
    path('delete_course/<int:id>/', superadmin_views.delete_course),
    path('delete_department/<int:id>/', superadmin_views.delete_department),
    path('delete_teacher/<int:id>/', superadmin_views.delete_teacher),
    path('delete_student/<int:id>/', superadmin_views.delete_student),

]
