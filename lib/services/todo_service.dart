import 'package:todo_app_eltodo/models/models.dart';
import 'package:todo_app_eltodo/repositories/repository.dart';

class TodoService {
  late Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  insertTodo(Todo todo) async {
    return await _repository.save('Todos', todo.todoMap());
  }

  getTodos() async {
    return await _repository.getAll('Todos');
  }

  todosByCategory(String category) async {
    return await _repository.getByColumnName('Todos', 'Category', category);
  }
}
