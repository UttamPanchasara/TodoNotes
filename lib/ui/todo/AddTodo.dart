import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/data/Todo.dart';
import 'package:todo/database/data/TodoProvider.dart';
import 'package:todo/utils/AppSingleton.dart';

class AddTodo extends StatefulWidget {
  AddTodo({Key key, this.todoId}) : super(key: key);

  final int todoId;

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  var selectedColorIndex = 0;

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

  Color selectedColor = Colors.grey;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _descriptionFocusNode = FocusNode();

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
        selectedColor = Color(_todo.color);
        _titleController.text = _todo.title;
        _descriptionController.text = _todo.description;

        for (var i = 0; i < colorsList.length; i++) {
          if (colorsList[i].value == _todo.color) {
            selectedColorIndex = i;
            break;
          }
        }

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
          color: selectedColor,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _addTodo(_titleController.text, _descriptionController.text,
                  colorsList[selectedColorIndex].value);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.done,
                color: selectedColor,
              ),
            ),
          ),
          deleteOption()
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
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Title",
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 16),
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 15),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: selectedColor, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: selectedColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: selectedColor, width: 1.5),
                        ),
                      ),
                      cursorColor: Colors.black,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Oswald_Regular',
                      ),
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
                      textCapitalization: TextCapitalization.sentences,
                      focusNode: _descriptionFocusNode,
                      decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 16),
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 15),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: selectedColor, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: selectedColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: selectedColor, width: 1.5),
                        ),
                      ),
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Oswald_Regular',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _showEditedDate(),
          colorsListWidget()
        ],
      ),
    );
  }

  Widget _showEditedDate() {
    if (_todo == null) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Text(
          "Edited " +
              DateFormat('dd-MMM-yyyy, hh:mm:aa').format(
                DateTime.fromMillisecondsSinceEpoch(_todo.createdAt),
              ),
          textAlign: TextAlign.end,
          style: TextStyle(
              color: selectedColor, fontFamily: 'Oswald_Regular', fontSize: 12),
        ),
      );
    }
  }

  Widget deleteOption() {
    if (widget.todoId == 0) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          _deleteTodo();
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Icon(
            Icons.delete_outline,
            color: selectedColor,
          ),
        ),
      );
    }
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
              selectedColor = colorsList[index];
              selectedColorIndex = index;
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
    if (index == selectedColorIndex) {
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

  void _addTodo(String title, String description, int color) {
    if (_descriptionController.text.isEmpty) {
      AppSingleton.instance
          .showMessage("Please provide description", Colors.red, _scaffoldKey);
      return;
    }

    if (_todoProvider != null) {
      if (widget.todoId == 0) {
        _todoProvider
            .insert(Todo(
          title: title,
          description: description,
          color: color,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ))
            .then(
          (value) {
            _resetFields();
            Navigator.pop(context, "Note was created successfully.");
          },
        ).catchError(
          (error) {
            print('error while inserting todo: ' + error.toString());
            AppSingleton.instance.showMessage(
                "Something wrong, please try again.", Colors.red, _scaffoldKey);
          },
        );
      } else {
        _todoProvider
            .update(Todo(
          id: widget.todoId,
          title: title,
          description: description,
          color: color,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ))
            .then(
          (value) {
            _resetFields();
            Navigator.pop(context, "Note was updated successfully.");
          },
        ).catchError(
          (error) {
            print('error while inserting todo: ' + error.toString());
            AppSingleton.instance.showMessage(
                "Something wrong, please try again.", Colors.red, _scaffoldKey);
          },
        );
      }
    }
  }

  void _deleteTodo() {
    if (_todoProvider != null) {
      if (widget.todoId > 0) {
        _todoProvider.delete(widget.todoId).then(
          (value) {
            _resetFields();
            Navigator.pop(context, "Note was deleted successfully.");
          },
        ).catchError(
          (error) {
            print('error while deleting todo: ' + error.toString());
            AppSingleton.instance.showMessage(
                "Something wrong, please try again.", Colors.red, _scaffoldKey);
          },
        );
      }
    }
  }

  void _resetFields() {
    _titleController.text = "";
    _descriptionController.text = "";
    selectedColor = Colors.grey;
    selectedColorIndex = colorsList.indexOf(selectedColor);
    setState(() {});
  }
}
