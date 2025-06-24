# todos/models.py
from django.db import models
import uuid

def generate_uuid():
    return str(uuid.uuid4())

class Todo(models.Model):
    id = models.CharField(max_length=100, primary_key=True, default=generate_uuid)
    title = models.CharField(max_length=255)
    is_completed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return self.title