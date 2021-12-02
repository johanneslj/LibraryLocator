import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "Please wait, it's loading...",
        style: TextStyle(fontSize: 30, color: Colors.black),
        textAlign: TextAlign.center,
      )),
    );
  }
}
