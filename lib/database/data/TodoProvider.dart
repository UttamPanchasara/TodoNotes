import 'package:todo/database/data/Todo.dart';

import '../db_helper.dart';

class TodoProvider {
  Future<Todo> insert(Todo todo) async {
    todo.id = await DBHelper.dbHelper
        .getDatabase()
        .insert(Todo.TABLE_NAME, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps =
        await DBHelper.dbHelper.getDatabase().query(Todo.TABLE_NAME,
            columns: [
              Todo.columnId,
              Todo.columnTitle,
              Todo.columnDescription,
              Todo.columnCreatedAt,
              Todo.columnColor
            ],
            where: '${Todo.columnId} = ?',
            whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> getAllTodo() async {
    var res = await DBHelper.dbHelper
        .getDatabase()
        .query(Todo.TABLE_NAME, orderBy: Todo.columnCreatedAt + " DESC");
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> delete(int id) async {
    return await DBHelper.dbHelper.getDatabase().delete(Todo.TABLE_NAME,
        where: '${Todo.columnId} = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await DBHelper.dbHelper.getDatabase().update(
        Todo.TABLE_NAME, todo.toMap(),
        where: '${Todo.columnId} = ?', whereArgs: [todo.id]);
  }
}
