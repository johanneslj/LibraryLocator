import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookCard extends StatelessWidget {
  final String imageURL;
  final double? stars;
  final String title;
  final String author;

  const BookCard(
      {Key? key,
      required this.imageURL,
      this.stars,
        required this.title,
        required this.author
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}