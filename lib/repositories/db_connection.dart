import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  setDatabase() async {
    String path = join(await getDatabasesPath(), "core1.db");
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }
  static const todoCategories = 'CREATE TABLE Categories (id INTEGER PRIMARY KEY, name '
      'TEXT, description TEXT)';

  static const todoTodos = 'CREATE TABLE Todos (id INTEGER PRIMARY KEY, title TEXT,'
      ' description TEXT, category TEXT, todoDate TEXT, isFinished INTEGER)';

  _onCreatingDatabase(Database db, int version) async {
    await db.execute(todoCategories);
    await db.execute(todoTodos);
  }
}
