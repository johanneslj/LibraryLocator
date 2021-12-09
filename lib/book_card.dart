import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'book_details_view.dart';
import 'loadingScreenView.dart';

class BookCard extends StatefulWidget {
  final String isbn;
  final String imageURL;
  final Future<double> stars;
  final String title;
  final String author;

  const BookCard({Key? key, required this.isbn, required this.imageURL, required this.stars, required this.title, required this.author})
      : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  Widget build(BuildContext context) {
    double averageRating = 0;
    return FutureBuilder<double>(
        future: widget.stars,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingScreen(fontSize: 30));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              averageRating = snapshot.data!;
            return InkWell(
              onTap: () {
                pushToDetails(widget.isbn);
              },
              child: Row(
                children: [
                  Expanded(
                  child: Container(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                        child: Container(
                            child: Row(children: [
                              Image(image: NetworkImage(widget.imageURL), height: 90),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Column(
                                  children: [
                                    Text(widget.title, textAlign: TextAlign.left, style: TextStyle(fontSize: 22)),
                                    Text(widget.author, overflow: TextOverflow.visible, style: TextStyle(fontSize: 22)),
                                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text("(" + averageRating.toString().substring(0, 3) + ")", style: TextStyle(fontSize: 16)),
                                      RatingBarIndicator(
                                        rating: averageRating,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20,
                                      ),
                                    ]),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                ),
                              ),
                            ]))),
                  ),
                )],
              ),
            );
          }
        });
  }

  void pushToDetails(String isbn) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailsView(isbn: isbn)));
  }

  void initState() {
    super.initState();
  }
}
