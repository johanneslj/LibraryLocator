import 'package:flutter/material.dart';
import 'package:library_locator/services/database_service.dart';

class LoanCard extends StatefulWidget {
  final String imageURL;
  final String title;
  final DateTime to;
  final DateTime from;
  final String email;

  const LoanCard({Key? key, required this.imageURL, required this.title, required this.to, required this.from, required this.email}) : super(key: key);

  @override
  _LoanCardState createState() => _LoanCardState();
}

class _LoanCardState extends State<LoanCard> {
  final DatabaseService dbService = new DatabaseService();

  Image noImage = Image.asset(
    "assets/book.jpg",
    height: 90,
    width: 90,
  );

  Widget build(BuildContext context) {


    return Row(
      children: [
        Expanded(
          child: Container(
            foregroundDecoration: !isDelivered(widget.to)
                ? null
                : BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  ),
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                child: Container(
                    child: Row(children: [
                  Image(
                      image: NetworkImage(widget.imageURL),
                      height: 90,
                      width: 90,
                      errorBuilder: (BuildContext context, Object e, StackTrace? stackTrace) {
                        return noImage;
                      }),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Text(widget.title,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 22,
                              color: !isDelivered(widget.to) ? null : Colors.grey,
                            )),
                        Text("From: " + widget.from.toString().split(" ")[0],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: !isDelivered(widget.to) ? null : Colors.grey,
                            )),
                        Text("To: " + widget.to.toString().split(" ")[0],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: !isDelivered(widget.to) ? null : Colors.grey,
                            )),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  )),
                  ElevatedButton(
                    onPressed: () {
                      dbService.deliverBook(widget.email);
                    },
                    child: null,
                  ),
                ]))),
          ),
        )
      ],
    );
  }

  bool isDelivered(DateTime to) {
    bool delivered = false;

    if (!to.isAfter(DateTime.now())) {
      delivered = true;
    }

    return delivered;
  }

  DateTime createDateFromString(String dateString) {
    List<String> dayMonthYear = dateString.split("-");
    int year = int.parse(dayMonthYear[0]);
    int month = int.parse(dayMonthYear[1]);
    int day = int.parse(dayMonthYear[2]);
    DateTime date = new DateTime(year, month, day);
    return date;
  }

  void initState() {
    super.initState();
  }
}