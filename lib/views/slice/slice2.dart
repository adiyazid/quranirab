import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  CollectionReference wordText = FirebaseFirestore.instance.collection('words');
  final List _list = [];

  var _positionW;
  var total = 0;
  var totalSlice = 10;

  List _slice = [];

  var index = 0;

  List _break = [];

  List _width = [];

  var _wordID = [];

  var word = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = (TextPainter(
            text: TextSpan(
              text: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
              style: TextStyle(
                  fontFamily: 'MeQuran2', color: Colors.white, fontSize: 30),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.rtl)
          ..layout())
        .size;
    return word.length == _slice.length
        ? Scaffold(
            appBar: AppBar(
              title: Text('${_positionW ?? ''}'),
            ),
            body: SingleChildScrollView(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      reverse: true,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) {
                        return index != 0 && index != 6 && index != 20&& index != 26&& index != 28&& index != 32&& index != 17&& index != 34&& index != 35
                            ? Text(' ')
                            : Text('');
                      },
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () => setState(() {
                            _positionW = i + 1;
                          }),
                          child: Container(
                            color: i % 2 == 0 ? Colors.blue : Colors.red,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${word[i]}',
                                    style: TextStyle(
                                      fontFamily: 'MeQuran2',
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _slice.length,
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: SizedBox(
                  //     height: 100,
                  //     child: ListView(
                  //       reverse: true,
                  //       primary: false,
                  //       shrinkWrap: true,
                  //       scrollDirection: Axis.horizontal,
                  //       children: <Widget>[
                  //         for (int i = 0; i < total; i++)
                  //           InkWell(
                  //             onTap: () => setState(() {
                  //               _positionW = i + 1;
                  //             }),
                  //             child: Container(
                  //               color: i % 2 == 0 ? Colors.blue : Colors.red,
                  //               child: Center(
                  //                   child: _checkStart(i + 1) == '(true)' ||
                  //                           _checkEnd(i + 1) == '(true)'
                  //                       ? Text(
                  //                           '${i + 1}',
                  //                           style: TextStyle(
                  //                             color: Colors.white,
                  //                           ),
                  //                         )
                  //                       : Text(
                  //                           ' ',
                  //                           style: TextStyle(
                  //                             color: Colors.white,
                  //                           ),
                  //                         )),
                  //             ),
                  //           ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ))
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
            )
        : Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            strokeWidth: 50,
          )));
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
      setState(() {
        total = _slice.last["end"];
      });

      for (var element in _list) {
        _break.add(element.indexOf('﴿') - 2);
      }
    });
    _slice.forEach((e) {
      _wordID.add(e['word_id']);
    });
    _wordID.forEach((element) {
      getText(element);
    });
    print(word);
    print('[${_width.length}/ ${_slice.length} loaded]');
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

  // _checkStart(int i) {
  //   var a = _slice.where((element) => element['start'] == i);
  //   var b = a.map((e) => e['start'] == i);
  //   return b.toString();
  // }
  //
  // _checkEnd(int i) {
  //   var a = _slice.where((element) => element['end'] == i);
  //   var b = a.map((e) => e['end'] == i);
  //   return b.toString();
  // }

  Future<void> getText(element) async {
    await wordText
        .where('id', isEqualTo: element.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          word.add(doc["text"].trim());
        });
      }
    });
  }
}
