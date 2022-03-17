import 'dart:convert';

import 'package:arabic_numbers/arabic_numbers.dart';
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
  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');
  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');
  final List _list = [];

  var _positionW;
  var total = 0;
  var totalSlice = 10;

  List _slice = [];

  final List _break = [];
  bool loading = true;

  var word = [];
  final category = [];

  var totalLine = 0;
  ArabicNumbers arabicNumber = ArabicNumbers();

  bool hoverH = false;
  bool hoverI = false;
  bool hoverF = false;

  int? nums = 0;

  var _ayaNumber = [];

  var _lastWord = [];

  var _frontWord = [];

  @override
  void initState() {
    getData();
    Future.delayed(Duration(milliseconds: 3000), cancelLoad);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Scaffold(
            appBar: AppBar(
              title: Text('${_positionW ?? ''}'),
            ),
            body: SingleChildScrollView(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     TextButton(
                    //         onPressed: () => setState(() {
                    //               hoverH = !hoverH;
                    //             }),
                    //         child: Text('Harf')),
                    //     TextButton(
                    //         onPressed: () => setState(() {
                    //               hoverI = !hoverI;
                    //             }),
                    //         child: Text('Ism')),
                    //     TextButton(
                    //         onPressed: () => setState(() {
                    //               hoverF = !hoverF;
                    //             }),
                    //         child: Text('Fi‘l'))
                    //   ],
                    // ),
                    // category.length == word.length
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(top: 38.0),
                    //         child: SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.4,
                    //           child: Wrap(
                    //             textDirection: TextDirection.rtl,
                    //             alignment: WrapAlignment.center,
                    //             children: [
                    //               for (int i = 0; i < word.length; i++)
                    //                 InkWell(
                    //                   onTap: () => setState(() {
                    //                     _positionW = '${category[i]}';
                    //                   }),
                    //                   child: Padding(
                    //                     padding:
                    //                         const EdgeInsets.only(top: 8.0),
                    //                     child: Row(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       children: [
                    //                         Flexible(
                    //                             child: Padding(
                    //                           padding: EdgeInsets.only(
                    //                               left: category[i] == 'Ism' ||
                    //                                       word[word.length >
                    //                                                   i + 1
                    //                                               ? i + 1
                    //                                               : i] ==
                    //                                           'ﻭ' ||
                    //                                       category[
                    //                                               category.length >
                    //                                                       i + 1
                    //                                                   ? i + 1
                    //                                                   : i] ==
                    //                                           'Fi‘l'
                    //                                   ? 8.0
                    //                                   : 0),
                    //                           child: Text(
                    //                             '${word[i]}',
                    //                             textAlign: TextAlign.center,
                    //                             style: TextStyle(
                    //                               fontFamily: 'MeQuran2',
                    //                               fontSize: 30,
                    //                               color:
                    //                                   checkColor(category[i]),
                    //                             ),
                    //                           ),
                    //                         )),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 )
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     : CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: Wrap(
                          alignment: WrapAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: [
                            for (int index = 0;
                                index <
                                    _list
                                        .join()
                                        .replaceAll('', '')
                                        .split('')
                                        .length;
                                index++)
                              InkWell(
                                child: checkAya(index) &&
                                            index !=
                                                _list
                                                        .join()
                                                        .replaceAll('', '')
                                                        .split('')
                                                        .length -
                                                    1 ||
                                        index < 10
                                    ? Text(
                                        _list
                                            .join()
                                            .replaceAll('', '')
                                            .split('')[index],
                                        style: TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 30,
                                        ))
                                    : Text(
                                        '${_list.join().replaceAll('', '').split('')[index]}${_ayaNumber[index != _list.join().split('').length - 1 ? nums! - 1 : nums!]}',
                                        style: TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 30,
                                        )),
                                onTap: checkAya(index)
                                    ? () {
                                        _slice.any((element) {
                                          if (index + 1 >= element['start'] &&
                                              index + 1 <= element['end']) {
                                            getCategoryName(element['word_id']);
                                            _positionW =
                                                'Waiting to retrieve data...';
                                          }
                                          return false;
                                        });
                                      }
                                    : null,
                              ),
                          ]),
                    ),
                    for (int i = 0; i < _ayaNumber.length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_ayaNumber[i],
                              style: TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize: 30,
                              )),
                          Text(_frontWord[i],
                              style: TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize: 30,
                              )),
                          Text(_lastWord[i],
                              style: TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize: 30,
                              )),
                        ],
                      ),
                    // for (int index = 0; index < _slice.length; index++)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       Text('start ${_slice[index]['start']}'),
                    //       Text('end ${_slice[index]['end']}')
                    //     ],
                    //   )
                  ],
                ),
              ),
            )))
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<void> getData() async {
    ///get B
    await FirebaseFirestore.instance
        .collection('quran_texts')
        .where('medina_mushaf_page_id', isEqualTo: '1')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _list.add(doc["text"].substring(0, doc["text"].length - 3));
          _ayaNumber.add(doc["text"].substring(doc["text"].length - 3));
          _frontWord.add(doc["text"].substring(0, 1));
          _lastWord.add(doc["text"]
              .substring(doc["text"].length - 6, doc["text"].length - 5));
        });
      }
      for (int i = 0; i < _list.length; i++) {
        if (_list.isNotEmpty) {
          setState(() {
            _break.add(_list[i].split(' ').length);
          });
        }
        var bool = _list[i].contains('b');
        if (bool == true) {
          totalLine++;
        }
      }
    });

    ///getTotalSlice
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
    });

    // /// get the word and category
    // _slice.forEach((e) {
    //   _wordID.add(e['word_id']);
    // });
    // _wordID.forEach((element) async {
    //   await getText(element);
    //   await getCategory(element);
    // });
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

  Future<void> getCategory(element) async {
    await wordRelationship
        .where('word_id', isEqualTo: element.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getMainCategory(doc["word_category_id"].trim());
      }
    });
  }

  Future<void> getMainCategory(element) async {
    await wordCategory
        .where('word_type', isEqualTo: 'main')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == element.toString()) {
          setState(() {
            category.add(doc["tname"].trim());
          });
        } else {
          null;
        }
      }
    });
  }

  void cancelLoad() {
    setState(() {
      loading = false;
    });
  }

  checkColor(category) {
    if (category == 'Ism' && hoverI == true) {
      return Colors.blueAccent;
    } else if (category == 'Harf' && hoverH == true) {
      return Colors.redAccent;
    } else if (category == 'Fi‘l' && hoverF == true) {
      return Colors.green[400];
    }
    return Colors.black;
  }

  getCategoryName(element) async {
    await wordRelationship
        .where('word_id', isEqualTo: element.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getMainCategoryName(doc["word_category_id"].trim());
      }
    });
  }

  Future<void> getMainCategoryName(trim) async {
    await wordCategory
        .where('word_type', isEqualTo: 'main')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == trim.toString()) {
          setState(() {
            _positionW = doc["tname"].trim();
          });
        } else {
          null;
        }
      }
    });
  }

  checkAya(index) {
    if (index != 279 &&
            _list
                    .join()
                    .replaceAll('', '')
                    .split('')[index != 0 ? index - 1 : index] !=
                _lastWord[nums!] ||
        _list
                .join()
                .replaceAll('', '')
                .split('')[index < 277 ? index + 2 : index] !=
            _frontWord[nums! < 6 ? nums! + 1 : nums!]) {
      return true;
    }
    if (nums! < 6 && index > 10) {
      nums = nums! + 1;
    }
    return false;
  }
}
