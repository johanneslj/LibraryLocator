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
          return Center(child: makeListView(list));
        }
      },
    );
  }

  Column makeListView(List<Widget> bookCards) {
    return Column(
      children: [
        for (var card in bookCards) Column(children: [
          card,
          if(!(bookCards.indexOf(card) == bookCards.length - 1)) // Check if the card is the last element in the view, if it is
          // then don't add a divider at the bottom.
            Divider(),
        ]),
      ],
    );
  }

  void initState() {
    super.initState();
  }
}
