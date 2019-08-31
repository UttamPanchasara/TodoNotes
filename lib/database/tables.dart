import 'data/Todo.dart';

class Tables {
  static const String CREATE_TABLE_TODO = "CREATE TABLE IF NOT EXISTS " +
      Todo.TABLE_NAME +
      " (" +
      Todo.columnId +
      " INTEGER PRIMARY KEY AUTOINCREMENT, " +
      Todo.columnTitle +
      " TEXT, " +
      Todo.columnDescription +
      " TEXT, " +
      Todo.columnCreatedAt +
      " TEXT, " +
      Todo.columnColor +
      " TEXT " +
      ")";
}
