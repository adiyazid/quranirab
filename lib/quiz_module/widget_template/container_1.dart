import 'package:flutter/material.dart';

class Container1 extends StatelessWidget {
  const Container1({
    Key? key,
    required this.windowSize,
    required this.color,
    required this.text,
    required this.textSize,
    required this.textColor,
  }) : super(key: key);

  final double windowSize;
  final String text;
  final Color color;
  final Color textColor;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
        child: Container(
      width: windowSize / 3,
      height: windowSize / 3,
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: textSize),
        ),
      ),
    ));
  }
}
