import 'package:flutter/material.dart';

class AddTodoSection extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onAddTodo;

  const AddTodoSection({
    Key? key,
    required this.textController,
    required this.onAddTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter a new todo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onSubmitted: (_) => onAddTodo(),
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: onAddTodo,
            child: Text('Add'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}