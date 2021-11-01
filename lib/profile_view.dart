import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_locator/database_service.dart';
import 'package:library_locator/login_view.dart';
import 'package:library_locator/main.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Column reviewsColumn(BuildContext context) {


    return Column();
  }



  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      // When the user is not logged in return this
      return Scaffold(
        appBar: AppBar(
          title: Text("My profile"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Please sign in to view your profile.", style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text("Sign In"),
            )
          ]
        )
      );
    } else { // When the user is logged in return this
      return Scaffold(
        appBar: AppBar(
          title: Text("My profile"),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text(
                  FirebaseAuth.instance.currentUser!.email.toString().split("@")[0],
                  style: TextStyle(fontSize: 28),
              )
            ),
            Text("Loan history:", style: TextStyle(fontSize: 20)),
            SingleChildScrollView(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(

                  );
                },
              )
            )
          ],
        )
      );
    }
  }
}