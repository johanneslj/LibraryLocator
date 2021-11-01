import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Text(widget.username, textAlign: TextAlign.left),
            RatingBar.builder(
              initialRating: widget.stars,
              minRating: 0,
              ignoreGestures: true,
              direction: Axis.horizontal,
              itemSize: 10,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.black,
              ),
              onRatingUpdate: (rating) {},
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
      Text(widget.reviewText)
    ]));
  }

  void initState() {
    super.initState();
  }
}
