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
              onPressed: () {
                _category.name = _catNameController.text;
                _category.description = _catDescriptionController.text;
                _categoryService.saveCategory(_category);
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
      body: const Center(
        child: Text(
          'Categories screen',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
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
