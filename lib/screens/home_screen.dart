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
    getAllTodos();
    super.initState();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = [];
    List todos = await _todoService.getTodos();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_todoList[index].title ?? 'No title'),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      await _todoService.deleteTodo(_todoList[index].id);
                      setState(() {
                        getAllTodos();
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100.0),
      ),
      bottomSheet: Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, -1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
          child: TextButton(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 15.0),
                Text(
                  'CREATE TODO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TodoScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
