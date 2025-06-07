import 'package:flutter/material.dart';

void main() {
  runApp( TodoApp());
}

class TodoApp extends StatelessWidget {
  
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do-App',
      theme: ThemeData(
       primarySwatch: Colors.blue,
       visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home:  Todoscreen(),
    );
  }
}
class TodoItem{
  String title;
  bool isCompleted;
  DateTime createdAt;
  TodoItem({
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }):createdAt=createdAt ?? DateTime.now();

}

class Todoscreen extends StatefulWidget{
  @override
  _TodoScreenState createState() => _TodoScreenState();
}
class _TodoScreenState extends State<Todoscreen>{

final List<TodoItem> _todos = [];
final TextEditingController _controller = TextEditingController();

void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(title: _controller.text.trim()));
        _controller.clear();
      });
    }
  }

void _toggleTodo(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do-List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: 
                
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Add a new task',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onSubmitted: (_) => _addTodo(),
                ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _todos.isEmpty?
          Center(child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt,size: 64,color:Colors.grey,),
              SizedBox(height: 16),
              Text('No tasks yet!', style: TextStyle(fontSize: 24, color: Colors.grey)),
              Text('Add a task to get started!', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          ):ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              final todo=_todos[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Checkbox(value: todo.isCompleted, onChanged:(_)=> _toggleTodo(index),),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                      color: todo.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTodo(index),
                ),
              ),
              );
              
            },
          )
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Text(
          'Total:${_todos.length} tasks|completed:${_todos.where((todo) => todo.isCompleted).length} tasks',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
        ),
      ),
    );

}
@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }}