import 'package:flutter/material.dart';
import 'package:todo/database/data/Todo.dart';
import 'package:todo/ui/dashboard/DashboardView.dart';
import 'package:todo/ui/todo/AddTodoView.dart';

class PasswordDialog extends StatefulWidget {
  final DashboardView view;
  final Todo todo;

  const PasswordDialog({Key key, this.view, this.todo}) : super(key: key);

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _passwordController = TextEditingController();
  String errorMessage = "";

  bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              obscureText: passwordVisible,
              controller: _passwordController,
              maxLines: null,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Password..",
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Oswald_Regular'),
                border: UnderlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
              cursorColor: Colors.black,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Oswald_Regular',
              ),
            ),
            errorMessage.isEmpty
                ? Container()
                : Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Oswald_Regular',
                      ),
                    ),
                  )
          ],
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
          child: new Text('OPEN',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Oswald_Bold',
              )),
          onPressed: () {
            if (_passwordController.text.isEmpty) {
              setState(() {
                errorMessage = "Please provide non-empty Password";
              });
              return;
            }
            if (_passwordController.text != widget.todo.password) {
              setState(() {
                errorMessage = "Please provide valid Password";
              });
              return;
            }

            Navigator.of(context).pop();
            widget.view.onPasswordValidated(widget.todo.id);
          },
        )
      ],
    );
  }
}
