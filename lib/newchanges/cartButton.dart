import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    required this.colour,
    required this.buttonTitle,
    required this.onPressedFunction,
    required this.Elevation,
  });

  final Color colour;
  final String buttonTitle;
  final void Function()? onPressedFunction;
  final double Elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: Elevation,
      color: colour, //Colors.lightBlueAccent,
      borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        onPressed: onPressedFunction,
        minWidth: 350.0,
        height: 50.0,
        child: Text(
          buttonTitle,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
      ),
    );
  }
}