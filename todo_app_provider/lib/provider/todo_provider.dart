import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoModel> _todos = [];
  static const String _todosKey = 'todos';

  List<TodoModel> get todos => List.unmodifiable(_todos);

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get pendingCount => totalCount - completedCount;

  Future<void> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString(_todosKey);

      if (todosJson != null) {
        final List<dynamic> decodedTodos = json.decode(todosJson);
        _todos = decodedTodos.map((todo) => TodoModel.fromJson(todo)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading todos: $e');
    }
  }

  // Save to SharedPreferences
  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson =
          json.encode(_todos.map((todo) => todo.toJson()).toList());
      await prefs.setString(_todosKey, todosJson);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  // Add new todo
  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

    _todos.add(todo);
    notifyListeners();
    await _saveTodos();
  }
  
  // Toggle todo status
  Future<void> toggleTodo(String id) async {
    try {
      final todo = _todos.firstWhere((t) => t.id == id);
      todo.toggle();
      notifyListeners();
      await _saveTodos();
    } catch (e) {
      debugPrint('Error toggling todo: $e');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
    await _saveTodos();
  }

  // Clear all completed todos
  Future<void> clearCompleted() async {
    _todos.removeWhere((todo) => todo.isCompleted);
    notifyListeners();
    await _saveTodos();
  }

  // Clear all todos
  Future<void> clearAllTodos() async {
    _todos.clear();
    notifyListeners();
    await _saveTodos();
  }
}
