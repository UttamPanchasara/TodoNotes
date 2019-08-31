import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo/base/base_view.dart';

import 'app_database_info.dart';
import 'db_info.dart';

class DBHelper {
  static const String DB_VERSION = "db_version";

  DBInfo dbInfo;

  Database _db;

  DBHelper._privateConstructor();

  static final DBHelper dbHelper = DBHelper._privateConstructor();

  Database getDatabase() {
    return _db;
  }

  Future<bool> init(DBInfo dbInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int oldVersion = await prefs.get(DB_VERSION) ?? 0;

    if (AppDatabaseInfo.DATABASE_VERSION > oldVersion) {
      await prefs.setInt(DB_VERSION, AppDatabaseInfo.DATABASE_VERSION);

      // upgrade db on version increased
      return dbInfo.getMigrationTask().onUpgrade(
          getDatabase(), oldVersion, AppDatabaseInfo.DATABASE_VERSION);
    } else {
      print('No change in db');
      return true;
    }
  }

  Future openDB(BaseView baseView) async {
    Directory userDirectory = await getApplicationDocumentsDirectory();
    String path = join(userDirectory.path, AppDatabaseInfo.DATABASE_NAME);

    await openDatabase(path, version: AppDatabaseInfo.DATABASE_VERSION)
        .then((db) {
      _db = db;

      print('db open.');
      baseView.onDBCreated();
    }).catchError((error) {
      print('Error while tring to open db: ' + error.toString());
    });
  }

  Future close() async => _db.close();
}
