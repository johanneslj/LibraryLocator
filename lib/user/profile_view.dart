import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:library_locator/services/database_service.dart';
import 'package:library_locator/user/login_view.dart';
import 'package:library_locator/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController controller = ScrollController();
  ScrollController _loanScrollCtrl = ScrollController();
  ScrollController _reviewScrollCtrl = ScrollController();

  /// Creates the button for the toolbar which is either a sign in or sign out
  /// button depending on if there is a user instance or not.
  TextButton signInAndOutButton(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return TextButton.icon(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(title: Text("Sign Out"), content: Text("Are you sure you want to sign out?"), actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
                      },
                      child: Text("Sign Out"))
                ]);
              });
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
      // When the user is not logged in return this.
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
      Future<List<Widget>> futureLoans = DatabaseService().getLoans(FirebaseAuth.instance.currentUser!.email.toString());
      List<Widget> loans = List.empty();

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
          body: ListView(controller: controller, children: <Widget>[
            Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(FirebaseAuth.instance.currentUser!.email.toString().split("@")[0], style: TextStyle(fontSize: 28)))),
            Text("Loan history:", style: TextStyle(fontSize: 20)),
            Container(
                height: 320,
                padding: EdgeInsets.only(left: 4, right: 4),
                child: FutureBuilder(
                    // Displays loan history when request is completed
                    future: futureLoans,
                    builder: (context, builder) {
                      // Lets the child ListView scroll the ListView ancestor when reaching either edge.
                      return NotificationListener<OverscrollNotification>(
                          onNotification: (OverscrollNotification value) {
                            if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
                              if (controller.offset != 0) controller.jumpTo(0);
                              return true;
                            }
                            if (controller.offset + value.overscroll >= controller.position.maxScrollExtent) {
                              if (controller.offset != controller.position.maxScrollExtent) controller.jumpTo(controller.position.maxScrollExtent);
                              return true;
                            }
                            controller.jumpTo(controller.offset + value.overscroll);
                            return true;
                          },
                          child: (loans.isEmpty)
                              // If user has no previous loans display this
                              ? Center(child: Text("You have no previous loans", style: TextStyle(fontSize: 18, color: Colors.grey)))
                              : makeListView(loans));
                    })),
            Text("Reviews:", style: TextStyle(fontSize: 20)),
            Container(
                height: 280,
                padding: EdgeInsets.only(left: 4, right: 4),
                child: FutureBuilder(
                    // Builds review cards when request is completed
                    future: futureReviewCards,
                    builder: (context, builder) {
                      // Lets the child ListView scroll the ListView ancestor when reaching either edge.
                      return NotificationListener<OverscrollNotification>(
                          onNotification: (OverscrollNotification value) {
                            if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
                              if (controller.offset != 0) controller.jumpTo(0);
                              return true;
                            }
                            if (controller.offset + value.overscroll >= controller.position.maxScrollExtent) {
                              if (controller.offset != controller.position.maxScrollExtent) controller.jumpTo(controller.position.maxScrollExtent);
                              return true;
                            }
                            controller.jumpTo(controller.offset + value.overscroll);
                            return true;
                          },
                          child: (reviewCards.isEmpty)
                              ? ListView(children: [
                                  Center(
                                    child: Text("You have not written any reviews yet", style: TextStyle(fontSize: 18, color: Colors.grey)),
                                    heightFactor: 8,
                                  )
                                ], controller: _reviewScrollCtrl)
                              : makeListView(reviewCards));
                    })),
            Center(
                child: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      // Confirmation dialog for deleting user.
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
                                  // Deletes the user from firebase.
                                  FirebaseAuth.instance.currentUser!.delete();
                                  FirebaseAuth.instance.signOut();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
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

  ListView makeListView(List<Widget> cards) {
    return ListView(
      children: [
        for (var card in cards)
          Column(children: [
            card,
            if (!(cards.indexOf(card) == cards.length - 1)) // Check if the card is the last element in the view, if it is
              // then don't add a divider at the bottom.
              Divider(),
          ]),
      ],
    );
  }
}
