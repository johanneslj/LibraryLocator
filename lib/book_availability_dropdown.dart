import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_service.dart';

class BookAvailabilityDropdown extends StatefulWidget {
  final String isbn;
  final String closest;

  BookAvailabilityDropdown({Key? key, required this.isbn, required this.closest}) : super(key: key);

  @override
  _BookAvailabilityDropdownState createState() => _BookAvailabilityDropdownState();
}

class _BookAvailabilityDropdownState extends State<BookAvailabilityDropdown> {
  final DatabaseService dbService = new DatabaseService();
  List<String> availabilityList = <String>[];
  String _value = "Select Library";

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
              return Row(children: [
                Text(_value),
                PopupMenuButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      setState(() {
                        _value = value.toString();
                      });
                    },
                    itemBuilder: (context) => availabilityList.map((library) {
                          return PopupMenuItem(child: Text(library), value: library);
                        }).toList()),
              ]);
            }
          }
        });
  }

  void initState() {
    super.initState();
  }
}
