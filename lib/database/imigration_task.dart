import 'package:sqflite/sqflite.dart';

abstract class IMigrationTask {
  Future<bool> onUpgrade(Database theDb, int oldVersion, int newVersion);
}
