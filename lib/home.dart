import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main.dart';

class Home extends StatelessWidget {
  //const Home({Key? key}) : super(key: key);
  final database = FirebaseDatabase.instance.reference();

  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final List<int> colorCodes = <int>[600, 500, 100];
    Firebase.initializeApp();

    final reviews = database.child("books/12345/reviews/");

/*
    ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          while(colorCodes.length < entries.length){
            colorCodes.add(colorCodes[0]);
          }
          return Container(
            height: 50,
            color: Colors.amber[colorCodes[index]],
            child: ElevatedButton(
              child: Text(entries[index]),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'cool')),
                );
// Navigate to second route when tapped.
              },
            ),
          );
        })

 */
    return Scaffold(
        appBar: AppBar(
          title: Text('Write test'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      reviews.update(
                          {"Jens/text": "Innafor det her", "Jens/stars": 2});
                    },
                    child: Text('Add review')),
                ElevatedButton(
                    onPressed: () {
                      reviews.child("Jens").remove();
                    },
                    child: Text('Remove review'))
              ],
            ),
          ),
        ));
  }
}
