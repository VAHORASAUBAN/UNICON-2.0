from django.db import models
from django.contrib.auth.models import User


class department(models.Model):
    department_name = models.CharField(max_length=100)
    department_start_date = models.DateField()

    class Meta:
        db_table = "department"

    def __str__(self):
        return self.department_name


class Course(models.Model):
    # Course name (e.g., "Math 101")
    course_name = models.CharField(max_length=255)
    course_total_semesters = models.IntegerField(
        choices=[(i, str(i)) for i in range(1, 11)])  # Options from 1 to 10
    course_department = models.ForeignKey(
        department, on_delete=models.CASCADE)  # Foreign key to Department model


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

    enrollment = models.BigIntegerField(unique=True)
    firstname = models.CharField(max_length=50)
    middlename = models.CharField(max_length=50, null=True, blank=True)
    lastname = models.CharField(max_length=50)
    email = models.EmailField(unique=True)
    # Hashed password store ke liye
    password = models.CharField(max_length=128)
    mobile_number = models.CharField(max_length=15)
    gender = models.CharField(max_length=6, choices=GENDER_CHOICES)
    birth_date = models.DateField(null=True, blank=True)
    address_line_1 = models.CharField(max_length=255)
    address_line_2 = models.CharField(max_length=255, null=True, blank=True)
    country = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    pincode = models.CharField(max_length=10)
    student_department = models.ForeignKey(
        department, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    semester = models.IntegerField(choices=SEMESTER_CHOICES)
    division = models.CharField(max_length=1, choices=DIVISION_CHOICES)
    student_image = models.ImageField(
        upload_to='student_images/', null=True, blank=True)

    def save(self, *args, **kwargs):
        """ Ensure password is always saved as a hash """
        if not self.password.startswith('pbkdf2_sha256$'):  # Prevent double hashing
            self.password = make_password(self.password)
        super().save(*args, **kwargs)

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
    birth_date = models.DateField(null=True, blank=True)
    address_line_1 = models.CharField(max_length=255)
    address_line_2 = models.CharField(max_length=255, null=True, blank=True)
    country = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    pincode = models.CharField(max_length=10)
    joining_date = models.DateField(null=True, blank=True)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    department = models.ForeignKey(department, on_delete=models.CASCADE)
    designations = models.CharField(max_length=255)
    achievements = models.TextField(null=True, blank=True)
    qualification = models.CharField(max_length=255)
    pic = models.ImageField(upload_to='teacher_images/', null=True, blank=True)

    def __str__(self):
        return f'{self.firstname} {self.lastname} ({self.faculty_id})'


class Batch(models.Model):
    batch_start_year = models.IntegerField()
    batch_end_year = models.IntegerField()
    course = models.ForeignKey(Course, on_delete=models.CASCADE)

    class Meta:
        db_table = "batch"


class Subject(models.Model):
    subject_code = models.CharField(max_length=10, unique=True)
    subject_name = models.CharField(max_length=255)
    subject_department = models.ForeignKey(
        department, on_delete=models.CASCADE)  # Foreign key to Department model
    subject_batch = models.ForeignKey(
        Batch, on_delete=models.CASCADE)  # Foreign key to Batch model
    subject_semester = models.IntegerField(
        choices=[(i, str(i)) for i in range(1, 11)])  # Options from 1 to 10
    subject_course = models.ForeignKey(Course, on_delete=models.CASCADE)

    class Meta:
        db_table = "subject"

    def __str__(self):
        return self.subject_name


class Placement(models.Model):
    placement_company_name = models.CharField(
        max_length=255, blank=True, null=True)
    job_role = models.CharField(max_length=255, blank=True, null=True)
    placement_company_location = models.CharField(
        max_length=255, blank=True, null=True)
    placement_company_package = models.CharField(
        max_length=255, blank=True, null=True)
    interview_date = models.DateField(blank=True, null=True)
    deadline_date = models.DateField(blank=True, null=True)
    placement_company_logo = models.ImageField(
        upload_to="placement_logos/", blank=True, null=True)
    placement_job_description = models.FileField(
        upload_to="placement_docs/", blank=True, null=True)

    class Meta:
        db_table = "placements"


class Timetable(models.Model):
    timetable_subject_name = models.ForeignKey(
        Subject, on_delete=models.CASCADE)
    faculty_name = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    day = models.CharField(
        max_length=20,
        choices=[
            ('Monday', 'Monday'),
            ('Tuesday', 'Tuesday'),
            ('Wednesday', 'Wednesday'),
            ('Thursday', 'Thursday'),
            ('Friday', 'Friday'),
            ('Saturday', 'Saturday'),
        ]
    )
    lecture_start_time = models.CharField(max_length=20)
    lecture_end_time = models.CharField(max_length=20)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    timetable_department = models.ForeignKey(
        department, on_delete=models.CASCADE)
    # Add semester as IntegerField (or CharField if required)
    # semester = models.IntegerField()
    semester = models.IntegerField(null=True, blank=True)

    batch = models.ForeignKey(Batch, on_delete=models.CASCADE)
    division = models.CharField(max_length=1, choices=[
        ('A', 'A'),
        ('B', 'B'),
        ('C', 'C')
    ])

    def __str__(self):
        return f"{self.timetable_subject_name} - {self.day} ({self.start_time} to {self.end_time})"
