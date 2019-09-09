import 'package:flutter/material.dart';
import 'package:todo/base/base_view.dart';
import 'package:todo/database/app_database_info.dart';
import 'package:todo/database/db_helper.dart';
import 'package:todo/ui/dashboard/Dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Oswald',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements BaseView {
  @override
  void initState() {
    super.initState();
    DBHelper.dbHelper.openDB(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void createTables() {
    DBHelper.dbHelper.init(AppDatabaseInfo()).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    }).catchError((error) {
      print('error while creating tables: ' + error.toString());
    });
  }

  @override
  void onDBCreated() {
    createTables();
  }

  @override
  void onError(String message) {
  }
}
