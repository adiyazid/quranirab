import 'package:flutter/material.dart';
import 'dart:math';


class BasicsAlignScreen extends StatefulWidget {
  @override
  _BasicsAlignScreenState createState() => _BasicsAlignScreenState();
}

class _BasicsAlignScreenState extends State<BasicsAlignScreen> {

  final alignments = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  final alignmentsInfo = [
    "topLeft",
    "topCenter",
    "topRight",
    "centerLeft",
    "center",
    "centerRight",
    "bottomLeft",
    "bottomCenter",
    "bottomRight",
  ];

  var windowWidth;
  var windowHeight;
  var _x = 0.0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
          children: <Widget>[

            Container (
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
              child: Column(
                children: [
                  _getList(),
                  SizedBox(height: 50,),
                  _item2()
                ],
              )
            ),

            // appbar1(Colors.white, Colors.black, "Align", context, () {Navigator.pop(context);})

          ],
        )
    );
  }

  _getList() {
    return Wrap(
        children: alignments
            .toList()
            .map((mode) => Column(children: <Widget>[
          Container(
              margin: EdgeInsets.all(5),
              width: 100,
              height: 60,
              color: Colors.grey.withAlpha(88),
              child: Align(
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.cyanAccent,
                  ),
                  alignment: mode)),
          Text(alignmentsInfo[alignments.indexOf(mode)])
        ]))
            .toList());
  }

  _item2(){
    var item = Container(
      width: 300,
      height: 120,
      color: Colors.black.withAlpha(10),
      child: Align(
        child: Ball(
          color: Colors.orangeAccent,
        ),
        alignment: Alignment(_x, f(_x * pi)),
      ),
    );

    var slider = Slider(
        max: 180,
        min: -180,
        divisions: 360,
        label: "${_x.toStringAsFixed(2)}π",
        value: _x * 180,
        onChanged: (v) => setState(() => _x = v / 180));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[slider, item],
    );
  }

  double f(x) {
    double y = sin(x);
    return y;
  }
}


class Ball extends StatelessWidget {
  Ball({
    Key? key,
    this.radius = 15,
    this.color = Colors.blue,
  }) : super(key: key);
  final double radius; //半径
  final Color color; //颜色

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
