from django.contrib import admin
from .models import *
# Register your models here.

admin.site.register(Teacher)


class TeacherAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'phone_number', 'subject')
