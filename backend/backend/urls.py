"""
URL configuration for backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from root import views as root_views
from faculty import views as faculty_views
from superadmin import views as superadmin_views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', root_views.index, name='index'),

    # all faculty urls 
    path('dashboard/', faculty_views.dashboard, name='dashboard'),
    path('facultyprofile/', faculty_views.facultyprofile, name='facultyprofile'),
    # path('dashboard/', faculty_views.dashboard, name='dashboard'),
    path('facultysubjects/', faculty_views.facultysubjects, name='facultysubjects'),
    path('attendance/', faculty_views.attendance, name='attendance'),
    path('subjects/', faculty_views.subjects, name='subjects'),
    path('facultylogout/', faculty_views.logout, name='logout'),



    # all superadmin urls 
    path('superadminindex/', superadmin_views.superadminIndex, name='superadminindex'),

]
