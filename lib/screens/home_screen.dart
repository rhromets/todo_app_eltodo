import 'package:flutter/material.dart';
import 'package:todo_app_eltodo/models/models.dart';
import 'package:todo_app_eltodo/screens/screens.dart';
import 'package:todo_app_eltodo/services/services.dart';
import 'package:todo_app_eltodo/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TodoService _todoService;
  late List<Todo> _todoList;

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = [];
    var todos = await _todoService.getTodos();
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];
        model.category = todo['category'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Todo'),
      ),
      drawer: const DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, int index) {
          return Card(
            child: ListTile(
              title: Row(
                children: [
                  Text(_todoList[index].title ?? 'No title'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TodoScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
