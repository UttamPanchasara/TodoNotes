import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todo/database/data/Todo.dart';
import 'package:todo/database/data/TodoProvider.dart';

class AddTodo extends StatefulWidget {
  AddTodo({Key key, this.todoId}) : super(key: key);

  final int todoId;

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  List<Color> colorsList = [
    Colors.grey,
    Colors.green,
    Colors.lightGreen,
    Colors.red,
    Colors.redAccent,
    Colors.blue,
    Colors.lightBlue,
    Colors.purple,
    Colors.deepPurple,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.pinkAccent
  ];

  Color _selectedColor = Colors.grey;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _selectedColorIndex = 0;

  var _descriptionFocusNode = FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Todo _todo;
  TodoProvider _todoProvider = TodoProvider();

  void initState() {
    super.initState();
    _todo = null;

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => onWidgetBuild());
    }
  }

  void onWidgetBuild() {
    if (widget.todoId != 0) {
      _todoProvider.getTodo(widget.todoId).then((todo) {
        _todo = todo;
        _selectedColor = Color(int.parse(_todo.color));
        _titleController.text = _todo.title;
        _descriptionController.text = _todo.title;

        _selectedColorIndex = colorsList.indexOf(_selectedColor);

        setState(() {});
      }).catchError((error) {
        _todo = null;
        print('error in reading expend detail: ' + error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: _selectedColor,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _addTodo(_titleController.text, _descriptionController.text,
                  colorsList[_selectedColorIndex].value.toString());
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.done,
                color: _selectedColor,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: TextFormField(
                      controller: _titleController,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "Title",
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 18),
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 15),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _selectedColor, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _selectedColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _selectedColor, width: 1.0),
                        ),
                      ),
                      cursorColor: Colors.black,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      focusNode: _descriptionFocusNode,
                      decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 18),
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 15),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _selectedColor, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _selectedColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: _selectedColor, width: 1.0),
                        ),
                      ),
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
          colorsListWidget()
        ],
      ),
    );
  }

  Widget colorsListWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _selectedColor = colorsList[index];
              _selectedColorIndex = index;
              setState(() {});
            },
            child: colorWidget(index, colorsList[index]),
          );
        },
        itemCount: colorsList.length,
      ),
    );
  }

  Widget colorWidget(int index, Color color) {
    if (index == _selectedColorIndex) {
      return Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              color: colorsList[index],
            ),
            Container(
              height: 40,
              width: 40,
              color: Colors.black12,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(5),
        height: 40,
        width: 40,
        color: colorsList[index],
      );
    }
  }

  void _addTodo(String title, String description, String color) {
    if (_descriptionController.text.isEmpty) {
      _showMessage("Please provide description", Colors.red);
      return;
    }

    if (_todoProvider != null) {
      var todo = Todo(
        title: title,
        description: description,
        color: color,
        createdAt: DateTime.now().toLocal().millisecondsSinceEpoch.toString(),
      );

      if (widget.todoId == 0) {
        _todoProvider.insert(todo).then(
          (value) {
            _resetFields();
            _showMessage("Todo was created successfully.", Colors.green);
          },
        ).catchError(
          (error) {
            print('error while inserting todo: ' + error.toString());
            _showMessage("Something wrong, please try again.", Colors.red);
          },
        );
      } else {
        _todoProvider.update(todo).then(
          (value) {
            _resetFields();
            _showMessage("Todo was updated successfully.", Colors.green);
          },
        ).catchError(
          (error) {
            print('error while inserting todo: ' + error.toString());
            _showMessage("Something wrong, please try again.", Colors.red);
          },
        );
      }
    }
  }

  void _resetFields(){
    _titleController.text = "";
    _descriptionController.text = "";
    _selectedColor = Colors.grey;
    _selectedColorIndex = colorsList.indexOf(_selectedColor);
    setState(() {
    });
  }

  void _showMessage(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
