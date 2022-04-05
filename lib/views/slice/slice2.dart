import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/models/slicing.data.model.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/models/word.detail.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/language.provider.dart';

class Slice2 extends StatefulWidget {
  final String page;

  const Slice2(this.page, {Key? key}) : super(key: key);

  @override
  _Slice2State createState() => _Slice2State();
}

class _Slice2State extends State<Slice2> {
  CollectionReference quranText =
      FirebaseFirestore.instance.collection('quran_texts');
  CollectionReference rawText =
      FirebaseFirestore.instance.collection('raw_quran_texts');

  CollectionReference wordText = FirebaseFirestore.instance.collection('words');
  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');
  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');
  final List _list = [];
  final List _break = [];
  bool loading = true;
  var word = [];
  final category = [];
  var totalLine = 0;
  final _ayaNumber = [];
  final _ayaPosition = [];
  List<bool> select = [];

  int? length;
  bool hover = false;
  GlobalKey key = GlobalKey();

  double all = 0;

  int? nums = 0;

  @override
  void initState() {
    Provider.of<AyaProvider>(context, listen: false).readJsonData();
    Provider.of<AyaProvider>(context, listen: false).readSliceData();
    getData(widget.page);
    Future.delayed(Duration(milliseconds: 3000), cancelLoad);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    checkRebuilt(nums);
    return !loading
        ? Consumer<AyaProvider>(builder: (context, aya, child) {
            List<SlicingDatum> _slice = aya.slice ?? <SlicingDatum>[];
            print(_slice);
            List<int> _breakIndex = aya.breakIndex ?? <int>[];
            return Scaffold(
                body: SingleChildScrollView(
                    child: Center(
              child: _breakIndex.isNotEmpty
                  ? Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Visibility(
                        //   visible: _visible,
                        //   child: Align(
                        //     alignment: Alignment.topLeft,
                        //     child: SizedBox(
                        //       height: MediaQuery.of(context).size.height,
                        //       width: MediaQuery.of(context).size.height * 0.33,
                        //       child: Container(
                        //         color: themeProvider.isDarkMode
                        //             ? const Color(0xff9A9A9A)
                        //             : const Color(0xffFFF5EC),
                        //         child: Container(
                        //           width: MediaQuery.of(context).size.width * 0.33,
                        //           decoration: BoxDecoration(
                        //             border: Border.all(
                        //                 color: (themeProvider.isDarkMode)
                        //                     ? const Color(0xffffffff)
                        //                     : const Color(0xffFFB55F)),
                        //             color: (themeProvider.isDarkMode)
                        //                 ? const Color(0xff808ba1)
                        //                 : const Color(0xfffff3ca),
                        //           ),
                        //           child: MoreOptionsList(
                        //             surah: 'Straight',
                        //             nukKalimah: 'c',
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Column(
                              children: [
                                for (int index = 0;
                                    index < _breakIndex.length;
                                    index++)
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0 + index != 0
                                                ? _breakIndex[index - 1]
                                                : 0;
                                            i < _breakIndex[index];
                                            i++)
                                          checkAya(_slice[i].end, index)
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          Provider.of<AyaProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .getCategoryName(
                                                                  _slice[i]
                                                                      .wordId,
                                                                  Provider.of<LangProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .langId);
                                                          showPopover(
                                                            backgroundColor:
                                                                Color(
                                                                    0xffFFF3CA),
                                                            context: context,
                                                            transitionDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        200),
                                                            bodyBuilder: (context) =>
                                                                ListItems(_list
                                                                    .join()
                                                                    .split('')
                                                                    .getRange(
                                                                        _slice[i].start -
                                                                            1,
                                                                        _slice[i]
                                                                            .end)
                                                                    .join()),
                                                            onPop: () {
                                                              nums = 0;
                                                              Provider.of<AyaProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .clear();
                                                            },
                                                            direction:
                                                                PopoverDirection
                                                                    .bottom,
                                                            width: 450,
                                                            height: 400,
                                                            arrowHeight: 15,
                                                            arrowWidth: 30,
                                                          );
                                                        },
                                                        child: Text(
                                                            _list
                                                                .join()
                                                                .split('')
                                                                .getRange(
                                                                    _slice[i]
                                                                            .start -
                                                                        1,
                                                                    _slice[i]
                                                                        .end)
                                                                .join(),
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2',
                                                              fontSize:
                                                                  aya.value,
                                                              color: aya.getColor(
                                                                  _slice[i]
                                                                      .wordId),
                                                              // aya.getBoolean(_slice[i]['start'] - 1)
                                                              //     ? aya.getColor(_slice[i]['word_id'])
                                                              //     : Colors.black)),
                                                            ))),
                                                    _list
                                                                    .join()
                                                                    .split('')
                                                                    .length -
                                                                _slice[i].end <
                                                            3
                                                        ? Text(
                                                            " ${_list.join().split('').length - _slice[i].end < 3 ? _ayaNumber.last : ""}",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2',
                                                              fontSize: Provider
                                                                      .of<AyaProvider>(
                                                                          context)
                                                                  .value,
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Consumer<AyaProvider>(
                                                        builder: (context, aya,
                                                            child) {
                                                      return InkWell(
                                                        child: Text(
                                                          _list
                                                              .join()
                                                              .split('')
                                                              .getRange(
                                                                  _slice[i]
                                                                          .start -
                                                                      1,
                                                                  _slice[i].end)
                                                              .join(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2',
                                                              fontSize:
                                                                  aya.value,
                                                              color: aya.getColor(
                                                                  _slice[i]
                                                                      .wordId)),
                                                        ),
                                                        onTap: () {
                                                          Provider.of<AyaProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .getCategoryName(
                                                                  _slice[i]
                                                                      .wordId,
                                                                  Provider.of<LangProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .langId);
                                                          showPopover(
                                                            backgroundColor:
                                                                Color(
                                                                    0xffFFF3CA),
                                                            context: context,
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                            bodyBuilder:
                                                                (context) {
                                                              return ListItems(_list
                                                                  .join()
                                                                  .split('')
                                                                  .getRange(
                                                                      _slice[i]
                                                                              .start -
                                                                          1,
                                                                      _slice[i]
                                                                          .end)
                                                                  .join());
                                                            },
                                                            onPop: () {
                                                              nums = 0;
                                                              Provider.of<AyaProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .clear();
                                                            },
                                                            direction:
                                                                PopoverDirection
                                                                    .bottom,
                                                            width: 450,
                                                            height: 400,
                                                            arrowHeight: 15,
                                                            arrowWidth: 30,
                                                          );
                                                        },
                                                      );
                                                    }),
                                                    Text(
                                                      "${_ayaNumber[nums! - 1]} ",
                                                      style: TextStyle(
                                                        fontFamily: 'MeQuran2',
                                                        fontSize: fontData.size,
                                                      ),
                                                    )
                                                  ],
                                                )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  : Container(),
            )));
          })
        : Scaffold(body: Center(child: Text('Loading...')));
  }

  Future<void> getData(String page) async {
    ///todo: get aya
    var prev = 0;

    // List<int> indexBreak = [];
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
      // for (int i = 0; i < _break.join().split('').length; i++) {
      //   if (_break.join().split('')[i] == 'b') {
      //     indexBreak.add(i);
      //   }
      // }
      // print(indexBreak);
      // setState(() {
      //   length = indexBreak.length;
      // });
    });

    ///load list of boolean
    Provider.of<AyaProvider>(context, listen: false).loadList(select);

    ///getTotalSlice

    ///todo:split slice data that contain breakpoint index
    // var indexB = 0;
    // var i = 0;
    //
    // for (var element in _slice) {
    //   if (indexBreak[i] >= element['start'] &&
    //       indexBreak[i] <= element['end']) {
    //     _breakIndex.add(indexB);
    //     i++;
    //   } else {
    //     if (indexBreak[i] >= _slice.last['end'] &&
    //         _breakIndex.length != indexBreak.length) {
    //       _breakIndex.add(_slice.length);
    //     }
    //     indexB++;
    //   }
    // }
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

  checkAya(index, lineIndex) {
    var total = _list.length - 1;
    var lengthAya1 = _list[0].split(' ').length;
    var a = _ayaPosition.contains(index - 1);
    var b = _ayaPosition.contains(index);
    var c = _ayaPosition.contains(index + 1);

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

  ///todo: insert break line data entry

  ///todo:avoid rebuild ayat number
  void checkRebuilt(no) {
    if (no != 0) nums = 0;
  }
}

