import 'package:flutter/material.dart';
import 'package:todo/ui/todo/AddTodoView.dart';

class PasswordDialog extends StatefulWidget {
  final AddTodoView view;

  const PasswordDialog({Key key, this.view}) : super(key: key);

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errorMessage = "";

  var _focusNodePassword = FocusNode();
  var _focusNodeConfirmPassword = FocusNode();

  bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Protect with password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Oswald_Bold',
          )),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: TextFormField(
                obscureText: passwordVisible,
                controller: _passwordController,
                maxLines: null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                focusNode: _focusNodePassword,
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
                onFieldSubmitted: (v) {
                  FocusScope.of(context)
                      .requestFocus(_focusNodeConfirmPassword);
                },
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Oswald_Regular',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 15),
              child: TextFormField(
                obscureText: true,
                controller: _confirmPasswordController,
                maxLines: null,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                focusNode: _focusNodeConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Confirm Password..",
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Oswald_Regular'),
                  border: UnderlineInputBorder(),
                ),
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Oswald_Regular',
                ),
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
          child: new Text('PROTECT',
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

            if (_passwordController.text.length > 12 ||
                _passwordController.text.length < 6) {
              setState(() {
                errorMessage = "Password length must be 6-12 characters";
              });
              return;
            }

            if (_confirmPasswordController.text.isEmpty) {
              setState(() {
                errorMessage = "Please provide non-empty Confirm Password";
              });
              return;
            }
            if (_passwordController.text != _confirmPasswordController.text) {
              setState(() {
                errorMessage = "Password & Confirm Password must be same.";
              });
              return;
            }

            Navigator.of(context).pop();
            widget.view.onPasswordValidate(_passwordController.text);
          },
        )
      ],
    );
  }
}
