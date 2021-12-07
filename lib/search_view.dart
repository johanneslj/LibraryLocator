import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_locator/profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database_service.dart';
import 'loadingScreenView.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  @override
  Widget build(BuildContext context) {
    Future<List<Widget>> futureBookCards = DatabaseService().getAllBooks();
    List<Widget> bookCards = <Widget>[];

    futureBookCards.then((books) => bookCards = books);

    return Scaffold(
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : Container(),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: Column(children: [
          Expanded(
            child: Container(
                height: 255,
                padding: EdgeInsets.only(left: 4, right: 4),
                child: FutureBuilder(
                  // Displays books when done
                    future: futureBookCards,
                    builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: LoadingScreen(fontSize:30,));
                      } else {
                        if (snapshot.hasError)
                          return Center(child: Text('Error: ${snapshot.error}'));
                        else
                          bookCards = snapshot.data!;
                        return makeListView(bookCards);
                      }
                    })),
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
            Divider(color: Colors.white54),
        ]),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null || _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }




}
