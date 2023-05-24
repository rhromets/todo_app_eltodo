import 'package:flutter/material.dart';
import 'package:todo_app_eltodo/models/models.dart';
import 'package:todo_app_eltodo/services/services.dart';

class TodosByCategory extends StatefulWidget {
  final String category;

  const TodosByCategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<TodosByCategory> createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  final List<Todo> _todoList = [];
  final TodoService _todoService = TodoService();

  getTodosByCategory() async {
    var todos = await _todoService.todosByCategory(widget.category);
    todos.forEach((todo) {
      var model = Todo();
      setState(() {
        model.title = todo['title'];
        _todoList.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTodosByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos by category'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 26.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,
                          vertical: 12.0),
                      child: Text(
                        _todoList[index].title ?? 'No todos title',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
