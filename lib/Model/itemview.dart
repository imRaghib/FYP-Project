import 'package:easy_shaadi/constants.dart';
import 'package:flutter/material.dart';

class MyItems extends StatelessWidget {
  MyItems({
    super.key,
    this.name = '',
    this.image = '',
    this.description = '',
    this.price = 0,
    this.onPress,
  });

  String name;
  String image;
  String description;
  int price;
  var onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPurple,
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          height: 170,
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Image border
                  child: SizedBox.fromSize(
                    child: Image.network(image, fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(height: 2,),
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'SourceSansPro-SemiBold',
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        price.toString(),
                        style: TextStyle(
                          fontFamily: 'SourceSansPro-SemiBold',
                          fontSize: 20,
                          color: kPurple,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
