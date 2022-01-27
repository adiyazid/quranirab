import 'dart:math';

import 'package:flutter/material.dart';

class BasicsContainerScreen extends StatefulWidget {
  const BasicsContainerScreen({Key? key}) : super(key: key);

  @override
  _BasicsContainerScreenState createState() => _BasicsContainerScreenState();
}

class _BasicsContainerScreenState extends State<BasicsContainerScreen> {

  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
        body: Stack(
          children: <Widget>[

            Container (
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
              width: windowWidth,
              child: ListView(
                children: _getList(),
              ),),

            // appbar1(Colors.white, Colors.black, "Basics", context, () {Navigator.pop(context);})

          ],
        )
    );
  }

  _getList() {
    List<Widget> list = [];

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/3,
      height: windowSize/3,
      color: Colors.yellow,
      child: const Center(child: Text("1"),),
    )));

    list.add(const SizedBox(height: 10,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/3,
      height: windowSize/3,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        //border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(windowWidth/3),
      ),
      child: const Center(child: Text("2"),),
    )));

    list.add(const SizedBox(height: 10,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/3,
      height: windowSize/3,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(windowWidth/3),
      ),
      child: const Center(child: Text("3"),),
    )));

    list.add(const SizedBox(height: 10,));

    // list.add(Container4(windowSize: windowSize));

    list.add(const SizedBox(height: 10,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/2,
      height: windowSize/4,
      decoration: const BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      ),
      child: const Center(child: Text("5"),),
    )));

    list.add(const SizedBox(height: 10,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/2,
      height: windowSize/4,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
      ),
      child: const Center(child: Text("6"),),
    )));

    list.add(const SizedBox(height: 10,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/2,
      height: windowSize/4,
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
      ),
      child: const Center(child: Text("7"),),
    )));

    list.add(const SizedBox(height: 10,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/2,
      height: windowSize/4,
      decoration: BoxDecoration(
        color: Colors.orange.shade900,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(50)),
      ),
      child: const Center(child: Text("8"),),
    )));

    list.add(const SizedBox(height: 10,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/2,
      height: windowSize/4,
      decoration: BoxDecoration(
        color: Colors.orange.shade900,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(50)),
      ),
      child: const Center(child: Text("9"),),
    )));

    list.add(const SizedBox(height: 20,));

    // list.add(Container10(windowSize: windowSize));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/3,
      height: windowSize/3,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: new BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.greenAccent,
            spreadRadius: 3,
            blurRadius: 9,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: const Center(child: Text("11"),),
    )));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(child: Container(
      width: windowSize/3,
      height: windowSize/3,
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: new BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.red,
            spreadRadius: 3,
            blurRadius: 9,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: const Center(child: Text("12"),),
    )));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass1(),
        child: Container(
      width: windowSize/3,
      height: windowSize/3,
      color: Colors.lightGreen,
      child: const Center(child: Text("13"),),
    ))));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass2(),
        child: Container(
          width: windowSize/3,
          height: windowSize/3,
          color: Colors.lightGreen,
          child: const Align(
            alignment: Alignment.bottomRight,
            child: Text("14"),),
        ))));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass3(),
        child: Container(
          width: windowSize/3,
          height: windowSize/3,
          color: Colors.red,
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text("15"),),
        ))));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass22(),
        child: Container(
          width: windowSize/3,
          height: windowSize/3,
          color: Colors.blue,
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text("22"),),
        ))));

    list.add(UnconstrainedBox(
        child: RotationTransition(
            turns: const AlwaysStoppedAnimation(45/360),
            child: Container(
      width: windowSize/3,
      height: windowSize/3,
      color: Colors.orange,
      child: const Center(child: Text("16"),),
    ))));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(
        child: RotationTransition(
            turns: const AlwaysStoppedAnimation((360-45)/360),
            child: Container(
              width: windowSize/3,
              height: windowSize/3,
              color: Colors.yellowAccent,
              child: const Center(child: Text("17"),),
            ))));

    list.add(const SizedBox(height: 50,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass4(),
        child: Container(
          width: windowSize/3,
          height: windowSize/4,
          color: Colors.lightGreen,
          child: const Center(child: Text("18"),),
        ))));

    list.add(const SizedBox(height: 20,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass5(),
        child: Container(
          width: windowSize/3,
          height: windowSize/4,
          color: Colors.red,
          child: const Center(child: Text("19"),),
        ))));

    list.add(const SizedBox(height: 40,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass6(),
        child: Container(
          width: windowSize/2,
          height: windowSize/3,
          color: Colors.blue,
          child: const Center(child: Text("20"),),
        ))));

    list.add(const SizedBox(height: 40,));

    list.add(UnconstrainedBox(child: ClipPath(
        clipper: ClipPathClass21(),
        child: Container(
          width: windowSize/2,
          height: windowSize/3,
          color: Colors.black,
          child: const Center(child: Text("21", style: TextStyle(color: Colors.white),),),
        ))));

    list.add(const SizedBox(height: 40,));

    list.add(UnconstrainedBox(child: ClipPath(
        // clipper: ClipPathClass23(30),
        child: Container(
          width: windowSize/2,
          height: windowSize/3,
          color: Colors.greenAccent,
          child: const Center(child: Text("23", style: TextStyle(color: Colors.white),),),
        ))));

    list.add(const SizedBox(height: 40,));

    list.add(const SizedBox(height: 100,));

    return list;
  }
}



class ClipPathClass1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(30, 0);
    path.quadraticBezierTo(0, 0, 0, size.height/2);
    path.quadraticBezierTo(0, size.height, 30, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width-15, size.height, size.width-15, size.height/2);
    path.quadraticBezierTo(size.width-15, 0, size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ClipPathClass2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ClipPathClass3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class ClipPathClass4 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width/2, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class ClipPathClass5 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width/2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ClipPathClass6 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.cubicTo(size.width*0.3, size.height,
        size.width*0.4, size.height*0.7,
        size.width*0.7, size.height*0.9);
    path.cubicTo(size.width*0.8, size.height,
        size.width*0.8, size.height,
        size.width, size.height*0.95);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ClipPathClass21 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.cubicTo(size.width*0.7, size.height*0.3,
        size.width*0.1, size.height*0.7,
        size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ClipPathClass22 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height*0.80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
