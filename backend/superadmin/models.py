from django.db import models

class department(models.Model):
    department_name = models.CharField(max_length=100)
    department_start_date = models.DateField()

    class Meta:
        db_table = 'department'