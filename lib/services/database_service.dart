import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_locator/reviews/loan_card.dart';
import 'package:library_locator/user/loan_model.dart';
import 'package:library_locator/reviews/review_card.dart';
import '../reviews/book_card.dart';
import '../user/loan_model.dart';
import 'package:dio/dio.dart';

class DatabaseService {
  final firebaseDatabase = FirebaseDatabase.instance.reference();
  final Apiurl = 'http://mobilelibraryapi.azurewebsites.net';
  final Dio dio = new Dio();
  final defaultImage = "https://bit.ly/3DxOC5k";

  List<Widget> reviewList = <Widget>[];

  /// Get all the reviews for a book on the given isbn number
  Future<List<Widget>> getAllReviewsForBook(String isbn) async {
    final reviews = firebaseDatabase.child("books/" + isbn + "/reviews/");
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    await reviews.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        data = new Map<dynamic, dynamic>.from(snapshot.value);
        data.forEach((key, value) {
          // Here key is the reviewers Name/ID and the value consists of the star rating and text in the review
          List<String> listOfReviewContent = value.toString().replaceAll(
              "}", "").split(",");
          String reviewText = listOfReviewContent.elementAt(1)
              .split("text: ")
              .elementAt(1);
          double reviewStars = double.parse(
              listOfReviewContent.elementAt(0).split("stars: ").elementAt(1));
          reviewList.add(new ReviewCard(stars: reviewStars,
              reviewText: reviewText,
              username: key.split("@")[0]));
        });
      }
    });
    return reviewList;
  }

