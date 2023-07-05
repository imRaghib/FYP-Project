import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Star extends StatefulWidget {
  const Star({super.key});

  @override
  State<Star> createState() => _StarState();
}

class _StarState extends State<Star> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RatingBar.builder(
        itemBuilder: (context, index) => Icon(
          Icons.star,
          size: 10,
          color: Colors.amber,
        ),
        itemCount: 5,
        initialRating: 1,
        itemSize: 10,
        unratedColor: Colors.grey,
        maxRating: 5,
        allowHalfRating: true,
        onRatingUpdate: (value) {
          // rating = (totalRating / (5 * totalFeedbacks)) * 5;
          // print(rating);
        },
      ),
    );
  }
}
