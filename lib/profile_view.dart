import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:library_locator/database_service.dart';
import 'package:library_locator/home.dart';
import 'package:library_locator/login_view.dart';
import 'package:library_locator/main.dart';
import 'package:library_locator/review_card.dart';

import 'loan_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Widget> loanList(List<LoanModel> loans) {
    List<Widget> loanCards = <Widget>[];

    for (LoanModel loan in loans) {
      loanCards.add(Container(
          child: Row(
        children: [
          Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'), height: 100),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Title: " + loan.title), Text("To: " + loan.to!), Text("From: " + loan.from!)],
          )
        ],
      )));
    }

    return loanCards;
  }

  TextButton signInAndOutButton(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return TextButton.icon(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
        },
        icon: Icon(Icons.logout),
        label: Text("Sign Out"),
      );
    } else {
      return TextButton.icon(
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        icon: Icon(Icons.login),
        label: Text("Log In"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      // When the user is not logged in return this
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Profile'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[signInAndOutButton(context)],
          ),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Text("Please sign in to view your profile.", style: TextStyle(fontSize: 24)),
          ]));
    } else {
      Future<List<LoanModel>> futureLoans = DatabaseService().getLoans(FirebaseAuth.instance.currentUser!.email.toString());
      List<LoanModel> loans = List.empty();

      Future<List<Widget>> futureReviewCards = DatabaseService().getReviewsByUser(FirebaseAuth.instance.currentUser!.email.toString());
      List<Widget> reviewCards = <Widget>[];

      futureLoans.then((value) => loans = value);
      futureReviewCards.then((value) => reviewCards = value);
      // When the user is logged in return this
      return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            actions: <Widget>[signInAndOutButton(context)],
          ),
          body: ListView(children: <Widget>[
            Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(FirebaseAuth.instance.currentUser!.email.toString().split("@")[0], style: TextStyle(fontSize: 28)))),
            Text("Loan history:", style: TextStyle(fontSize: 20)),
            Container(
                height: 255,
                padding: EdgeInsets.only(left: 4, right: 4),
                child: FutureBuilder(
                    // Displays loan history when request is completed
                    future: futureLoans,
                    builder: (context, builder) {
                      return ListView(children: loanList(loans));
                    })),
            Text("Reviews:", style: TextStyle(fontSize: 20)),
            Container(
                height: 255,
                padding: EdgeInsets.only(left: 4, right: 4),
                child: FutureBuilder(
                    // Builds review cards when request is completed
                    future: futureReviewCards,
                    builder: (context, builder) {
                      return ListView(children: reviewCards);
                    })),
            Center(
                child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text("Delete account"),
                          content: Text("Are you sure you want to delete your account? This action can not be reverted."),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.currentUser!.delete();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                                },
                                child: Text("Delete"))
                          ]);
                    });
              },
              child: Text("Delete account"),
            ))
          ]));
    }
  }
}
