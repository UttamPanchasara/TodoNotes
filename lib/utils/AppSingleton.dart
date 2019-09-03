import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSingleton {
  AppSingleton._privateConstructor();

  static final AppSingleton instance = AppSingleton._privateConstructor();

  void showMessage(String message, Color color, GlobalKey<ScaffoldState> key) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    key.currentState.showSnackBar(snackBar);
  }
}
