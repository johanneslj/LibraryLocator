import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'loadingScreenView.dart';

class HomePage extends StatefulWidget {
  final List<Widget>? cache;
  final Function()? updateCache;

  const HomePage({Key? key, this.updateCache, this.cache}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    List<Widget> bookCards = <Widget>[];
    Future<List<Widget>>? futureBookCards;

    if (widget.cache == null || widget.cache!.isEmpty) {
      futureBookCards = DatabaseService().getBooks();
      futureBookCards.then((books) => bookCards = books);
      if(widget.updateCache != null) {
        widget.updateCache!();
      }
    } else {
      bookCards = widget.cache!;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(child:Text("Home")),
      ),
        body: Column(children: [
          Expanded(child:
          futureBookCards != null ? // If books have not been cached load books.
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
              : makeListView(bookCards),
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
