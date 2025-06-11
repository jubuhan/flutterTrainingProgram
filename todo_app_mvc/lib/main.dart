


import 'package:flutter/material.dart';
import 'screens/todo_view.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Todo MVC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoView(),
      debugShowCheckedModeBanner: false,
    );
  }
}