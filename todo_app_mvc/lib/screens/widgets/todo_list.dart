import 'package:flutter/material.dart';
import '../../controller/todo_controller.dart';

import 'todo_item.dart';

class TodoListSection extends StatelessWidget {
  final TodoController controller;
  final Function(String) onToggleTodo;
  final Function(String) onDeleteTodo;

  const TodoListSection({
    Key? key,
    required this.controller,
    required this.onToggleTodo,
    required this.onDeleteTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.todos.isEmpty) {
          return EmptyTodoState();
        }

        return ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return TodoItem(
              todo: todo,
              onToggle: () => onToggleTodo(todo.id),
              onDelete: () => onDeleteTodo(todo.id),
            );
          },
        );
      },
    );
  }
}

class EmptyTodoState extends StatelessWidget {
  const EmptyTodoState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No todos yet!\nAdd one above to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}