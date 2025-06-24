import 'package:dio/dio.dart';
import '../models/todo_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptors for logging 
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  // Get all todos
  Future<List<TodoModel>> getTodos() async {
    try {
      final response = await _dio.get('/todos/');
      if (response.statusCode == 200) {
        final List<dynamic> todosJson = response.data;
        return todosJson.map((json) => TodoModel.fromApiJson(json)).toList();
      }
      throw Exception('Failed to load todos');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Create a new todo
  Future<TodoModel> createTodo(String title) async {
    try {
      final response = await _dio.post('/todos/', data: {
        'title': title,
        'is_completed': false,
      });
      if (response.statusCode == 201) {
        return TodoModel.fromApiJson(response.data);
      }
      throw Exception('Failed to create todo');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Toggle todo completion status
  Future<TodoModel> toggleTodo(String id) async {
    try {
      final response = await _dio.patch('/todos/$id/toggle/');
      if (response.statusCode == 200) {
        return TodoModel.fromApiJson(response.data);
      }
      throw Exception('Failed to toggle todo');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    try {
      final response = await _dio.delete('/todos/$id/');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete todo');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Clear all completed todos
  Future<Map<String, dynamic>> clearCompleted() async {
    try {
      final response = await _dio.delete('/todos/clear_completed/');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to clear completed todos');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Clear all todos
  Future<Map<String, dynamic>> clearAll() async {
    try {
      final response = await _dio.delete('/todos/clear_all/');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to clear all todos');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Get todo statistics
  Future<Map<String, int>> getStats() async {
    try {
      final response = await _dio.get('/todos/stats/');
      if (response.statusCode == 200) {
        return Map<String, int>.from(response.data);
      }
      throw Exception('Failed to get stats');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}