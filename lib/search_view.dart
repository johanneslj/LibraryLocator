import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_locator/profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:searchfield/searchfield.dart';

import 'book_details_view.dart';
import 'database_service.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    Future<List<Widget>> futureBookCards = DatabaseService().getAllBooks();
    List<Widget> bookCards = <Widget>[];

    futureBookCards.then((books) => bookCards = books);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
            title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      /* Clear the search field */
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        )),
        body: Column(children: [
          Container(
              height: 255,
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FutureBuilder(
                  // Displays books when done
                  future: futureBookCards,
                  builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('Please wait its loading...'));
                    } else {
                      if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                      else
                        bookCards = snapshot.data!;
                      return ListView(children: bookCards);
                    }
                  })),
        ]));
  }
}
