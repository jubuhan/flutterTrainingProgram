# todos/views.py
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import Todo
from .serializers import TodoSerializer

class TodoViewSet(viewsets.ModelViewSet):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer

    @action(detail=True, methods=['patch'])
    def toggle(self, request, pk=None):
        """Toggle the completion status of a todo"""
        todo = get_object_or_404(Todo, pk=pk)
        todo.is_completed = not todo.is_completed
        todo.save()
        serializer = self.get_serializer(todo)
        return Response(serializer.data)

    @action(detail=False, methods=['delete'])
    def clear_completed(self, request):
        """Delete all completed todos"""
        deleted_count = Todo.objects.filter(is_completed=True).delete()[0]
        return Response({
            'message': f'{deleted_count} completed todos deleted',
            'deleted_count': deleted_count
        })

    @action(detail=False, methods=['delete'])
    def clear_all(self, request):
        """Delete all todos"""
        deleted_count = Todo.objects.all().delete()[0]
        return Response({
            'message': f'All {deleted_count} todos deleted',
            'deleted_count': deleted_count
        })

    @action(detail=False, methods=['get'])
    def stats(self, request):
        """Get todo statistics"""
        total_count = Todo.objects.count()
        completed_count = Todo.objects.filter(is_completed=True).count()
        pending_count = total_count - completed_count
        
        return Response({
            'total_count': total_count,
            'completed_count': completed_count,
            'pending_count': pending_count
        })