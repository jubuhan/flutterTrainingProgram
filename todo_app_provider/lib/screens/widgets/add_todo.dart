import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/todo_provider.dart';


class AddTodoSection extends StatefulWidget {
  const AddTodoSection({Key? key}) : super(key: key);

  @override
  State<AddTodoSection> createState() => _AddTodoSectionState();
}

class _AddTodoSectionState extends State<AddTodoSection> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final title = _textController.text.trim();
    if (title.isNotEmpty) {
      context.read<TodoProvider>().addTodo(title);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter a new todo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onSubmitted: (_) => _addTodo(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _addTodo,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}