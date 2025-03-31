from rest_framework import serializers
from .models import *


class StudentSerializer(serializers.ModelSerializer):
    student_image = serializers.SerializerMethodField()

    class Meta:
        model = Student
        fields = '__all__'

    def get_student_image(self, obj):
        request = self.context.get('request')
        if obj.student_image:
            return request.build_absolute_uri(obj.student_image.url)
        return None
