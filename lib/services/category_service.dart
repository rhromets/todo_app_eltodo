import 'package:todo_app_eltodo/models/models.dart';
import 'package:todo_app_eltodo/repositories/repository.dart';

class CategoryService {
  late Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  saveCategory(Category category) async {
    await _repository.save('Categories', category.categoryMap());
  }

  getCategories() async {
    return await _repository.getAll('Categories');
  }

  getCategoryById(int categoryId) async {
   return await _repository.getById('Categories', categoryId);
  }

  updateCategory(Category category) async {
    return await _repository.update('Categories', category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.delete('Categories', categoryId);
  }
}