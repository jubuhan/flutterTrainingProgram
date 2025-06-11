import 'package:flutter/material.dart';
import '../controller/todo_controller.dart';
import '../models/todo_model.dart';

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
          _buildAddTodoSection(),
          _buildStatsSection(),
          Expanded(child: _buildTodoList()),
        ],
      ),
    );
  }

  // Add todo input section
  Widget _buildAddTodoSection() {
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
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter a new todo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onSubmitted: (value) => _addTodo(),
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _addTodo(),
            child: Text('Add'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Stats section showing counts
  Widget _buildStatsSection() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', _controller.totalCount, Colors.blue),
              _buildStatItem('Pending', _controller.pendingCount, Colors.orange),
              _buildStatItem('Done', _controller.completedCount, Colors.green),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Todo list section
  Widget _buildTodoList() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.todos.isEmpty) {
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

        return ListView.builder(
          itemCount: _controller.todos.length,
          itemBuilder: (context, index) {
            final todo = _controller.todos[index];
            return _buildTodoItem(todo);
          },
        );
      },
    );
  }

  // Individual todo item
  Widget _buildTodoItem(TodoModel todo) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => _controller.toggleTodo(todo.id),
          activeColor: Colors.green,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey[600] : Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _controller.deleteTodo(todo.id),
        ),
      ),
    );
  }

  // Helper methods
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