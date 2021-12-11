import 'package:flutter/material.dart';

import '../services/database_service.dart';
import 'package:flutter/cupertino.dart';

import '../views/loadingScreenView.dart';

class ReviewList extends StatefulWidget {
  final String isbn;

  ReviewList({Key? key, required this.isbn}) : super(key: key);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  final DatabaseService dbService = new DatabaseService();
  final List<Widget> list = <Widget>[];

  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: dbService.getAllReviewsForBook(widget.isbn),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LoadingScreen(fontSize: 20,));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            snapshot.data!.forEach((element) {
              list.add(element);
            });
          return Center(child: new Column(children: list));
        }
      },
    );
  }

  void initState() {
    super.initState();
  }
}
