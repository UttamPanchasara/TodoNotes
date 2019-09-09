import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/data/Todo.dart';
import 'package:todo/ui/todo/AddTodoModel.dart';
import 'package:todo/ui/todo/AddTodoView.dart';
import 'package:todo/ui/todo/PasswordDialog.dart';
import 'package:todo/utils/AppSingleton.dart';

class AddTodo extends StatefulWidget {
  AddTodo({Key key, this.todoId}) : super(key: key);

  final int todoId;

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> implements AddTodoView {
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
  AddTodoModel _model;

  void initState() {
    super.initState();
    _todo = null;
    _model = AddTodoModel(this);

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => onWidgetBuild());
    }
  }

  void onWidgetBuild() {
    if (widget.todoId != 0) {
      _model.getTodo(widget.todoId);
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
              _model.addTodo(
                  _titleController.text,
                  _descriptionController.text,
                  colorsList[selectedColorIndex].value,
                  widget.todoId,
                  _todo == null ? "" : _todo.password);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.done,
                color: selectedColor,
              ),
            ),
          ),
          _deleteOption(),
          _lockOption(context),
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

  Widget _deleteOption() {
    if (_todo == null) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          _model.deleteTodo(widget.todoId);
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

  Widget _lockOption(BuildContext context) {
    if (_todo == null) {
      return Container();
    } else {
      return GestureDetector(
        onTap: () {
          if (_todo.password != null && _todo.password.isNotEmpty) {
            showDialog(
                context: context,
                builder: (context) {
                  return _showRemoveProtectedAlert();
                });
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return PasswordDialog(view: this);
                });
          }
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Icon(
            _todo != null && _todo.password != null && _todo.password.isNotEmpty
                ? Icons.lock_open
                : Icons.lock_outline,
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

  _showRemoveProtectedAlert() {
    return AlertDialog(
      title: Text('Remove Protection?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Oswald_Bold',
          )),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'Oswald_Regular',
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: new Text('CANCEL',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Oswald_Bold',
              )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: new Text('UN-PROTECT',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Oswald_Bold',
              )),
          onPressed: () {
            Navigator.of(context).pop();
            _model.removePassword(_todo.id);
          },
        )
      ],
    );
  }

  @override
  void onTodoUpdated(String message) {
    Navigator.pop(context, message);
  }

  @override
  void onDBCreated() {
    // DO nothing
  }

  @override
  void onError(String message) {
    AppSingleton.instance.showMessage(message, Colors.red, _scaffoldKey);
  }

  @override
  void onTodoAvailable(Todo todo) {
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
  }

  @override
  void onPasswordValidate(String password) {
    _model.addPassword(_todo, password);
  }
}
