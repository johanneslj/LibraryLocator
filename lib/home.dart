import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_locator/profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'book_details_view.dart';
import 'database_service.dart';
import 'login_view.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconButton signInAndOutButton(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            setState(() => null);
          });
    } else {
      return IconButton(
          icon: Icon(Icons.login),
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailsView(isbn: "12345")));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Widget>> futureBookCards = DatabaseService().getAllBooks();
    List<Widget> bookCards = <Widget>[];

    futureBookCards.then((books) => bookCards = books);

    return Scaffold(
        body: Column(children: [
      Text("Books", style: TextStyle(fontSize: 20)),
      Container(
          height: 255,
          padding: EdgeInsets.only(left: 4, right: 4),
          child: FutureBuilder(
              // Displays books when done
              future: futureBookCards,
              builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Please wait its loading...'));
                } else {
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else
                    bookCards = snapshot.data!;
                  return ListView(children: bookCards);
                }
              })),
    ]));
  }
}
