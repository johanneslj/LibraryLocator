import 'package:flutter/material.dart';

import 'database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewList extends StatelessWidget {
  DatabaseService dbService = new DatabaseService();
  List<Widget> list = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: dbService.setReviews(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  Center(child: Text('Please wait its loading...'));
        }else{
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            snapshot.data!.forEach((element) {
              list.add(element);
            });
            return Center(child: new Column(children: list));  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }

  
}