import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_locator/review_card.dart';

class DatabaseService {
  final firebaseDatabase = FirebaseDatabase.instance.reference();
  List<Widget> reviewList = <Widget>[];

  /// Get all the reviews for a book on the given isbn number
  Future<List<Widget>> getAllReviewsForBook(String isbn) async {
    final reviews = firebaseDatabase.child("books/"+ isbn +"/reviews/");
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


  Future<double> getAverageRating(String isbn) async {
    double averageRating = 0;
    final reviews = firebaseDatabase.child("books/"+ isbn +"/reviews/");
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    await reviews.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      double totalRating = 0;
      data.forEach((key, value) {
        // Here key is the reviewers Name/ID and the value consists of the star rating and text in the review
        List<String> listOfReviewContent = value.toString().replaceAll("}", "").split(",");
        double reviewStars = double.parse(listOfReviewContent.elementAt(0).split("stars: ").elementAt(1));
        totalRating += reviewStars;
      });
      averageRating = totalRating/data.length;
    });

    return averageRating;
  }
}