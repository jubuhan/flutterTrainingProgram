import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class TodoController extends ChangeNotifier {
  final List<TodoModel> _todos = [];

  // Getter to access todos
  List<TodoModel> get todos => List.unmodifiable(_todos);

  // Get counts
  int get totalCount => _todos.length;
  int get completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get pendingCount => totalCount - completedCount;

  // Add new todo
  void addTodo(String title) {
    if (title.trim().isEmpty) return;
    
    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    
    _todos.add(todo);
    notifyListeners();
  }

  // Toggle todo status
  void toggleTodo(String id) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.toggle();
    notifyListeners();
  }

  // Delete a todo
  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  // Clear all completed todo
  void clearCompleted() {
    _todos.removeWhere((todo) => todo.isCompleted);
    notifyListeners();
  }
}