import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_locator/review_list.dart';

import 'database_service.dart';

class BookDetailsView extends StatelessWidget {
  DatabaseService dbService = new DatabaseService();

  Widget build(BuildContext context) {
    dbService.setReviews();
    return Scaffold(
        appBar: AppBar(
          title: Text('Book view'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    height: 300
                ),
                ReviewList(),
              ],
            ),
          ),
        ));
  }

}