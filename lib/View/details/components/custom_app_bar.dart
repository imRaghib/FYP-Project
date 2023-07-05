import 'package:easy_shaadi/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        left: appPadding,
        right: appPadding,
        top: appPadding,
      ),
      child: Container(
        height: size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    // color: kPurple.withOpacity(0.6),
                    border: Border.all(color: white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(15)),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: kPurple,
                ),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: white.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(15)),
              child: Icon(
                Icons.favorite_border_rounded,
                color: kPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
