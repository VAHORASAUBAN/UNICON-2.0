from django.db import models


class department(models.Model):
    department_name = models.CharField(max_length=100)
    department_start_date = models.DateField()

    class Meta:
        db_table = "department"
    def __str__(self):
        return self.department_name

class Course(models.Model):
    course_name = models.CharField(max_length=255)  # Course name (e.g., "Math 101")
    course_total_semesters = models.IntegerField(choices=[(i, str(i)) for i in range(1, 11)])  # Options from 1 to 10
    course_department = models.ForeignKey(department, on_delete=models.CASCADE)  # Foreign key to Department model


class Student(models.Model):
    GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
    ]
    SEMESTER_CHOICES = [(i, str(i)) for i in range(1, 11)]
    DIVISION_CHOICES = [
        ('A', 'A'),
        ('B', 'B'),
        ('C', 'C'),
    ]

    enrollment = models.IntegerField(unique=True)
    firstname = models.CharField(max_length=50)
    middlename = models.CharField(max_length=50, null=True, blank=True)
    lastname = models.CharField(max_length=50)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=128)
    mobile_number = models.CharField(max_length=15)
    gender = models.CharField(max_length=6, choices=GENDER_CHOICES)
    birth_date = models.DateField()
    address_line_1 = models.CharField(max_length=255)
    address_line_2 = models.CharField(max_length=255, null=True, blank=True)
    country = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    pincode = models.CharField(max_length=10)
    student_department = models.ForeignKey(department, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    semester = models.IntegerField(choices=SEMESTER_CHOICES)
    division = models.CharField(max_length=1, choices=DIVISION_CHOICES)
    student_image = models.ImageField(upload_to='student_images/', null=True, blank=True)

    def __str__(self):
        return f'{self.firstname} {self.lastname} ({self.enrollment})'


class Teacher(models.Model):
    GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
    ]

    faculty_id = models.CharField(max_length=20, unique=True)
    firstname = models.CharField(max_length=50)
    middlename = models.CharField(max_length=50, null=True, blank=True)
    lastname = models.CharField(max_length=50)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=128)
    mobile_number = models.CharField(max_length=15)
    gender = models.CharField(max_length=6, choices=GENDER_CHOICES)
    birth_date = models.DateField()
    address_line_1 = models.CharField(max_length=255)
    address_line_2 = models.CharField(max_length=255, null=True, blank=True)
    country = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    pincode = models.CharField(max_length=10)
    joining_date = models.DateField()
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    department = models.ForeignKey(department, on_delete=models.CASCADE)
    designations = models.CharField(max_length=255)
    achievements = models.TextField(null=True, blank=True)
    qualification = models.CharField(max_length=255)
    pic = models.ImageField(upload_to='teacher_images/', null=True, blank=True)