import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_locator/loan_model.dart';
import 'package:library_locator/review_card.dart';
import 'book_card.dart';
import 'loan_model.dart';

class DatabaseService {
  final firebaseDatabase = FirebaseDatabase.instance.reference();
  List<Widget> reviewList = <Widget>[];

  /// Get all the reviews for a book on the given isbn number
  Future<List<Widget>> getAllReviewsForBook(String isbn) async {
    final reviews = firebaseDatabase.child("books/" + isbn + "/reviews/");
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    await reviews.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) {
        // Here key is the reviewers Name/ID and the value consists of the star rating and text in the review
        List<String> listOfReviewContent = value.toString().replaceAll("}", "").split(",");
        String reviewText = listOfReviewContent.elementAt(1).split("text: ").elementAt(1);
        double reviewStars = double.parse(listOfReviewContent.elementAt(0).split("stars: ").elementAt(1));
        reviewList.add(new ReviewCard(stars: reviewStars, reviewText: reviewText, username: key.split("@")[0]));
      });
    });
    return reviewList;
  }

  /// Uses the ISBN to find the availability of the book
  /// at the different libraries
  Future<Map<String, String>> getAvailability(String isbn) async {
    final reviews = firebaseDatabase.child("books/" + isbn + "/availability/");
    Map<String, String> availability = new Map<String, String>();
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    await reviews.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) {
        String numberAvailable = value.toString();
        availability.putIfAbsent(key, () => numberAvailable);
      });
    });
    return availability;
  }

  /// Uses ISBN to find the average rating of that book
 Future<double> getAverageRating(String isbn) async {
    double averageRating = 0;
    final reviews = firebaseDatabase.child("books/"+ isbn +"/reviews/");
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    await reviews.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      double totalRating = 0;
      data.forEach((key, value) {
        List<String> listOfReviewContent = value.toString().replaceAll("}", "").split(",");
        double reviewStars = double.parse(listOfReviewContent.elementAt(0).split("stars: ").elementAt(1));
        totalRating += reviewStars;
      });
      averageRating = totalRating/data.length;
    });

    return averageRating;
 }

  /// Get the loans given by a user
  /// It gets the loan from the database on the users email
  Future<List<LoanModel>> getLoans(String email) async {
    List<LoanModel> loanList = <LoanModel>[];

    final loans = firebaseDatabase.child("users/" + email.replaceAll(".", " ") + "/loans");

    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    Map<dynamic, dynamic> loanDates;

    await loans.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) {
        loanDates = new Map<dynamic, dynamic>.from(value);
        loanList.add(new LoanModel(email, key.toString(), loanDates["from"], loanDates["to"]));
      });
    });

    return loanList;
  }

  /// Gets the reviews made by a user
  /// Uses the email to get them from the database
  Future<List<Widget>> getReviewsByUser(String email) async {
    List<Widget> reviewCards = <Widget>[];

    final reviews = firebaseDatabase.child("users/" + email.replaceAll(".", " ") + "/reviews");

    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    Map<dynamic, dynamic> reviewContent;

    await reviews.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) {
        reviewContent = new Map<dynamic, dynamic>.from(value);

        String reviewText = reviewContent["text"];
        double reviewStars = double.parse(reviewContent["stars"].toString());

        reviewCards.add(new ReviewCard(
            stars: reviewStars, reviewText: reviewText, username: key));
      });
    });

    return reviewCards;
  }

  /// Adds a review from a user to the database
  void addReview(String isbn, double rating, String reviewText) {
    String name = FirebaseAuth.instance.currentUser!.email.toString().replaceAll(".", " ");

    final reviews = firebaseDatabase.child("books/" + isbn + "/reviews/" + name);
    final reviewsUser = firebaseDatabase.child("users/" + name + "/reviews/" + isbn);
    reviews.set({"stars": rating, "text": reviewText}).catchError((error) => print("OOps"));
    reviewsUser.set({"stars": rating, "text": reviewText}).catchError((error) => print("OOps"));
  }

  /// Loans a book to a user if the book is available
  /// this is registered in the database
  void loanBook(String isbn, String selected) {
    String name = FirebaseAuth.instance.currentUser!.email.toString().replaceAll(".", " ");

    String selectedLibrary = selected.split(" ")[0];
    int currentlyAvailable = int.parse(selected.split("Tilgjengelig: ")[1]) - 1;
    final availability = firebaseDatabase.child("books/" + isbn + "/availability/" + selectedLibrary);
    availability.set(currentlyAvailable);

    final userLoan = firebaseDatabase.child("users/" + name + "/loans/" + isbn);
    DateTime now = new DateTime.now();
    DateTime from = new DateTime(now.year, now.month, now.day);
    DateTime to = new DateTime(now.year, now.month, now.day + 30);
    String fromString = "" + from.year.toString() + "-" + from.month.toString() + "-" + from.day.toString();
    String toString = "" + to.year.toString() + "-" + to.month.toString() + "-" + to.day.toString();
    userLoan.set({"from": fromString, "to": toString}).catchError((error) => print(error));
  }

  Future<List<Widget>> getAllBooks() async {
    List<Widget> bookList = <BookCard>[];

    final books = firebaseDatabase.child("books/");
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};

    await books.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) {

        Future<double> averageRating = getAverageRating(key);

        bookList.add(new BookCard(stars: averageRating, imageURL: "", author: "Hans", title: "How to ski", isbn: key,));
      });
    });

    return bookList;
  }

}
