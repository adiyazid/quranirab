import 'dart:convert';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';

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
  late var loaded;

  String page = "1";

  @override
  void initState() {
    loaded = true;
    getData();
    Future.delayed(Duration(milliseconds: 3000), cancelLoad);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Scaffold(
            appBar: AppBar(
              title: Consumer<AyaNumber>(builder: (context, number, child) {
                return Text(loaded ? 'No data...' : number.data);
              }),
            ),
            body: SingleChildScrollView(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _list.length < 7
                              ? MediaQuery.of(context).size.width * 0.16
                              : MediaQuery.of(context).size.width * 0.1),
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
                                          index < _list[0].split(' ').length + 1
                                      ? Text(_list.join().split('')[index],
                                          style: TextStyle(
                                            fontFamily: 'MeQuran2',
                                            fontSize: 30,
                                          ))
                                      : Text(
                                          ' ${_list.join().split('')[index]} ${_ayaNumber[index != _list.join().split('').length - 1 ? nums! - 1 : nums!]}',
                                          style: TextStyle(
                                            fontFamily: 'MeQuran2',
                                            fontSize: 30,
                                          )),
                                  onTap: () {
                                    for (var element in _slice) {
                                      if (index + 1 >= element['start'] &&
                                          index + 1 <= element['end']) {
                                        getCategoryName(element['word_id']);
                                        print(index);
                                        loaded = false;
                                        Provider.of<AyaNumber>(context,
                                                listen: false)
                                            .updateValue(
                                                'Waiting to retrieve data...');
                                      }
                                    }
                                  }),
                          ]),
                    ),
                    for (int i = 0; i < _list.length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            _list[i],
                            style: TextStyle(fontFamily: 'MeQuran2'),
                          ),
                          // Spacer(),
                          // Text(
                          //   _frontWord[i],
                          //   style: TextStyle(fontFamily: 'MeQuran2'),
                          // ),
                          // Spacer(),
                          // Text(
                          //   _lastWord[i],
                          //   style: TextStyle(fontFamily: 'MeQuran2'),
                          // ),
                          Spacer(),
                        ],
                      ),
                  ],
                ),
              ),
            )))
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<void> getData() async {
    ///get B
    var n = 0;
    await FirebaseFirestore.instance
        .collection('quran_texts')
        .orderBy('created_at')
        .where('medina_mushaf_page_id', isEqualTo: page)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _list.add(doc["text"].substring(0, doc["text"].length - 3));
          _ayaNumber.add(doc["text"].substring(doc["text"].length - 4));
          _frontWord.add(doc["text"].substring(0, 1));
          _lastWord.add(_list[n]
              .trim()
              .substring(_list[n].length - 3, _list[n].length - 2));
          for (int i = 0; i < doc["text"].split('').length; i++) {
            if (doc["text"].split('')[i].contains('ﳁ')) {
              // _list.removeAt(n);
              // _list.insert(n, doc["text"].substring(0, i));
              print(
                  'row ${n + 1} column (${i + 1}/${_list[n].split('').length})');
            }
          }
          n++;
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
        .where('id', isEqualTo: page)
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
          Provider.of<AyaNumber>(context, listen: false)
              .updateValue(doc["tname"].trim());
        } else {
          null;
        }
      }
    });
  }

  checkAya(index) {
    var length = _list.join().split('').length;
    var total = _list.length - 1;
    var lengthAya1 = _list[0].split(' ').length;
    if (index != length &&
            _list.join().split('')[index != 0 ? index - 1 : index] !=
                _lastWord[nums!] ||
        _list.join().split('')[index < length - 2 ? index + 2 : index] !=
            _frontWord[nums! < total ? nums! + 1 : nums!]) {
      return true;
    }
    if (nums! < total && index > lengthAya1) {
      nums = nums! + 1;
    }
    return false;
  }
}