//Gets all books from the custom backend server.
  Future<List<Widget>> getBooks() async {
    var response = await dio.get(Apiurl + "/getAllBooks");

    List<Widget> bookList = <BookCard>[];

    response.data.forEach((key, value) {
      Future<double> averageRating = getAverageRating(key);
      String imageURL = "";
      String title = "";
      String author = "";
      String summary = "";

      value.forEach((key, value) async {
        if (key == "image") {
          if (value
              .toString()
              .isEmpty) {
            imageURL = defaultImage;
          } else {
            imageURL = value.toString();
          }
        }
        if (key == "title") {
          title = value.toString();
        }
        if (key == "author") {
          author = value.toString();
        }
        if (key == "summary") {
          summary = value.toString();
        }
      });

      bookList.add(new BookCard(
          stars: averageRating,
          imageURL: imageURL,
          author: author,
          title: title,
          isbn: key,
          summary: summary));
    });

    return bookList;
  }

  //Gets all books based on ether if the ISBN, Title or author from the user matches the  the book
  Future<List<Widget>> search(String query) async {
    var response = await dio.get(Apiurl + "/search=" + query);

    List<Widget> bookList = <BookCard>[];

    response.data.forEach((key, value) {
      Future<double> averageRating = getAverageRating(key);
      String imageURL = "";
      String title = "";
      String author = "";
      String summary = "";

      value.forEach((key, value) async {
        if (key == "image") {
          if (value
              .toString()
              .isEmpty) {
            imageURL = defaultImage;
          }
          else {
            imageURL = value.toString();
          }
        }
        if (key == "title") {
          title = value.toString();
        }
        if (key == "author") {
          author = value.toString();
        }
        if (key == "summary") {
          summary = value.toString();
        }
      });

      bookList.add(new BookCard(
          stars: averageRating,
          imageURL: imageURL,
          author: author,
          title: title,
          isbn: key,
          summary: summary));
    });

    return bookList;
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
    final reviews = firebaseDatabase.child("books/" + isbn + "/reviews/");
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};

    await reviews.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        data = new Map<dynamic, dynamic>.from((snapshot.value));

        double totalRating = 0;

        data.forEach((key, value) {
          List<String> listOfReviewContent = value.toString().replaceAll(
              "}", "").split(",");
          double reviewStars = double.parse(
              listOfReviewContent.elementAt(0).split("stars: ").elementAt(1));
          totalRating += reviewStars;
        });

        if (data.length > 0) {
          averageRating = totalRating / data.length;
        }
      } else {
        averageRating = 0;
      }
    });

    return averageRating;
  }

  /// Get the loans given by a user
  /// It gets the loan from the database on the users email
  Future<List<Widget>> getLoans(String email) async {
    List<LoanCard> loanList = <LoanCard>[];


    final loans = firebaseDatabase.child(
        "users/" + email.replaceAll(".", " ") + "/loans");


    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    Map<dynamic, dynamic> innerData;

    await loans.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) {

        innerData = new Map<dynamic, dynamic>.from(value);
        String title = "Title"; // TODO Get title with ISBN from backend here!

        String imageURL = "";
        loanList.add(new LoanCard(
          imageURL: '',
          from: createDateFromString(innerData["from"]),
          to: createDateFromString(innerData["to"]),
          title: title,
          email: email,
          isbn: key,
          delivered: innerData["delivered"],
          location: innerData["location"],
        ));
      });
    });

    loanList.sort((LoanCard a, LoanCard b) =>
    -a.from
        .difference(b.from)
        .inHours);

    return loanList;
  }

  void deliverBook(String email, String isbn, String location) async {
    final userLoans = firebaseDatabase.child(
        "users/" + email.replaceAll(".", " ") + "/loans/" + isbn);
    DateTime now = DateTime.now();
    DateTime deliveredDate = new DateTime(now.year, now.month, now.day);
    String deliveredDateString = "" + deliveredDate.year.toString() + "-" +
        deliveredDate.month.toString() + "-" + deliveredDate.day.toString();
    userLoans.update({"delivered": true, "to": deliveredDateString});

    final availability = firebaseDatabase.child(
        "books/" + isbn + "/availability/" + location);
    int available = 0;
    await availability.get().then((DataSnapshot dataSnapshot) =>
    {
      available = dataSnapshot.value
    });
    availability.set(available + 1);
  }

  DateTime createDateFromString(String dateString) {
    List<String> dayMonthYear = dateString.split("-");
    int year = int.parse(dayMonthYear[0]);
    int month = int.parse(dayMonthYear[1]);
    int day = int.parse(dayMonthYear[2]);
    DateTime date = new DateTime(year, month, day);
    return date;
  }

  /// Gets the reviews made by a user
  /// Uses the email to get them from the database
  Future<List<Widget>> getReviewsByUser(String email) async {
    List<Widget> reviewCards = <Widget>[];

    final reviews = firebaseDatabase.child(
        "users/" + email.replaceAll(".", " ") + "/reviews");

    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    Map<dynamic, dynamic> reviewContent;

    await reviews.get().then((DataSnapshot snapshot) {
      data = new Map<dynamic, dynamic>.from(snapshot.value);
      data.forEach((key, value) async {
        reviewContent = new Map<dynamic, dynamic>.from(value);

        String reviewText = reviewContent["text"].toString();
        double reviewStars = double.parse(reviewContent["stars"].toString());
        String title = (reviewContent["title"] != null)
            ? reviewContent["title"]
            : "N/A";

        reviewCards.add(new ReviewCard(
            stars: reviewStars, reviewText: reviewText, username: title));
      });
    });

    return reviewCards;
  }

  /// Adds a review from a user to the database
  void addReview(String isbn, double rating, String reviewText, String title) {
    String name = FirebaseAuth.instance.currentUser!.email.toString()
        .replaceAll(".", " ");

    final reviews = firebaseDatabase.child(
        "books/" + isbn + "/reviews/" + name);
    final reviewsUser = firebaseDatabase.child(
        "users/" + name + "/reviews/" + isbn);
    reviews.update({"stars": rating, "text": reviewText, "title": title})
        .catchError((error) => print("OOps"));
    reviewsUser.update({"stars": rating, "text": reviewText, "title": title})
        .catchError((error) => print("OOps"));
  }

  /// Loans a book to a user if the book is available
  /// this is registered in the database
  void loanBook(String isbn, String selected) {
    String name = FirebaseAuth.instance.currentUser!.email.toString()
        .replaceAll(".", " ");

    String selectedLibrary = selected.split(" ")[0];
    int currentlyAvailable = int.parse(selected.split("Available: ")[1]) - 1;
    final availability = firebaseDatabase.child(
        "books/" + isbn + "/availability/" + selectedLibrary);
    availability.set(currentlyAvailable);

    final userLoan = firebaseDatabase.child("users/" + name + "/loans/" + isbn);
    DateTime now = new DateTime.now();
    DateTime from = new DateTime(now.year, now.month, now.day);
    DateTime to = new DateTime(now.year, now.month, now.day + 30);
    String fromString = "" + from.year.toString() + "-" +
        from.month.toString() + "-" + from.day.toString();
    String toString = "" + to.year.toString() + "-" + to.month.toString() +
        "-" + to.day.toString();
    userLoan.set({
      "from": fromString,
      "to": toString,
      "delivered": false,
      "location": selectedLibrary
    }).catchError((error) => print(error));
  }


  Future<String> getBookDetails(String isbn) async{
    var response = await dio.get(Apiurl + "/search=" + isbn);

    List<Widget> bookList = <BookCard>[];
    String imageURL = "";
    String title = "";
    String author = "";
    String summary = "";
    response.data.forEach((key, value) {
      Future<double> averageRating = getAverageRating(key);


      value.forEach((key, value) async {
        if (key == "image") {
          if (value
              .toString()
              .isEmpty) {
            imageURL = defaultImage;
          }
          else {
            imageURL = value.toString();
          }
        }
        if (key == "title") {
          title = value.toString();
        }
        if (key == "author") {
          author = value.toString();
        }
        if (key == "summary") {
          summary = value.toString();
        }
      });

      bookList.add(new BookCard(
          stars: averageRating,
          imageURL: imageURL,
          author: author,
          title: title,
          isbn: key,
          summary: summary));
    });

    return title + ";" + imageURL;
  }
}
