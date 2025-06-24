import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoModel> _todos = [];
  static const String _todosKey = 'todos';
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;

  List<TodoModel> get todos => List.unmodifiable(_todos);
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get pendingCount => totalCount - completedCount;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Load todos from API first, fallback to local storage
  Future<void> loadTodos() async {
    _setLoading(true);
    _setError(null);

    try {
      // Try to load from API first
      final apiTodos = await _apiService.getTodos();
      _todos = apiTodos;
      
      // Save to local storage as backup
      await _saveTodosLocally();
      
    } catch (e) {
      debugPrint('API load failed: $e');
      _setError('Failed to load from server, showing local data');
      
      // Fallback to local storage
      await _loadTodosLocally();
    }
    
    _setLoading(false);
  }

  // Load from SharedPreferences (local storage)
  Future<void> _loadTodosLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString(_todosKey);

      if (todosJson != null) {
        final List<dynamic> decodedTodos = json.decode(todosJson);
        _todos = decodedTodos.map((todo) => TodoModel.fromJson(todo)).toList();
      }
    } catch (e) {
      debugPrint('Error loading local todos: $e');
    }
  }

  // Save to SharedPreferences (local storage)
  Future<void> _saveTodosLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = json.encode(_todos.map((todo) => todo.toJson()).toList());
      await prefs.setString(_todosKey, todosJson);
    } catch (e) {
      debugPrint('Error saving local todos: $e');
    }
  }

  // Add new todo
  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;

    _setLoading(true);
    _setError(null);

    try {
      // Try API first
      final newTodo = await _apiService.createTodo(title.trim());
      _todos.add(newTodo);
      
      // Save locally as backup
      await _saveTodosLocally();
      
    } catch (e) {
      debugPrint('API add failed: $e');
      _setError('Failed to add todo to server');
      
      // Fallback to local creation
      final todo = TodoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        createdAt: DateTime.now(),
      );
      _todos.add(todo);
      await _saveTodosLocally();
    }
    
    _setLoading(false);
    notifyListeners();
  }

  // Toggle todo status
  Future<void> toggleTodo(String id) async {
    _setError(null);
    
    try {
      // Optimistic update
      final todoIndex = _todos.indexWhere((t) => t.id == id);
      if (todoIndex != -1) {
        _todos[todoIndex].toggle();
        notifyListeners();
      }

      // Try API update
      final updatedTodo = await _apiService.toggleTodo(id);
      
      // Update with server response
      if (todoIndex != -1) {
        _todos[todoIndex] = updatedTodo;
      }
      
      await _saveTodosLocally();
      
    } catch (e) {
      debugPrint('API toggle failed: $e');
      _setError('Failed to sync with server');
      
      // Keep local change and save locally
      await _saveTodosLocally();
    }
    
    notifyListeners();
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    _setError(null);
    
    try {
      // Optimistic delete
      final todoIndex = _todos.indexWhere((todo) => todo.id == id);
      TodoModel? removedTodo;
      
      if (todoIndex != -1) {
        removedTodo = _todos.removeAt(todoIndex);
        notifyListeners();
      }

      // Try API delete
      await _apiService.deleteTodo(id);
      await _saveTodosLocally();
      
    } catch (e) {
      debugPrint('API delete failed: $e');
      _setError('Failed to delete from server');
      
      // Keep local delete and save locally
      await _saveTodosLocally();
    }
  }

  // Clear all completed todos
  Future<void> clearCompleted() async {
    _setLoading(true);
    _setError(null);

    try {
      // Try API first
      await _apiService.clearCompleted();
      _todos.removeWhere((todo) => todo.isCompleted);
      await _saveTodosLocally();
      
    } catch (e) {
      debugPrint('API clear completed failed: $e');
      _setError('Failed to clear completed from server');
      
      // Fallback to local clear
      _todos.removeWhere((todo) => todo.isCompleted);
      await _saveTodosLocally();
    }
    
    _setLoading(false);
    notifyListeners();
  }

  // Clear all todos
  Future<void> clearAllTodos() async {
    _setLoading(true);
    _setError(null);

    try {
      // Try API first
      await _apiService.clearAll();
      _todos.clear();
      await _saveTodosLocally();
      
    } catch (e) {
      debugPrint('API clear all failed: $e');
      _setError('Failed to clear all from server');
      
      // Fallback to local clear
      _todos.clear();
      await _saveTodosLocally();
    }
    
    _setLoading(false);
    notifyListeners();
  }

  // Sync with server 
  Future<void> syncWithServer() async {
    await loadTodos();
  }

  // Clear error message
  void clearError() {
    _setError(null);
  }
}