import 'package:flutter/material.dart';

import '../Model/bookings.dart';
import '../Model/itemview.dart';

class ViewAll extends StatelessWidget {
  ViewAll({this.items = const []});
  List<Booking> items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return MyItems(
                // image: items[index].venueImage,
                // name: items[index].venueName,
                // price: items[index].venuePrice,
                // description: items[index].venueDescription,
                );
          }),
    );
  }
}
