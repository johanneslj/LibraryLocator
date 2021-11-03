import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:library_locator/review_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'book_availability_dropdown.dart';
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

  late GoogleMapController mapController;

  TextEditingController reviewTextController = TextEditingController();

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: dbService.getAverageRating(widget.isbn),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              averageRating = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text('Book view'),
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
                              width: 150, // or use fixed size like 200
                              height: 150,
                              child: GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _center,
                                    zoom: 11.0,
                                  )))),
                      Column(children: [
                        BookAvailabilityDropdown(isbn: widget.isbn, closest: "ABsb"),
                        ElevatedButton(
                          child: Text("Loan book"),
                          onPressed: () {
                            print(BookAvailabilityDropdown(
                              isbn: widget.isbn,
                              closest: "Abababs",
                            ).toString());
                            //dbService.loanBook(widget.isbn, );
                          },
                        ),
                      ])
                    ]),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          InkWell(
                              child: Container(width: 30, height: 30, child: Icon(Icons.add, color: Colors.blue)),
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 400));
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
                                                dbService.addReview(widget.isbn, "user", double.parse(getRating()), reviewTextController.text);
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

  void initState() {
    super.initState();
  }
}
