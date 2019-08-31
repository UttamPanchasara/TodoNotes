import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo/database/data/TodoProvider.dart';
import 'package:todo/ui/todo/AddTodo.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TodoProvider _todoProvider = TodoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Dashboard"),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodo(todoId: 0)),
              );
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
        if (snapshot.error) {
          return Container();
        } else {
          return StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: snapshot.data,
            itemBuilder: (BuildContext context, int index) => new Container(
                color: Colors.green,
                child: new Center(
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text('$index'),
                  ),
                )),
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index.isEven ? 2 : 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
        }
      },
    );
  }
}
