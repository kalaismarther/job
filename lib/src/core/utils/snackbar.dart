import 'package:flutter/material.dart';

class Snackbar {
  static final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> getKey() {
    return _scaffoldKey;
  }

  static void show(String text, color) {
    if (text.isNotEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(text),
          backgroundColor: color,
        ),
      );
    }
  }
}
