import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quranirab/quiz_module/utils/button114.dart';
import 'package:quranirab/quiz_module/utils/button115.dart';
import 'package:quranirab/quiz_module/utils/button182.dart';
import 'package:quranirab/quiz_module/utils/colors.dart';

import 'container_1.dart';
import 'container_10.dart';
import 'container_4.dart';

class ContainerWidget extends StatefulWidget {
  const ContainerWidget({Key? key}) : super(key: key);

  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container1(
                    windowSize: 1000,
                    text: 'Container 1',
                    color: Colors.yellowAccent,
                    textSize: 20.0,
                    textColor: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container4(
                    windowSize: 1000,
                    text: 'Container 4',
                    color: Colors.purple,
                    textSize: 20.0,
                    textColor: Colors.white12,
                    radius: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container10(windowSize: windowSize),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      width: 100,
                      height: 60,
                      color: Colors.grey.withAlpha(88),
                      child: Align(
                          child: Container(
                            width: 30,
                            height: 30,
                            color: Colors.cyanAccent,
                          ),
                          alignment: Alignment.center)),
                ),
                SizedBox(
                  height: 20,
                ),
                button182('button 182', const TextStyle(fontSize: 20),
                    Colors.redAccent, 20, () {}, true),
                const SizedBox(
                  height: 20,
                ),
                button114('button 114', Colors.redAccent,
                    'assets/quranirab.png', 20, () {}, true),
                const SizedBox(
                  height: 20,
                ),
                button115('button 115', Colors.redAccent,
                    'assets/quranirab.png', 10, () {}, false),
                const Text(
                  "Text text text text Size 18",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  "Text text text text Size 20",
                  style: TextStyle(fontSize: 20,  color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  "Text text Size 20 line Through Colors",
                  style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.lineThrough,
                      color: ManyColors.color12),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  "Text text Size 20 Bold",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
