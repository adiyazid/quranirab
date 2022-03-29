import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/views/auth/landing.page.dart';

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

  int? nums = 0;

  final _ayaNumber = [];
  late var loaded;
  final _ayaPosition = [];

  List<bool> select = [];

  var _breakIndex = [];

  int? length;

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
              leading: IconButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => DummyPage()),
                      (route) => false),
                  icon: Icon(Icons.arrow_back_ios)),
              title: Consumer<AyaProvider>(builder: (context, number, child) {
                return Text(loaded ? 'No data...' : number.category);
              }),
            ),
            body: SingleChildScrollView(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: _breakIndex.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int index = 0; index < length!; index++)
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0 + index != 0
                                          ? _breakIndex[index - 1]
                                          : 0;
                                      i < _breakIndex[index];
                                      i++)
                                    MouseRegion(
                                        onEnter: (e) {
                                          loaded = false;
                                          nums = 0;
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .getCategoryName(
                                                  _slice[i]['word_id']);
                                        },
                                        child: checkAya(_slice[i]['end'])
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Consumer<AyaProvider>(builder:
                                                      (context, aya, child) {
                                                    return InkWell(
                                                      onTap: () {},
                                                      child: Text(
                                                          _list
                                                              .join()
                                                              .split('')
                                                              .getRange(
                                                                  _slice[i]['start'] -
                                                                      1,
                                                                  _slice[i]
                                                                      ['end'])
                                                              .join(),
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2',
                                                              fontSize: 20,
                                                              color: aya.getBoolean(_slice[i]['start'] - 1)
                                                                  ? aya.getColor(i)
                                                                  : Colors.black)),
                                                    );
                                                  }),
                                                  _list
                                                                  .join()
                                                                  .split('')
                                                                  .length -
                                                              _slice[i]['end'] <
                                                          3
                                                      ? Text(
                                                          " ${_list.join().split('').length - _slice[i]['end'] < 3 ? _ayaNumber.last : ""}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2',
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      : Container()
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      _list
                                                          .join()
                                                          .split('')
                                                          .getRange(
                                                              _slice[i][
                                                                      'start'] -
                                                                  1,
                                                              _slice[i]['end'])
                                                          .join(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'MeQuran2',
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                  Text(
                                                    "${_ayaNumber[nums! - 1]} ",
                                                    style: TextStyle(
                                                        fontFamily: 'MeQuran2',
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 100,
                          ),
                          // for (int i = 0; i < _break.length; i++)
                          // Text(
                          //   _break[i],
                          //   style: TextStyle(
                          //       fontFamily: 'MeQuran2',
                          //       fontSize: 20,
                          //       color: Colors.black),
                          // ),
                          // Text(
                          //   _break.join().split(' ').toString(),
                          //   style: TextStyle(
                          //       fontFamily: 'MeQuran2',
                          //       fontSize: 20,
                          //       color: Colors.black),
                          // ),
                          // Text(
                          //   _list[0].split(' ').toString(),
                          //   style: TextStyle(
                          //       fontFamily: 'MeQuran2',
                          //       fontSize: 20,
                          //       color: Colors.black),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: _list.join().length < 1000
                          //           ? MediaQuery.of(context).size.width * 0.16
                          //           : MediaQuery.of(context).size.width * 0.05),
                          //   child: Wrap(
                          //       alignment: WrapAlignment.center,
                          //       textDirection: TextDirection.rtl,
                          //       children: [
                          //         for (int index = 0;
                          //             index <
                          //                 _list
                          //                     .join()
                          //                     .replaceAll('', '')
                          //                     .split('')
                          //                     .length;
                          //             index++)
                          //           MouseRegion(
                          //             onExit: _ayaPosition.contains(index)
                          //                 ? null
                          //                 : (e) {
                          //                     Provider.of<AyaProvider>(context,
                          //                             listen: false)
                          //                         .updateValue(index);
                          //                   },
                          //             onEnter: _ayaPosition.contains(index)
                          //                 ? null
                          //                 : (e) {
                          //                     Provider.of<AyaProvider>(context,
                          //                             listen: false)
                          //                         .updateValue(index);
                          //                     loaded = false;
                          //                     for (var element in _slice) {
                          //                       if (index + 1 >= element['start'] &&
                          //                           index + 1 <= element['end']) {
                          //                         Provider.of<AyaProvider>(context,
                          //                                 listen: false)
                          //                             .getCategoryName(
                          //                                 element['word_id']);
                          //                       }
                          //                     }
                          //                   },
                          //             child: InkWell(
                          //                 child: checkAya(index)
                          //                     ? Consumer<AyaProvider>(
                          //                         builder: (context, aya, child) {
                          //                         return Text(
                          //                             _list.join().split('')[index],
                          //                             style: TextStyle(
                          //                                 fontFamily: 'MeQuran2',
                          //                                 fontSize: 30,
                          //                                 color: aya.getBoolean(index)
                          //                                     ? aya.getColor(Provider
                          //                                             .of<AyaProvider>(
                          //                                                 context,
                          //                                                 listen:
                          //                                                     false)
                          //                                         .category)
                          //                                     : Colors.black));
                          //                       })
                          //                     : Text(
                          //                         '${_list.join().split('')[index]}${_ayaNumber[index != _list.join().split('').length - 1 ? nums! - 1 : nums!]} ',
                          //                         style: TextStyle(
                          //                           fontFamily: 'MeQuran2',
                          //                           fontSize: 30,
                          //                         )),
                          //                 onTap: _ayaPosition.contains(index)
                          //                     ? null
                          //                     : () {}),
                          //           ),
                          //       ]),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .previousPage();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Slice2()),
                                        (route) => false);
                                  },
                                  child: Text('Previous page')),
                              Spacer(),
                              Consumer<AyaProvider>(
                                  builder: (context, number, child) {
                                return Text(
                                  'Page ${number.page}',
                                  style: TextStyle(fontSize: 30),
                                );
                              }),
                              Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .nextPage();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Slice2()),
                                        (route) => false);
                                  },
                                  child: Text('Next page')),
                              Spacer(),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ),
            )))
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<void> getData() async {
    String page = '${Provider.of<AyaProvider>(context, listen: false).page}';

    ///todo: get aya
    var prev = 0;

    List<int> indexBreak = [];
    await FirebaseFirestore.instance
        .collection('quran_texts')
        .orderBy('created_at')
        .where('medina_mushaf_page_id', isEqualTo: page)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String text = doc["text1"];
        setState(() {
          for (int i = 0; i < doc["text"].split('').length; i++) {
            if (doc["text"].split('')[i].contains('ﳁ')) {
              _list.add('${doc["text"].substring(0, i)}');
              _ayaNumber.add(doc["text"].substring(i));
              _ayaPosition.add(prev + i - 1);
              prev = prev + i;
            }
          }
          for (int i = 0; i < text.split('').length; i++) {
            if (text.split('')[i] == '﴿') {
              _break.add(
                  '${text.split('').getRange(0, i).join()} ${text.split('').getRange(i + 3, text.split('').length).join().trim()}');
            }
          }
        });
      }
      for (int i = 0;
          i < _list.join().replaceAll('', '').split('').length;
          i++) {
        select.add(false);
      }
      // //todo:check line per pages
      // for (int i = 0; i < _break.length; i++) {
      //   var bool = _break[i].contains('b');
      //   if (bool == true) {
      //     totalLine++;
      //   }
      // }
      //todo:check breakpoint index
      // for (int i = 0; i < _break.join().trim().split('').length; i++) {
      //   if (_break.join().trim().split('')[i] == 'b') {
      //     indexBreak.add(i);
      //   }}
      for (int i = 0; i < _break.join().split('').length; i++) {
        if (_break.join().split('')[i] == 'b') {
          indexBreak.add(i);
        }
      }
      print(indexBreak);
      setState(() {
        length = indexBreak.length;
      });
    });

    ///load list of boolean
    Provider.of<AyaProvider>(context, listen: false).loadList(select);

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
    for (int i = 0; i < _slice.length; i++) {
      if (_slice[i != _slice.length - 1 ? i + 1 : i]['start'] -
              _slice[i]['end'] ==
          1) {
        print('data fix');
      } else {
        var a = _slice[i != _slice.length - 1 ? i + 1 : i]['start'] -
            _slice[i]['end'];
        setState(() {
          _slice.setAll(i, [
            {
              'start': _slice[i]['start'],
              'end': i != _slice.length - 1
                  ? _slice[i]['end'] + a - 1
                  : _slice[i]['end'],
              'word_id': _slice[i]['word_id']
            }
          ]);
        });
      }
    }

    ///todo:split slice data that contain breakpoint index
    var indexB = 0;
    var i = 0;

    for (var element in _slice) {
      if (indexBreak[i] >= element['start'] &&
          indexBreak[i] <= element['end']) {
        _breakIndex.add(indexB);
        i++;
      } else {
        if (indexBreak[i] >= _slice.last['end'] &&
            _breakIndex.length != indexBreak.length) {
          _breakIndex.add(_slice.length);
        }
        indexB++;
      }
    }
    print(_breakIndex);
  }

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

  void cancelLoad() {
    setState(() {
      loading = false;
    });
  }

  checkAya(index) {
    var total = _list.length - 1;
    var lengthAya1 = _list[0].split(' ').length;
    var a = _ayaPosition.contains(index - 1);
    var b = _ayaPosition.contains(index);
    var c = _ayaPosition.contains(index + 1);
    // print(index);
    // print(_list.join().split('').length);
    if (!a) {
      return true;
    }
    if (!a && !b) {
      return true;
    }
    if (!a && !b && !c) {
      return true;
    }
    if (nums! < total && index > lengthAya1) {
      nums = nums! + 1;
    }
    return false;
  }
}
