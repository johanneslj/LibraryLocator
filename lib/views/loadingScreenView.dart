import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatefulWidget {
  final double fontSize;

  LoadingScreen({Key? key, required this.fontSize}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        children: [
          Text(
            "Please wait, it's loading...",
            style: TextStyle(fontSize: widget.fontSize, color: Colors.white70, decoration: TextDecoration.none),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
          Padding(padding: EdgeInsets.only(top: 10), child: CircularProgressIndicator(color: Colors.blue))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )),
    );
  }
}
