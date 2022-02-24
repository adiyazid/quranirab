import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/views/quran.words.dart';

import '../data.from.firestore.dart';
import 'login.screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);

    if (appUser.user != null) {
      print('Logged in');
      // return const DataFromFirestore();
      return const DummyPage();
    } else {
      print('Not logged in');
      return const SigninWidget();
    }
  }
}

class DummyPage extends StatelessWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const FacebookHomeScreen()));
                  //     },
                  //     child: const Text('Surah screen')),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const FacebookHomeScreen2()));
                  //     },
                  //     child: const Text('Surah screen2')),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const FacebookHomeScreen3()));
                  //     },
                  //     child: const Text('Surah screen3')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const Slice()));
                  //     },
                  //     child: const Text('Flutter Slice')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Slice2()));
                      },
                      child: const Text('Flutter Slice')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const LandingPage()));
                  //     },
                  //     child: const Text('Firebase integration')),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Words()));
                      },
                      child: const Text('Alfatihah slice')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const QuizHome()));
                  //     },
                  //     child: const Text('Quiz')),
                ]),
          )),
    );
  }
}

// class Slice extends StatefulWidget {
//   const Slice({Key? key}) : super(key: key);
//
//   @override
//   _SliceState createState() => _SliceState();
// }
//
// class _SliceState extends State<Slice> {
//   CollectionReference quranText =
//       FirebaseFirestore.instance.collection('quran_texts');
//   CollectionReference rawText =
//       FirebaseFirestore.instance.collection('raw_quran_texts');
//   CollectionReference sliceData =
//       FirebaseFirestore.instance.collection('medina_mushaf_pages');
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // getData();
//     super.initState();
//   }
//
//   final Stream<QuerySnapshot> _textsStream = FirebaseFirestore.instance
//       .collection('quran_texts')
//       .where('medina_mushaf_page_id', isEqualTo: '1')
//       .snapshots();
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//       appBar: AppBar(),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _textsStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Something went wrong'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: Text("Loading"));
//           }
//
//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data =
//                   document.data()! as Map<String, dynamic>;
//               return ListTile(
//                 title: Container(
//                   color: themeProvider.isDarkMode ? Colors.white : Colors.white,
//                   child: Text(
//                     data['text'].substring(2, 6),
//                     textDirection: TextDirection.rtl,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
//                   ),
//                 ),
//                 // subtitle: Text(
//                 //   data['text1'].trim().replaceAll('b', '\n'),
//                 //   textAlign: TextAlign.center,
//                 //   style: TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
//                 // ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
//
// // void getData() {
// //   FirebaseFirestore.instance
// //       .collection('quran_texts')
// //       .where('medina_mushaf_page_id', isEqualTo: '1')
// //       .get()
// //       .then((QuerySnapshot querySnapshot) {
// //     querySnapshot.docs.forEach((doc) {
// //       print(doc["text"]);
// //     });
// //   });
// // }
// }

class Slice2 extends StatefulWidget {
  const Slice2({Key? key}) : super(key: key);

  @override
  _Slice2State createState() => _Slice2State();
}

class _Slice2State extends State<Slice2> {
  CollectionReference quranText =
      FirebaseFirestore.instance.collection('quran_texts');
  CollectionReference rawText =
      FirebaseFirestore.instance.collection('raw_quran_texts');
  CollectionReference sliceData =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');
  final List _list = [];

  var _positionW;

  var totalSlice = 10;

  List _slice = [];

  var index = 0;

  List _break = [];
  bool _selected = false;

