import 'package:flutter/material.dart';
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

  final List<DropdownMenuItem> _categories = <DropdownMenuItem>[];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var categoryService = CategoryService();
    var categories = await categoryService.getCategories();
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

  DateTime _date = DateTime.now();

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
                labelText: 'Cook food',
              ),
            ),
            TextField(
              controller: _todoDescription,
              decoration: const InputDecoration(
                hintText: 'Todo description',
                labelText: 'Cook rice and carry',
              ),
            ),
            TextField(
              controller: _todoDate,
              decoration: InputDecoration(
                hintText: 'YY-MM-DD',
                labelText: 'YY-MM-DD',
                prefixIcon: InkWell(
                  onTap: (){
                    _selectTodoDate(context);
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              items: _categories,
              hint: const Text('Select one category'),
              onChanged: (value) {},
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
