import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:library_locator/providers/library_provider.dart';

import 'database_service.dart';

class SelectAndLoanBook extends StatefulWidget {
  final String isbn;
  final String closest;

  SelectAndLoanBook({Key? key, required this.isbn, required this.closest}) : super(key: key);

  @override
  _SelectAndLoanBookState createState() => _SelectAndLoanBookState();
}

class _SelectAndLoanBookState extends State<SelectAndLoanBook> {
  final DatabaseService dbService = new DatabaseService();
  List<String> availabilityList = <String>[];
  String selectedLibrary = "Select Library";

  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
        future: dbService.getAvailability(widget.isbn),
        builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
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
              ]);
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

  void initState() {
    super.initState();
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
}
