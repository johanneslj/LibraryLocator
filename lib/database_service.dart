import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_locator/review_card.dart';

class DatabaseService {
  final database = FirebaseDatabase.instance.reference();
  List<Widget> reviewList = <Widget>[];

  Future<List<Widget>> setReviews() async {
    final reviews = database.child("books/12345/reviews/");
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    await reviews.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) {
        // Here key is the reviewers Name/ID and the value consists of the star rating and text in the review
        List<String> listOfReviewContent =
            value.toString().replaceAll("}", "").split(",");
        String reviewText =
            listOfReviewContent.elementAt(1).split("text: ").elementAt(1);
        double reviewStars = double.parse(
            listOfReviewContent.elementAt(0).split("stars: ").elementAt(1));
        reviewList.add(new ReviewCard(
            stars: reviewStars, reviewText: reviewText, username: key));
      });
    });
    return reviewList;
  }

}
