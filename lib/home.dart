import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_locator/profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'book_details_view.dart';
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BookDetailsView(isbn: "12345")));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final List<int> colorCodes = <int>[600, 500, 100];
    return Scaffold(

        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              while (colorCodes.length < entries.length) {
                colorCodes.add(colorCodes[0]);
              }
              return Container(
                height: 50,
                padding: EdgeInsets.only(bottom: 3),
                child: ElevatedButton(
                  child: Text(entries[index]),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage()),
                    );
                  },
                ),
              );
            }));
  }
}
