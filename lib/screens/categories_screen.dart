import 'package:flutter/material.dart';
import 'package:todo_app_eltodo/screens/screens.dart';
import 'package:todo_app_eltodo/services/services.dart';
import 'package:todo_app_eltodo/models/models.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _catNameController = TextEditingController();
  final TextEditingController _catDescriptionController =
      TextEditingController();
  final Category _category = Category();
  final CategoryService _categoryService = CategoryService();

  final List<Category> _categoryList = <Category>[];

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.name = category['name'];
        _categoryList.add(model);
      });
    });
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => debugPrint('Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                _category.name = _catNameController.text;
                _category.description = _catDescriptionController.text;
                var result = await _categoryService.saveCategory(_category);
                debugPrint(result);
              },
              child: const Text('Save'),
            ),
          ],
          title: const Text('Category form'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _catNameController,
                  decoration: const InputDecoration(
                    labelText: 'Category name',
                    hintText: 'Write category name',
                  ),
                ),
                TextField(
                  controller: _catDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Category description',
                    hintText: 'Write category description',
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Todo'),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_categoryList[index].name.toString()),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
