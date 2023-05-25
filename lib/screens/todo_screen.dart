import 'package:flutter/material.dart';
import 'package:todo_app_eltodo/models/models.dart';
import 'package:todo_app_eltodo/screens/screens.dart';
import 'package:todo_app_eltodo/services/services.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _todoTitle = TextEditingController();
  final TextEditingController _todoDescription = TextEditingController();
  final TextEditingController _todoDate = TextEditingController();

  final List<DropdownMenuItem> _categories = [];

  final TodoService todoService = TodoService();

  DateTime _date = DateTime.now();

  // ignore: prefer_typing_uninitialized_variables
  var _selectedValue;

  bool isShowSaveBtn = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var categoryService = CategoryService();
    var categories = await categoryService.getCategories();
    if (categories.isEmpty) {
      setState(() {
        isShowSaveBtn = false;
      });
    } else {
      setState(() {
        isShowSaveBtn = true;
      });
    }
    categories.forEach((category) {
      setState(() {
        _categories.add(
          DropdownMenuItem(
            value: category['name'],
            child: Text(
              category['name'],
            ),
          ),
        );
      });
    });
  }

  _selectTodoDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
        _todoDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoTitle,
              decoration: const InputDecoration(
                hintText: 'Todo title',
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _todoDescription,
              decoration: const InputDecoration(
                hintText: 'Todo description',
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: _todoDate,
              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                labelText: 'YYYY-MM-DD',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectTodoDate(context);
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint: const Text('Select one category'),
              onChanged: (value) {
                _selectedValue = value;
              },
            ),
            const SizedBox(height: 20.0),
            isShowSaveBtn
                ? TextButton(
                    onPressed: () async {
                      Todo todoObj = Todo();
                      todoObj.title = _todoTitle.text;
                      todoObj.description = _todoDescription.text;
                      todoObj.todoDate = _todoDate.text;
                      todoObj.category = _selectedValue.toString();
                      todoObj.isFinished = 0;
                      TodoService todoService = TodoService();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                      await todoService.insertTodo(todoObj);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoriesScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Go to Categories',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
