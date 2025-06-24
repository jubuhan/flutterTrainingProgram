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
  final FocusNode _focusNode = FocusNode();
  bool _isAdding = false;

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _addTodo() async {
    final title = _textController.text.trim();
    if (title.isEmpty || _isAdding) return;

    setState(() {
      _isAdding = true;
    });

    try {
      await context.read<TodoProvider>().addTodo(title);
      _textController.clear();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added: $title'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Error handling is done in the provider
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add todo. Check your connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  enabled: !_isAdding,
                  decoration: InputDecoration(
                    hintText: 'Enter a new todo...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, 
                      vertical: 8,
                    ),
                    suffixIcon: _isAdding
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                  onSubmitted: (_) => _addTodo(),
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isAdding ? null : _addTodo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20, 
                    vertical: 12,
                  ),
                ),
                child: _isAdding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Add'),
              ),
            ],
          ),
          
          // Connection status indicator
          const SizedBox(height: 8),
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              if (todoProvider.error != null) {
                return Row(
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 14,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Working offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                );
              }
              
              return Row(
                children: [
                  Icon(
                    Icons.wifi,
                    size: 14,
                    color: Colors.green[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Connected to server',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}