import 'package:sqflite/sqflite.dart';
import 'package:todo_app_eltodo/repositories/db_connection.dart';

class Repository {
  static Database? _database;
  late DatabaseConnection _connection;

  Repository() {
    _connection = DatabaseConnection();
  }

  Future<Database?> get database async {
    if(_database != null) return _database;
    _database = await _connection.setDatabase();
    return _database;
  }

  save(table, data) async {
    Database? conn = await database;
    return await conn!.insert(table, data);
  }

  getAll(table) async {
    var conn = await database;
    return await conn!.query(table);
  }

  getById(String table, int itemId) async {
    var conn = await database;
   return await conn!.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  update(String table, data) async {
    var conn = await database;
    return await conn!.update(table, data, where: 'id = ?', whereArgs:
    [data['id']]);
  }

  delete(String table, itemId) async {
    var conn = await database;
    return await conn!.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }
}



