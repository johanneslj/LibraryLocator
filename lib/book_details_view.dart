import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:library_locator/review_list.dart';

import 'database_service.dart';

class BookDetailsView extends StatefulWidget {
  BookDetailsView({Key? key, required this.isbn}) : super(key: key);
  final String isbn;

  @override
  _BookDetailsViewState createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView> {
  final DatabaseService dbService = new DatabaseService();
  double averageRating = 0;

  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: dbService.getAverageRating(widget.isbn),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              averageRating = snapshot.data!;
              return Scaffold(
                appBar: AppBar(
                  title: Text('Book view'),
                ),
                body: Center(
                  child: ListView(
                    children: [
                      Image(
                          image: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                          height: 300),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Column(children: [
                            Text("Title of Book",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                            RatingBar.builder(
                              initialRating: averageRating,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              itemSize: 10,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.black,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ])),
                      ReviewList(isbn: widget.isbn),
                    ],
                  ),
                ),
              );
          }
        });
  }

  void initState() {
    super.initState();
  }
}
