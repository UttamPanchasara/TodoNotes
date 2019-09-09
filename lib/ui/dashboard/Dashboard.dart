import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo/database/data/Todo.dart';
import 'package:todo/database/data/TodoProvider.dart';
import 'package:todo/ui/dashboard/DashboardView.dart';
import 'package:todo/ui/dashboard/PasswordDialog.dart';
import 'package:todo/ui/todo/AddTodo.dart';
import 'package:todo/utils/AppSingleton.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> implements DashboardView {
  TodoProvider _todoProvider = TodoProvider();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: _todoList(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Quick Notes",
          style: TextStyle(color: Colors.black, fontFamily: 'Oswald_Bold'),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _navigateToAddTodo(0);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _todoList() {
    return FutureBuilder(
      future: _todoProvider.getAllTodo(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          print("Error while fetchin months: " + snapshot.error);
          return Center(
            child: Text(
              "You don't have any notes yet, \nPlease add some.",
              style: TextStyle(color: Colors.grey, fontFamily: 'Oswald_Bold'),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return _loadTodo(snapshot.data);
          }
        }
      },
    );
  }

  Widget _loadTodo(List<Todo> data) {
    if (data.length == 0) {
      return Center(
        child: Text(
          "You don't have any notes yet, \nPlease add some.",
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Oswald_Bold',
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(5),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            Todo todo = data[index];
            return InkWell(
              onTap: () {
                if (todo.password != null && todo.password.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PasswordDialog(view: this, todo: todo);
                      });
                } else {
                  _navigateToAddTodo(todo.id);
                }
              },
              child: _noteView(todo),
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
      );
    }
  }

  Widget _noteView(Todo todo) {
    if (todo.password != null && todo.password.isNotEmpty) {
      return Container(
        width: double.maxFinite,
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  todo.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Oswald_Bold',
                      fontSize: 16),
                ),
              ),
            ),
            Container(
              child: Icon(
                Icons.lock_outline,
              ),
              padding: EdgeInsets.all(10),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color(todo.color), width: 2),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            _showTitle(todo),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Text(
                todo.description,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Oswald_Regular',
                    fontSize: 14),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color(todo.color), width: 2),
        ),
      );
    }
  }

  Widget _showTitle(Todo _todo) {
    if (_todo.title.isEmpty) {
      return Container();
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Text(
          _todo.title,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black, fontFamily: 'Oswald_Bold', fontSize: 16),
        ),
      );
    }
  }

  Future _navigateToAddTodo(int todoId) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodo(todoId: todoId)),
    );

    if (result != null) {
      // after the SecondScreen result comes back update the Text widget with it
      AppSingleton.instance.showMessage(result, Colors.green, _scaffoldKey);
    }
  }

  @override
  void onPasswordValidated(int todoId) {
    _navigateToAddTodo(todoId);
  }
}
