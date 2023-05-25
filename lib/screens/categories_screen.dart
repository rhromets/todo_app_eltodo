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

  List<Category> _categoryList = [];

  final TextEditingController _editCatName = TextEditingController();
  final TextEditingController _editCatDescription = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var category;

  bool _isEmptyScreen = true;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = <Category>[];
    List categories = await _categoryService.getCategories();
    _checkCategoriesList(categories);
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.name = category['name'];
        model.id = category['id'];
        model.description = category['description'];
        _categoryList.add(model);
      });
    });
  }

  _checkCategoriesList(categories) {
    categories.length == 0 ? _isEmptyScreen = true : _isEmptyScreen = false;
  }

  clearTextFields() {
    _catNameController.text = '';
    _catDescriptionController.text = '';
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _category.name = _catNameController.text;
                _category.description = _catDescriptionController.text;
                await _categoryService.saveCategory(_category);
                clearTextFields();
                getAllCategories();
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

  _editCategoryDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
                );
                _category.id = category[0]['id'];
                _category.name = _editCatName.text;
                _category.description = _editCatDescription.text;
                await _categoryService.updateCategory(_category);
                getAllCategories();
                _showSnackBar(const Text('Success'));
              },
              child: const Text('Edit'),
            ),
          ],
          title: const Text('Category edit form'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _editCatName,
                  decoration: const InputDecoration(
                    labelText: 'Category name',
                    hintText: 'Write category name',
                  ),
                ),
                TextField(
                  controller: _editCatDescription,
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

  _deleteCategoryDialog(BuildContext context, categoryId) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
                );
                await _categoryService.deleteCategory(categoryId);
                getAllCategories();
                _showSnackBar(const Text('Success'));
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          title: const Text('Are you sure, you want to delete?'),
        );
      },
    );
  }

  _editCategory(BuildContext context, int categoryId) async {
    _editCategoryDialog(context);
    category = await _categoryService.getCategoryById(categoryId);
    setState(() {
      _editCatName.text = category[0]['name'] ?? 'No name';
      _editCatDescription.text = category[0]['description'] ?? 'No description';
    });
  }

  _showSnackBar(message) {
    var snackBar = SnackBar(
      content: message,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
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
      body: _isEmptyScreen
          ? const Center(
              child: Text(
                'Please create a category',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black45,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editCategory(context, _categoryList[index].id!);
                      },
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_categoryList[index].name ?? 'Category name'),
                        IconButton(
                          onPressed: () {
                            _deleteCategoryDialog(
                                context, _categoryList[index].id);
                          },
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
