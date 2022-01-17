import 'package:flutter/material.dart';

class Container10 extends StatelessWidget {
  const Container10({
    Key? key,
    required this.windowSize,
  }) : super(key: key);

  final double windowSize;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
        child: Container(
      width: windowSize / 3,
      height: windowSize / 3,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 3,
            blurRadius: 9,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text("10"),
      ),
    ));
  }
}