class ListItems extends StatefulWidget {
  String text;

  ListItems(this.text, {Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3), loading);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Scrollbar(
            child: Consumer<AyaProvider>(builder: (context, aya, child) {
              List<WordDetail> word = aya.getWordTypeList() ?? <WordDetail>[];
              List<WordDetail> name = aya.getWordNameList() ?? <WordDetail>[];

              for (var item in name) {
                for (var element in word) {
                  if (element.categoryId == item.categoryId) {
                    if (item.categoryId == 68) {}
                    item.type = element.type;
                  }
                }
              }
              name.sort((a, b) => a.categoryId!.compareTo(b.categoryId!));
              var newPosition;
              var newPosition2;
              WordDetail old;
              WordDetail old2;
              for (int i = 0; i < name.length; i++) {
                if (name[i].categoryId == 68) {
                  newPosition = i + 1;
                }
                if (name[i].categoryId == 429) {
                  newPosition2 = i + 1;
                }
                if (name[i].categoryId == 495) {
                  old2 = name[i];
                  name.removeAt(i);
                  name.insertAll(newPosition2, [old2]);
                }
                if (name[i].id == 1426) {
                  old = name[i];
                  name.removeAt(i);
                  name.insertAll(newPosition, [old]);
                }
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(8),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  widget.text,
                                  style: TextStyle(
                                      color: checkColor(aya.category),
                                      fontSize: 24,
                                      fontFamily: 'MeQuran2'),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: name.last.type != "label"
                          ? name.length - 1
                          : name.length,
                      itemBuilder: (BuildContext context, int index) {
                        return name.isNotEmpty
                            ? Row(
                                children: [
                                  name[index + 1 < name.length
                                                      ? index + 1
                                                      : index]
                                                  .type !=
                                              'label' &&
                                          name[index + 1 < name.length
                                                      ? index + 1
                                                      : index]
                                                  .type !=
                                              'main-label'
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 64,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(8),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${index + 1 < name.length ? name[index + 1].name : ''}",
                                                    style: TextStyle(
                                                        fontFamily: 'MeQuran2',
                                                        fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ),
                                          ),
                                        )
                                      : index == 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 64,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(8),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${name[index].name}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'MeQuran2',
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                  Spacer(),
                                  index == 0
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(8),
                                            ),
                                            height: 64,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'نوع الكلمة',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  if (name[index].type == 'label' ||
                                      name[index].type == 'main-label')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  8),
                                        ),
                                        child: Center(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${name[index].name}",
                                                style: TextStyle(
                                                    fontSize: checkMainFontSize(
                                                        name[index].id),
                                                    fontFamily: 'MeQuran2',
                                                    color: checkMainColor(
                                                        name[index].id)),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ),
                                    )
                                ],
                              )
                            : Container();
                      },
                    ),
                  ),
                ],
              );
            }),
          )
        : Center(child: CircularProgressIndicator());
  }

  void loading() {
    setState(() {
      loaded = true;
    });
  }

  checkColor(String category) {
    if (category == 'Ism') return Colors.blue;
    if (category == 'Harf') return Colors.red;
    if (category == 'Fi‘l') return Colors.green;
    return Colors.black;
  }

  checkMainColor(int? id) {
    if (id == 3) {
      return Color(0xffFF6106);
    }
    if (id == 68) {
      return Color(0xffFF29DD);
    }
    return Colors.black;
  }

  checkMainFontSize(int? id) {
    if (id == 3 || id == 68) {
      return 24;
    }
    return 20;
  }
}