  Color _color(int index) {
    if (index % 2 == 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color background = Colors.redAccent;
    final Color fill = Colors.blueAccent;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    var start1 = 1 / 33;
    var end1 = 1 / 33;
    var start2 = 3 / 33;
    var end2 = 5 / 33;
    final List<double> stop1 = [0.0, start1, end1, 1.0];
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final Size size = (TextPainter(
    //         text: TextSpan(
    //           text: _list[0].replaceAll('b', '').trim(),
    //           style: TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
    //         ),
    //         textAlign: TextAlign.center,
    //         maxLines: 1,
    //         textScaleFactor: MediaQuery.of(context).textScaleFactor,
    //         textDirection: TextDirection.rtl)
    //       ..layout())
    //     .size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Word id : ${_positionW ?? 'null'}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 7; i++)
                Container(
                  color: Colors.transparent,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: _list.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int ii = 0;
                                  ii < _list[i].split(' ').length;
                                  ii++)
                                InkWell(
                                  onTap: ii == _list[i].split(' ').length - 1
                                      ? null
                                      : () => setState(() {
                                            // _selected = true;
                                            _positionW = ii;
                                          }),
                                  child: Container(
                                    color:
                                        ii % 2 == 0 ? Colors.blue : Colors.red,
                                    child: Text(
                                      _list[i].split(' ')[ii] ?? 'loading',
                                      style: TextStyle(
                                          color: _selected
                                              ? _color(ii)
                                              : Colors.black,
                                          fontFamily: 'MeQuran2',
                                          fontSize: 30),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Text(
                            'Loading...',
                            style: TextStyle(color: Colors.black, fontSize: 30),
                          ),
                  ),
                )
            ],
          ),
        )
        // _list.isNotEmpty
        //     ? Center(
        //         child: Stack(
        //           children: [
        //             Container(
        //               color: Colors.transparent,
        //               child: Text(
        //                 _list.isNotEmpty
        //                     ? _list.join().replaceAll('b', '\n').trim()
        //                     : '',
        //                 textDirection: TextDirection.rtl,
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
        //               ),
        //             ),
        //             // Container(
        //             //   width: size.width,
        //             //   height: size.height,
        //             //   decoration: BoxDecoration(
        //             //     color: themeProvider.isDarkMode
        //             //         ? Colors.white
        //             //         : Colors.white,
        //             //     gradient: LinearGradient(
        //             //       colors: gradient,
        //             //       stops: stop1,
        //             //       end: Alignment.centerLeft,
        //             //       begin: Alignment.centerRight,
        //             //     ),
        //             //   ),
        //             //   child: CustomPaint(
        //             //     painter: CutOutTextPainter(
        //             //       text: _list[0],
        //             //       color: Colors.white,
        //             //     ),
        //             //   ),
        //             // ),
        //             Directionality(
        //               textDirection: TextDirection.rtl,
        //               child: SizedBox(
        //                 width: size.width,
        //                 height: size.height,
        //                 // color: i % 2 == 0
        //                 //     ? Colors.redAccent
        //                 //     : Colors.blueAccent,
        //                 child: Row(
        //                   children: [
        //                     for (var i = 1; i < _break[0]; i++)
        //                       InkWell(
        //                         onTap: i > _break[0]
        //                             ? null
        //                             : () async {
        //                                 var text = _slice.where((element) =>
        //                                     element["end"] >= i &&
        //                                     i >= element["start"]);
        //                                 String id = text
        //                                     .map((e) => e['word_id'])
        //                                     .toString();
        //                                 setState(() {
        //                                   if (id != '()') {
        //                                     _positionW = id
        //                                         .replaceAll('(', '')
        //                                         .replaceAll(')', '');
        //                                   }
        //                                 });
        //                                 // if (_slice[0]["end"] >= i &&
        //                                 //     i >= _slice[0]["start"]) {
        //                                 //   setState(() {
        //                                 //     _positionW = _slice[0]['word_id'];
        //                                 //   });
        //                                 // } else {
        //                                 //   setState(() {
        //                                 //     _positionW = 'No data for position $i';
        //                                 //   });
        //                                 // }
        //                               },
        //                         child: Container(
        //                             width: size.width / _list[0].length,
        //                             height: size.height * 0.5,
        //                             color: Colors.transparent),
        //                       ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     : Center(child: CircularProgressIndicator()),
        );
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('quran_texts')
        .where('medina_mushaf_page_id', isEqualTo: '1')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _list.add(doc["text"].trim());
        });
      }
    });
    await sliceData
        .where('id', isEqualTo: '1')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _slice = json.decode(doc["slicing_data"]);
        });
      }
      for (var element in _list) {
        _break.add(element.indexOf('﴿') - 2);
      }
    });

    // FirebaseFirestore.instance
    //     .collection('raw_quran_texts')
    //     .where('id', isEqualTo: '1')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   for (var doc in querySnapshot.docs) {
    //     setState(() {
    //       _list.add(doc["text"]);
    //     });
    //   }
    // });
  }
}
