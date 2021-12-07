import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:library_locator/review_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'bottom_navigation_bar_widget.dart';
import 'google_map_widget.dart';
import 'loadingScreenView.dart';
import 'select_and_loan_book.dart';
import 'database_service.dart';

class BookDetailsView extends StatefulWidget {
  BookDetailsView({Key? key, required this.isbn}) : super(key: key);
  final String isbn;

  @override
  _BookDetailsViewState createState() => _BookDetailsViewState();
}

class _BookDetailsViewState extends State<BookDetailsView> {
  final DatabaseService dbService = new DatabaseService();
  double averageRating = 0;
  String currentRating = "";

  TextEditingController reviewTextController = TextEditingController();

  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: dbService.getAverageRating(widget.isbn),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingScreen(fontSize: 30,));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              averageRating = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text("Book Title"),
                elevation: 0,
              ),
              body: Center(
                child: ListView(
                  children: [
                    Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'), height: 300),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Column(children: [
                          Text("Title of Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text("(" + averageRating.toString().substring(0, 3) + ")"),
                            RatingBarIndicator(
                              rating: averageRating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 15,
                            ),
                          ]),
                        ])),
                    Row(children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: MapWidget(selectedLibrary: selectedLibrary,),
                          )),
                        SizedBox(
                          width: 214,
                          height: 150,
                          child: _makeDropdown(),),
                        //TODO make dropdown work based on library that is closest,

                    ]),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          InkWell(
                              child: Container(width: 30, height: 30, child: Icon(Icons.add, color: Colors.blue)),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Add Review'),
                                        content: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Form(
                                              child: Column(
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: 3,
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemBuilder: (context, _) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      setRating(rating.toString());
                                                    },
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.multiline,
                                                    controller: reviewTextController,
                                                    maxLines: 6,
                                                    decoration: InputDecoration(
                                                      labelText: 'Review',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          width: 700,
                                          height: 250,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              child: Text("Submit"),
                                              onPressed: () {
                                                print(getRating());
                                                dbService.addReview(widget.isbn, double.parse(getRating()), reviewTextController.text);
                                                Navigator.pop(context);
                                                setRating("3");
                                              })
                                        ],
                                      );
                                    });
                              }),
                        ])),
                    ReviewList(isbn: widget.isbn),
                  ],
                ),
              ),
            );
          }
        });
  }

  void setRating(String rating) {
    currentRating = rating;
  }

  String getRating() {
    return currentRating;
  }

  List<String> availabilityList = <String>[];
  String selectedLibrary = "Select Library";

  Widget _makeDropdown() {
    return FutureBuilder<Map<String, String>>(
        future: dbService.getAvailability(widget.isbn),
        builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingScreen(fontSize: 30));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              availabilityList.clear();
              snapshot.data!.forEach((key, value) {
                String formattedString = key + " : Tilgjengelig: " + value;
                availabilityList.add(formattedString);
              });
              availabilityList.sort();
              return Column(children: [
                Row(children: [
                  Container(child: Text(selectedLibrary), width: 160),
                  PopupMenuButton(
                      icon: Icon(Icons.arrow_drop_down),
                      onSelected: (value) {
                        setState(() {
                          selectedLibrary = value.toString();
                        });
                      },
                      itemBuilder: (context) => availabilityList.map((library) {
                        return PopupMenuItem(child: Text(library), value: library, enabled: isAvailable(library));
                      }).toList()),
                ]),
                ElevatedButton(
                    child: Text("Loan book"),
                    onPressed: !canLoan(selectedLibrary)
                        ? null
                        : () => {
                      dbService.loanBook(widget.isbn, selectedLibrary),
                      selectedLibrary = "Select Library",
                      setState(() {}),
                    }),
              ],
              mainAxisAlignment: MainAxisAlignment.center,);
            }
          }
        });
  }

  bool canLoan(String library) {
    bool canLoan = false;
    if (!library.contains("Select Library")) {
      if (!library.split("Tilgjengelig: ")[1].contains("0")) {
        canLoan = true;
      }
    }
    return canLoan;
  }

  bool isAvailable(String library) {
    bool isAvailable = false;

    if (!library.split("Tilgjengelig: ")[1].contains("0")) {
      isAvailable = true;
    }

    return isAvailable;
  }

  String getLibrary() {
    return selectedLibrary;
  }

  void initState() {
    super.initState();
  }
}
