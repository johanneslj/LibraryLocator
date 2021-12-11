import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'database_service.dart';

import '../services/database_service.dart';
import 'loadingScreenView.dart';

class SearchView extends StatefulWidget {
  final List<Widget>? cache;
  const SearchView({Key? key, this.cache}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";
  bool searched = false;

  @override
  Widget build(BuildContext context) {
    Future<List<Widget>> futureBookCards = DatabaseService().search(searchQuery);
    List<Widget> bookCards = <Widget>[];

    futureBookCards.then((books) => bookCards = books);

    return Scaffold(
        appBar: AppBar(
          leading: null,
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: Column(children: [
          Expanded(
            child: Container(
                height: 255,
                padding: EdgeInsets.only(left: 4, right: 4),
                child:
                (bookCards.isEmpty && widget.cache!.isNotEmpty && !searched)
                    ? makeListView(widget.cache!)
                    : FutureBuilder(
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
                        })
          )),
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
      autofocus: false,
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
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _clearSearchQuery();
        },
      ),
      IconButton(
        icon: const Icon(Icons.camera_alt),
        onPressed: () async {
          String barcodeResult = await FlutterBarcodeScanner
              .scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
          _searchQueryController.text = barcodeResult;
          updateSearchQuery(barcodeResult);
          searched = true;
          FocusScope.of(context).unfocus();
        },
      ),IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          updateSearchQuery(_searchQueryController.text);
          searched = true;
          FocusScope.of(context).unfocus();
        },
      ),
    ];
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
