import 'package:sqflite/sqflite.dart';
import 'package:todo/database/tables.dart';

import 'data/Todo.dart';
import 'db_info.dart';
import 'imigration_task.dart';

class AppDatabaseInfo implements DBInfo, IMigrationTask {
  static const String DATABASE_NAME = "db_expends.db";
  static const int DATABASE_VERSION = 1;

  @override
  String getDatabaseName() {
    return DATABASE_NAME;
  }

  @override
  int getDatabaseVersion() {
    return DATABASE_VERSION;
  }

  @override
  List<String> getTableCreationQueries() {
    return _generateCreationQueryList();
  }

  @override
  List<String> getTableNameList() {
    List<String> dbTableNameList = [];
    dbTableNameList.add(Todo.TABLE_NAME);
    return dbTableNameList;
  }

  @override
  Future<bool> onUpgrade(Database theDb, int oldVersion, int newVersion) async {
    List<String> dbDropList = _generateDropQueryList();
    List<String> dbSchemaQueryList = _generateCreationQueryList();

    for (var i = 0; i < dbDropList.length; i++) {
      theDb.execute(dbDropList[i]);
    }
    print('table deleted');

    for (var i = 0; i < dbSchemaQueryList.length; i++) {
      theDb.execute(dbSchemaQueryList[i]);
    }
    print('new tables created');

    return true;
  }

  List<String> _generateDropQueryList() {
    List<String> dbDropList = [];

    for (var i = 0; i < getTableNameList().length; i++) {
      String query = "DROP TABLE IF EXISTS " + getTableNameList()[i];
      dbDropList.add(query);
    }

    return dbDropList;
  }

  List<String> _generateCreationQueryList() {
    List<String> dbSchemaQueryList = [];
    dbSchemaQueryList.add(Tables.CREATE_TABLE_TODO);
    return dbSchemaQueryList;
  }

  @override
  IMigrationTask getMigrationTask() {
    return this;
  }
}
