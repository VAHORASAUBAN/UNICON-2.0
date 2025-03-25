from django.db import models
from django.contrib.auth.models import User

class coordinator(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE,default=1)
    first_name = models.CharField(max_length=100, null=True, blank=True)
    middle_name = models.CharField(max_length=100, null=True, blank=True)
    last_name = models.CharField(max_length=100, null=True, blank=True)
    email = models.EmailField(null=True, blank=True)
    mobile_number = models.BigIntegerField(null=True, blank=True)
    gender = models.CharField(max_length=100, null=True, blank=True)
    birth_date = models.DateField(null=True, blank=True)
    address_line_1 = models.CharField(max_length=100, null=True, blank=True)
    address_line_2 = models.CharField(max_length=100, null=True, blank=True)
    country = models.CharField(max_length=100, null=True, blank=True)
    state = models.CharField(max_length=100, null=True, blank=True)
    city = models.CharField(max_length=100, null=True, blank=True)
    pincode = models.IntegerField(null=True, blank=True)
    joining_date = models.DateField(null=True, blank=True)
    course = models.CharField(max_length=100, null=True, blank=True)
    department = models.CharField(max_length=100, null=True, blank=True)
    designation = models.CharField(max_length=100, null=True, blank=True)
    achievements = models.CharField(max_length=100, null=True, blank=True)
    qualification = models.CharField(max_length=100, null=True, blank=True)
    coordinator_image = models.ImageField(upload_to='coordinator_image/', null=True, blank=True)

    class Meta:
        db_table = 'coordinator'
    
    def __str__(self):
        return self.first_name