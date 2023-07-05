import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPink, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPurple, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
const kDarkBlue = Color(0xFFF1a122b);
const kPurple = Color(0xFFF825ecb);
const kPink = Color(0xFFFdbbdfb);
const kBackgroundColor = Color(0xFFFfafafa);

const kMyLightGrayColor = Color(0xFFF7d7c7d);
const kMyBlackColor = Color(0xFFF2d2f32);
const kMyYellowColor = Color(0xFFFf5b14a);
const kMyLightYellowColor = Color(0xFFFf2c985);
const kMyPurpleColor = Color(0xFFFAAA6D6);

const kMyWhiteColor = Colors.white;

const double kDefaultPadding = 20.0;

const kDefaultBorderRadius = 10.0;

const kMontserrat = 'Montserrat';
const kMontserratBold = 'Montserrat_Bold';

//colors used in this app

const Color white = Colors.white;
const Color black = Colors.black;
const Color red = Colors.red;
const Color darkBlue = Color.fromRGBO(19, 26, 44, 1.0);

//default app padding

const double appPadding = 30.0;
