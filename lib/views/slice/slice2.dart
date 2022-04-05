import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/language.provider.dart';

import '../../widget/detail.words.popup.dart';

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

  late List? list;

  @override
  void initState() {
    loadProvider();
    list = Provider.of<AyaProvider>(context, listen: false).list!;
    getData(widget.page);
    Future.delayed(Duration(milliseconds: 3000), cancelLoad);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return !loading
        ? Consumer<AyaProvider>(builder: (context, aya, child) {
            checkRebuilt(nums);
            return aya.list!.isNotEmpty
                ? Scaffold(
                    body: SingleChildScrollView(
                        child: Center(
                    child: aya.breakIndex!.isNotEmpty
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
                                          index < aya.breakIndex!.length;
                                          index++)
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int i = 0 + index != 0
                                                      ? aya.breakIndex![
                                                          index - 1]
                                                      : 0;
                                                  i < aya.breakIndex![index];
                                                  i++)
                                                checkAya(aya.slice![i].end,
                                                        index)
                                                    ? Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Consumer<AyaProvider>(
                                                              builder: (context,
                                                                  aya, child) {
                                                            return InkWell(
                                                                onTap: () {
                                                                  Provider.of<AyaProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getCategoryName(
                                                                          aya.slice![i]
                                                                              .wordId,
                                                                          Provider.of<LangProvider>(context, listen: false).langId);
                                                                  showPopover(
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xffFFF3CA),
                                                                    context:
                                                                        context,
                                                                    transitionDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                200),
                                                                    bodyBuilder: (context) => ListItems(aya
                                                                        .list!
                                                                        .join()
                                                                        .split(
                                                                            '')
                                                                        .getRange(
                                                                            aya.slice![i].start -
                                                                                1,
                                                                            aya.slice![i].end)
                                                                        .join()),
                                                                    onPop: () {
                                                                      nums = 0;
                                                                      Provider.of<AyaProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .clear();
                                                                    },
                                                                    direction:
                                                                        PopoverDirection
                                                                            .bottom,
                                                                    width: 450,
                                                                    height: 400,
                                                                    arrowHeight:
                                                                        15,
                                                                    arrowWidth:
                                                                        30,
                                                                  );
                                                                },
                                                                child: Text(
                                                                    aya.list!
                                                                        .join()
                                                                        .split(
                                                                            '')
                                                                        .getRange(
                                                                            aya.slice![i].start -
                                                                                1,
                                                                            aya
                                                                                .slice![
                                                                                    i]
                                                                                .end)
                                                                        .join(),
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'MeQuran2',
                                                                      fontSize:
                                                                          aya.value,
                                                                      color: aya.getColor(aya
                                                                          .slice![
                                                                              i]
                                                                          .wordId),
                                                                      // aya.getBoolean(_slice[i]['start'] - 1)
                                                                      //     ? aya.getColor(_slice[i]['word_id'])
                                                                      //     : Colors.black)),
                                                                    )));
                                                          }),
                                                          aya.list!
                                                                          .join()
                                                                          .split(
                                                                              '')
                                                                          .length -
                                                                      aya
                                                                          .slice![
                                                                              i]
                                                                          .end <
                                                                  3
                                                              ? Text(
                                                                  " ${aya.list!.join().split('').length - aya.slice![i].end < 3 ? _ayaNumber.last : ""}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'MeQuran2',
                                                                    fontSize: Provider.of<AyaProvider>(
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
                                                              builder: (context,
                                                                  aya, child) {
                                                            return InkWell(
                                                              child: Text(
                                                                aya.list!
                                                                    .join()
                                                                    .split('')
                                                                    .getRange(
                                                                        aya.slice![i].start -
                                                                            1,
                                                                        aya.slice![i]
                                                                            .end)
                                                                    .join(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'MeQuran2',
                                                                    fontSize: aya
                                                                        .value,
                                                                    color: aya.getColor(aya
                                                                        .slice![
                                                                            i]
                                                                        .wordId)),
                                                              ),
                                                              onTap: () {
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getCategoryName(
                                                                        aya
                                                                            .slice![
                                                                                i]
                                                                            .wordId,
                                                                        Provider.of<LangProvider>(context,
                                                                                listen: false)
                                                                            .langId);
                                                                showPopover(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xffFFF3CA),
                                                                  context:
                                                                      context,
                                                                  transitionDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              200),
                                                                  bodyBuilder:
                                                                      (context) {
                                                                    return ListItems(aya
                                                                        .list!
                                                                        .join()
                                                                        .split(
                                                                            '')
                                                                        .getRange(
                                                                            aya.slice![i].start -
                                                                                1,
                                                                            aya.slice![i].end)
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
                                                                  arrowHeight:
                                                                      15,
                                                                  arrowWidth:
                                                                      30,
                                                                );
                                                              },
                                                            );
                                                          }),
                                                          Text(
                                                            "${_ayaNumber[nums! - 1]} ",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2',
                                                              fontSize:
                                                                  fontData.size,
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
                  )))
                : Center(child: Text('Loading Aya..'));
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
              // _list.add('${doc["text"].substring(0, i)}');
              _ayaNumber.add(doc["text"].substring(i));
              _ayaPosition.add(prev + i - 1);
              prev = prev + i;
            }
          }
          // for (int i = 0; i < text.split('').length; i++) {
          //   if (text.split('')[i] == '﴿') {
          //     _break.add(
          //         '${text.split('').getRange(0, i).join()} ${text.split('').getRange(i + 3, text.split('').length).join().trim()}');
          //   }
          // }
        });
      }
      // for (int i = 0;
      //     i < _list.join().replaceAll('', '').split('').length;
      //     i++) {
      //   select.add(false);
      // }
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
    var total = list!.length - 1;
    var lengthAya1 = list![0].split(' ').length;
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

  Future<void> loadProvider() async {
    await Provider.of<AyaProvider>(context, listen: false).readJsonData();
    await Provider.of<AyaProvider>(context, listen: false).readSliceData();
    await Provider.of<AyaProvider>(context, listen: false).readAya();
  }
}
