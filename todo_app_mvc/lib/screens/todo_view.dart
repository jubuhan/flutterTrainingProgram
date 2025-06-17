import 'package:flutter/material.dart';
import '../controller/todo_controller.dart';

import 'widgets/add_todo.dart';
import 'widgets/stats_section.dart';
import 'widgets/todo_list.dart';

class TodoView extends StatefulWidget {
  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TodoController _controller = TodoController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Todo MVC'),
        backgroundColor: Colors.blue,
        actions: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return _controller.completedCount > 0
                  ? IconButton(
                      icon: Icon(Icons.clear_all),
                      onPressed: () => _showClearDialog(),
                      tooltip: 'Clear completed',
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AddTodoSection(
            textController: _textController,
            onAddTodo: _addTodo,
          ),
          StatsSection(controller: _controller),
          Expanded(
            child: TodoListSection(
              controller: _controller,
              onToggleTodo: _controller.toggleTodo,
              onDeleteTodo: _controller.deleteTodo,
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    final title = _textController.text;
    if (title.isNotEmpty) {
      _controller.addTodo(title);
      _textController.clear();
    }
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Completed'),
        content: Text('Remove all completed todos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _controller.clearCompleted();
              Navigator.pop(context);
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}