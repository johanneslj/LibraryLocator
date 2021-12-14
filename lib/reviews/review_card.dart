import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../bookDetails/descriptionTextWidget.dart';

class ReviewCard extends StatefulWidget {
  final double stars;
  final String reviewText;
  final String username;

  const ReviewCard({Key? key, required this.stars, required this.reviewText, required this.username}) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  RatingBarIndicator(
                    rating: widget.stars,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 15,
                  ),
                  DescriptionTextWidget(text: widget.reviewText),
                ],
              ),
            ),
          ),


        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      )
    ]));
  }

  void initState() {
    super.initState();
  }
}
