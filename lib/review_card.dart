import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'descriptionTextWidget.dart';

class ReviewCard extends StatefulWidget {
  final double stars;
  final String reviewText;
  final String username;

  const ReviewCard(
      {Key? key,
      required this.stars,
      required this.reviewText,
      required this.username})
      : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Text(widget.username, textAlign: TextAlign.left),
            RatingBarIndicator(
              rating: widget.stars,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 10,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
      Flexible(child: DescriptionTextWidget(text: widget.reviewText)),
    ]));
  }

  void initState() {
    super.initState();
  }
}
