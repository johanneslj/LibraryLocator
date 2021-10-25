
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_locator/review_card.dart';

class BookDetailsView extends StatelessWidget {
  final database = FirebaseDatabase.instance.reference();

  Widget build(BuildContext context) {
    final reviews = database.child("books/12345/reviews/");

    return Scaffold(
        appBar: AppBar(
          title: Text('Book view'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                Image (
                  image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  height: 300

                ),

                ElevatedButton(
                    onPressed: () {
                      reviews.child("Jens").remove();
                    },
                    child: Text('Remove review')),
                ReviewCard(
                  stars: 3.5,
                  reviewText: "Hello",
                    username:"Bob"
                ),

              ],
            ),
          ),
        ));
  }

}