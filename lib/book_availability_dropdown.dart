import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_service.dart';

class BookAvailabilityDropdown extends StatefulWidget {
  final String isbn;
  final String closest;

  BookAvailabilityDropdown({Key? key, required this.isbn, required this.closest}) : super(key: key);

  @override
  _BookAvailabilityDropdownState createState() =>
      _BookAvailabilityDropdownState();
}

class _BookAvailabilityDropdownState extends State<BookAvailabilityDropdown> {
  final DatabaseService dbService = new DatabaseService();
  List<String> availabilityList = <String>[];
  String newValue = "Library";

  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
        future: dbService.getAvailability(widget.isbn),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              snapshot.data!.forEach((key, value) {
                String formattedString = key + " : Tilgjengelig: " + value;
                availabilityList.add(formattedString);
              });
              return DropdownButton(
                value: availabilityList.first,
                icon: Icon(Icons.keyboard_arrow_down),
                items: availabilityList.map((String items) {
                  return DropdownMenuItem(value: items, child: new Text(items));
                }).toList(),
                onChanged: (changedValue) {
                  newValue = changedValue.toString();
                },
              );
            }
          }
        });
  }

  void initState() {
    super.initState();
  }
}
