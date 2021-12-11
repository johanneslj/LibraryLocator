import 'package:flutter/material.dart';
import 'package:library_locator/user/profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bookDetails/book_details_view.dart';
import '../services/database_service.dart';
import 'database_service.dart';
import 'loadingScreenView.dart';

class HomePage extends StatefulWidget {
  final List<Widget>? cache;
  final Function()? updateCache;

  const HomePage({Key? key, this.updateCache, this.cache}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*
  IconButton signInAndOutButton(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            setState(() => null);
          });
    } else {
      return IconButton(
          icon: Icon(Icons.login),
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetailsView(isbn: "12345")));
          });
    }
  }

   */

  @override
  Widget build(BuildContext context) {
    Future<List<Widget>> test = DatabaseService().getBooks();
    Future<List<Widget>> futureBookCards = DatabaseService().getBooks();
    List<Widget> bookCards = <Widget>[];

    futureBookCards.then((books) => bookCards = books);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Home"),
      ),
        body: Column(children: [
          Expanded(child:
          FutureBuilder(
            // Displays books when done
              future: futureBookCards,
              builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LoadingScreen(fontSize: 30,));
                } else {
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else
                    bookCards = snapshot.data!;
                  return makeListView(bookCards);
                }
              })
          ),
    ]));
  }

  ListView makeListView(List<Widget> bookCards) {
    return ListView(
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
}
