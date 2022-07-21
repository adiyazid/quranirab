import 'package:flutter/material.dart';

class Container4 extends StatelessWidget {
  const Container4({
    Key? key,
    required this.windowSize,
    required this.color,
    required this.radius,
    required this.text,
    required this.textSize,
    required this.textColor,
  }) : super(key: key);

  final double windowSize;
  final String text;
  final Color color;
  final Color textColor;
  final double textSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
        child: Container(
      width: windowSize / 2,
      height: windowSize / 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
      ),
      child: Center(
        child: Text(text),
      ),
    ));
  }
}
