import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/todo_model.dart';
import '../../provider/todo_provider.dart';

class TodoItem extends StatefulWidget {
  final TodoModel todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool _isToggling = false;
  bool _isDeleting = false;

  Future<void> _toggleTodo() async {
    if (_isToggling) return;

    setState(() {
      _isToggling = true;
    });

    try {
      await context.read<TodoProvider>().toggleTodo(widget.todo.id);
    } finally {
      if (mounted) {
        setState(() {
          _isToggling = false;
        });
      }
    }
  }

  Future<void> _deleteTodo() async {
    if (_isDeleting) return;

    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${widget.todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await context.read<TodoProvider>().deleteTodo(widget.todo.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted: ${widget.todo.title}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete todo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: _isDeleting ? 0 : 1,
      child: AnimatedOpacity(
        opacity: _isDeleting ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: ListTile(
          leading: _isToggling
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Checkbox(
                  value: widget.todo.isCompleted,
                  onChanged: (_) => _toggleTodo(),
                  activeColor: Colors.green,
                ),
          title: Text(
            widget.todo.title,
            style: TextStyle(
              decoration: widget.todo.isCompleted 
                  ? TextDecoration.lineThrough 
                  : null,
              color: widget.todo.isCompleted 
                  ? Colors.grey[600] 
                  : Colors.black,
              fontWeight: widget.todo.isCompleted 
                  ? FontWeight.normal 
                  : FontWeight.w500,
            ),
          ),
          subtitle: widget.todo.createdAt != null
              ? Text(
                  _formatDate(widget.todo.createdAt!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                )
              : null,
          trailing: _isDeleting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteTodo,
                  tooltip: 'Delete todo',
                ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todoDate = DateTime(date.year, date.month, date.day);

    if (todoDate == today) {
      return 'Today ${_formatTime(date)}';
    } else if (todoDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}