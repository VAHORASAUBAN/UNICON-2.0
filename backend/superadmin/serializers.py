from rest_framework import serializers
from .models import *


class DepartmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = department
        fields = '__all__'


class CourseSerializer(serializers.ModelSerializer):
    course_department = DepartmentSerializer(read_only=True)

    class Meta:
        model = Course
        fields = '__all__'


# class StudentSerializer(serializers.ModelSerializer):
#     student_image = serializers.SerializerMethodField()
#     student_department = DepartmentSerializer(read_only=True)
#     course = CourseSerializer(read_only=True)

#     class Meta:
#         model = Student
#         fields = '__all__'
#         extra_kwargs = {'password': {'write_only': True}}

#     def get_student_image(self, obj):
#         request = self.context.get('request')
#         if obj.student_image:
#             return request.build_absolute_uri(obj.student_image.url)
#         return None
class StudentSerializer(serializers.ModelSerializer):
    # This is where we get the image URL
    student_image = serializers.SerializerMethodField()
    student_department = DepartmentSerializer(read_only=True)
    course = CourseSerializer(read_only=True)

    class Meta:
        model = Student
        fields = '__all__'  # Include all fields
        # Ensure password is write-only
        extra_kwargs = {'password': {'write_only': True}}

    def get_student_image(self, obj):
        # This method constructs the absolute URL for student_image
        # Request context to build absolute URL
        request = self.context.get('request')
        if obj.student_image:
            return request.build_absolute_uri(obj.student_image.url)
        return None


class BatchSerializer(serializers.ModelSerializer):
    course = CourseSerializer(read_only=True)

    class Meta:
        model = Batch
        fields = '__all__'


class SubjectSerializer(serializers.ModelSerializer):
    subject_department = DepartmentSerializer(read_only=True)
    subject_batch = BatchSerializer(read_only=True)
    subject_course = CourseSerializer(read_only=True)

    class Meta:
        model = Subject
        fields = '__all__'


def get_image_url(request, image_field):
    if image_field:
        return request.build_absolute_uri(image_field.url)
    return None


class TeacherSerializer(serializers.ModelSerializer):
    pic = serializers.SerializerMethodField()
    department = DepartmentSerializer(read_only=True)
    course = CourseSerializer(read_only=True)

    class Meta:
        model = Teacher
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}}

    def get_pic(self, obj):
        return get_image_url(self.context.get('request'), obj.pic)


class PlacementSerializer(serializers.ModelSerializer):
    placement_company_logo = serializers.SerializerMethodField()
    placement_job_description = serializers.SerializerMethodField()

    class Meta:
        model = Placement
        fields = '__all__'

    def get_placement_company_logo(self, obj):
        request = self.context.get('request')
        if obj.placement_company_logo:
            return request.build_absolute_uri(obj.placement_company_logo.url)
        return None

    def get_placement_job_description(self, obj):
        request = self.context.get('request')
        if obj.placement_job_description:
            return request.build_absolute_uri(obj.placement_job_description.url)
        return None


class TimetableSerializer(serializers.ModelSerializer):
    timetable_subject_name = SubjectSerializer(read_only=True)
    faculty_name = TeacherSerializer(read_only=True)
    course = CourseSerializer(read_only=True)
    timetable_department = DepartmentSerializer(read_only=True)
    batch = BatchSerializer(read_only=True)

    class Meta:
        model = Timetable
        fields = '__all__'


class StudentProfileSerializer(serializers.ModelSerializer):
    student_image = serializers.SerializerMethodField()

    class Meta:
        model = Student
        fields = '__all__'

    def get_student_image(self, obj):
        request = self.context.get('request')
        if obj.student_image:
            return request.build_absolute_uri(obj.student_image.url)
        return None


class StudentListSerializer(serializers.ModelSerializer):
    department_name = serializers.CharField(
        source='student_department.department_name', read_only=True)
    course_name = serializers.CharField(
        source='course.course_name', read_only=True)
    student_image = serializers.SerializerMethodField()

    class Meta:
        model = Student
        fields = [
            'id', 'enrollment', 'firstname', 'middlename', 'lastname', 'email',
            'mobile_number', 'gender', 'birth_date', 'address_line_1', 'address_line_2',
            'country', 'state', 'city', 'pincode', 'semester', 'division',
            'student_image', 'department_name', 'course_name'
        ]

    def get_student_image(self, obj):
        request = self.context.get('request')
        if obj.student_image:
            return request.build_absolute_uri(obj.student_image.url)
        return None
