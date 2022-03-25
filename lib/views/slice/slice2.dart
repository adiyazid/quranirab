import 'dart:convert';

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var item in _slice)
                            MouseRegion(
                                onEnter: (e) {
                                  loaded = false;
                                  nums = 0;
                                  Provider.of<AyaProvider>(context,
                                          listen: false)
                                      .getCategoryName(item['word_id']);
                                },
                                child: checkAya(item['end'])
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Consumer<AyaProvider>(
                                              builder: (context, aya, child) {
                                            return InkWell(
                                              onTap: () {},
                                              child: Text(
                                                  _list
                                                      .join()
                                                      .split('')
                                                      .getRange(
                                                          item['start'] - 1,
                                                          item['end'])
                                                      .join(),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 20,
                                                      color: aya.getBoolean(
                                                              item['start'] - 1)
                                                          ? aya.getColor(
                                                              Provider.of<AyaProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .category)
                                                          : Colors.black)),
                                            );
                                          }),
                                          _list.join().split('').length -
                                                      item['end'] <
                                                  3
                                              ? Text(
                                                  " ${_list.join().split('').length - item['end'] < 3 ? _ayaNumber.last : ""}",
                                                  style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 20,
                                                      color: Colors.black),
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
                                                  .getRange(item['start'] - 1,
                                                      item['end'])
                                                  .join(),
                                              style: TextStyle(
                                                  fontFamily: 'MeQuran2',
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
                              Provider.of<AyaProvider>(context, listen: false)
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
                              Provider.of<AyaProvider>(context, listen: false)
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
                ),
              ),
            )))
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Future<void> getData() async {
    String page = '${Provider.of<AyaProvider>(context, listen: false).page}';

    ///get B
    var prev = 0;
    await FirebaseFirestore.instance
        .collection('quran_texts')
        .orderBy('created_at')
        .where('medina_mushaf_page_id', isEqualTo: page)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          for (int i = 0; i < doc["text"].split('').length; i++) {
            if (doc["text"].split('')[i].contains('ﳁ')) {
              _list.add(doc["text"].substring(0, i));
              _ayaNumber.add(doc["text"].substring(i));
              _ayaPosition.add(prev + i - 1);
              print(prev + i - 1);
              prev = prev + i;
            }
          }
        });
      }
      for (int i = 0;
          i < _list.join().replaceAll('', '').split('').length;
          i++) {
        select.add(false);
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
    print(index);
    print(_list.join().split('').length);
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
