import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/language.provider.dart';

import '../../facebook/widgets/more_options_list.dart';
import '../../theme/theme_provider.dart';
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

  List<bool> select = [];

  int? length;
  bool hover = false;
  GlobalKey key = GlobalKey();

  double all = 0;

  bool _visible = false;

  @override
  void initState() {
    loadProvider();
    Future.delayed(Duration(milliseconds: 3000), cancelLoad);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return !loading
        ? Consumer<AyaProvider>(builder: (context, aya, child) {
            aya.checkRebuilt(aya.nums);
            final size = MediaQuery.of(context).size;
            final themeProvider = Provider.of<ThemeProvider>(context);
            return aya.list!.isNotEmpty
                ? Scaffold(
                    body: SingleChildScrollView(
                        child: aya.breakIndex!.isNotEmpty
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (size.width > 1400)
                                        Visibility(
                                          visible: aya.visible,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              child: Container(
                                                color: themeProvider.isDarkMode
                                                    ? const Color(0xff9A9A9A)
                                                    : const Color(0xffFFF5EC),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.33,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: (themeProvider
                                                                .isDarkMode)
                                                            ? const Color(
                                                                0xffffffff)
                                                            : const Color(
                                                                0xffFFB55F)),
                                                    color: (themeProvider
                                                            .isDarkMode)
                                                        ? const Color(
                                                            0xffa0a7b7)
                                                        : const Color(
                                                            0xfffff3ca),
                                                  ),
                                                  child: MoreOptionsList(
                                                    surah: aya.words ?? '',
                                                    nukKalimah: 'c',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 80.0),
                                        child: Column(
                                          children: [
                                            for (int index = 0;
                                                index < aya.breakIndex!.length;
                                                index++)
                                              Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    for (int i = 0 + index != 0
                                                            ? aya.breakIndex![
                                                                index - 1]
                                                            : 0;
                                                        i <
                                                            aya.breakIndex![
                                                                index];
                                                        i++)
                                                      aya.checkAya(
                                                        aya.slice![i].end,
                                                      )
                                                          ? Row(
                                                              children: [
                                                                Consumer<
                                                                        AyaProvider>(
                                                                    builder:
                                                                        (context,
                                                                            aya,
                                                                            child) {
                                                                  return aya.checkSymbol(aya
                                                                          .slice![
                                                                              i]
                                                                          .start)
                                                                      ? Row(
                                                                          children: [
                                                                            Text(" ﲿ ",
                                                                                textDirection: TextDirection.rtl,
                                                                                softWrap: true,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'MeQuran2',
                                                                                  fontSize: aya.value,
                                                                                  color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                )),
                                                                            InkWell(
                                                                              onTap: aya.visible
                                                                                  ? null
                                                                                  : () {
                                                                                      print(aya.slice![i].end);
                                                                                      Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                      aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                      if (size.width < 1400) {
                                                                                        showPopover(
                                                                                          backgroundColor: Color(0xffFFF3CA),
                                                                                          context: context,
                                                                                          transitionDuration: Duration(milliseconds: 200),
                                                                                          bodyBuilder: (context) => ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join()),
                                                                                          onPop: () {
                                                                                            Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                          },
                                                                                          direction: PopoverDirection.bottom,
                                                                                          width: 450,
                                                                                          height: 400,
                                                                                          arrowHeight: 15,
                                                                                          arrowWidth: 30,
                                                                                        );
                                                                                      } else {
                                                                                        if (mounted) {
                                                                                          setState(() {
                                                                                            aya.updateValue(i);
                                                                                            aya.set();
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    },
                                                                              child: Text(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join(),
                                                                                  textDirection: TextDirection.rtl,
                                                                                  softWrap: true,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'MeQuran2',
                                                                                    fontSize: aya.value,
                                                                                    color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                    // aya.getBoolean(_slice[i]['start'] - 1)
                                                                                    //     ? aya.getColor(_slice[i]['word_id'])
                                                                                    //     : Colors.black)),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : InkWell(
                                                                          onTap: aya.visible
                                                                              ? null
                                                                              : () {
                                                                                  print(aya.slice![i].end);
                                                                                  Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                  aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                  if (size.width < 1400) {
                                                                                    showPopover(
                                                                                      backgroundColor: Color(0xffFFF3CA),
                                                                                      context: context,
                                                                                      transitionDuration: Duration(milliseconds: 200),
                                                                                      bodyBuilder: (context) => ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join()),
                                                                                      onPop: () {
                                                                                        Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                      },
                                                                                      direction: PopoverDirection.bottom,
                                                                                      width: 450,
                                                                                      height: 400,
                                                                                      arrowHeight: 15,
                                                                                      arrowWidth: 30,
                                                                                    );
                                                                                  } else {
                                                                                    if (mounted) {
                                                                                      setState(() {
                                                                                        aya.updateValue(i);
                                                                                        aya.set();
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                },
                                                                          child: Text(
                                                                              aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join(),
                                                                              textDirection: TextDirection.rtl,
                                                                              softWrap: true,
                                                                              style: TextStyle(
                                                                                fontFamily: 'MeQuran2',
                                                                                fontSize: aya.value,
                                                                                color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                // aya.getBoolean(_slice[i]['start'] - 1)
                                                                                //     ? aya.getColor(_slice[i]['word_id'])
                                                                                //     : Colors.black)),
                                                                              )),
                                                                        );
                                                                }),
                                                                aya.list!.join().split('').length -
                                                                            aya.slice![i].end <
                                                                        3
                                                                    ? Text(
                                                                        " ${aya.list!.join().split('').length - aya.slice![i].end < 3 ? aya.ayaNumber.last : ""}",
                                                                        softWrap:
                                                                            true,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'MeQuran2',
                                                                          fontSize:
                                                                              Provider.of<AyaProvider>(context).value,
                                                                        ),
                                                                      )
                                                                    : Container()
                                                              ],
                                                            )
                                                          : Row(
                                                              children: [
                                                                Consumer<
                                                                        AyaProvider>(
                                                                    builder:
                                                                        (context,
                                                                            aya,
                                                                            child) {
                                                                  return aya.checkSymbol(aya
                                                                          .slice![
                                                                              i]
                                                                          .start)
                                                                      ? Row(
                                                                          children: [
                                                                            Text(" ﲿ ",
                                                                                textDirection: TextDirection.rtl,
                                                                                softWrap: true,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'MeQuran2',
                                                                                  fontSize: aya.value,
                                                                                  color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                  // aya.getBoolean(_slice[i]['start'] - 1)
                                                                                  //     ? aya.getColor(_slice[i]['word_id'])
                                                                                  //     : Colors.black)),
                                                                                )),
                                                                            InkWell(
                                                                              onTap: aya.visible
                                                                                  ? null
                                                                                  : () {
                                                                                      print(aya.slice![i].end);
                                                                                      Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                      aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                      if (size.width < 1400) {
                                                                                        showPopover(
                                                                                          backgroundColor: Color(0xffFFF3CA),
                                                                                          context: context,
                                                                                          transitionDuration: const Duration(milliseconds: 200),
                                                                                          bodyBuilder: (context) {
                                                                                            return ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                          },
                                                                                          onPop: () {
                                                                                            Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                          },
                                                                                          direction: PopoverDirection.bottom,
                                                                                          width: 450,
                                                                                          height: 400,
                                                                                          arrowHeight: 15,
                                                                                          arrowWidth: 30,
                                                                                        );
                                                                                      } else {
                                                                                        if (mounted) {
                                                                                          setState(() {
                                                                                            aya.updateValue(i);
                                                                                            aya.set();
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    },
                                                                              child: Text(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join(),
                                                                                  textDirection: TextDirection.rtl,
                                                                                  softWrap: true,
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'MeQuran2',
                                                                                    fontSize: aya.value,
                                                                                    color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                    // aya.getBoolean(_slice[i]['start'] - 1)
                                                                                    //     ? aya.getColor(_slice[i]['word_id'])
                                                                                    //     : Colors.black)),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : InkWell(
                                                                          onTap: aya.visible
                                                                              ? null
                                                                              : () {
                                                                                  print(aya.slice![i].end);
                                                                                  Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                  aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                  if (size.width < 1400) {
                                                                                    showPopover(
                                                                                      backgroundColor: Color(0xffFFF3CA),
                                                                                      context: context,
                                                                                      transitionDuration: const Duration(milliseconds: 200),
                                                                                      bodyBuilder: (context) {
                                                                                        return ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                      },
                                                                                      onPop: () {
                                                                                        Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                      },
                                                                                      direction: PopoverDirection.bottom,
                                                                                      width: 450,
                                                                                      height: 400,
                                                                                      arrowHeight: 15,
                                                                                      arrowWidth: 30,
                                                                                    );
                                                                                  } else {
                                                                                    if (mounted) {
                                                                                      setState(() {
                                                                                        aya.updateValue(i);
                                                                                        aya.set();
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                },
                                                                          child: Text(
                                                                              aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join().replaceAll('ﲿ', ''),
                                                                              softWrap: true,
                                                                              style: TextStyle(
                                                                                fontFamily: 'MeQuran2',
                                                                                fontSize: aya.value,
                                                                                color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                              )),
                                                                        );
                                                                }),
                                                                Text(
                                                                  "${aya.ayaNumber[aya.nums != 0 ? aya.nums - 1 : aya.nums]} ",
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'MeQuran2',
                                                                    fontSize:
                                                                        fontData
                                                                            .size,
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                  ],
                                                ),
                                              ),
                                            // for (int i = 0;
                                            //     i < aya.ayaPosition.length;
                                            //     i++)
                                            //   Text(
                                            //     aya.ayaPosition[i].toString(),
                                            //     style: TextStyle(
                                            //         fontFamily: 'MeQuran2'),
                                            //   )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container()))
                : Center(child: Text('Loading Aya..'));
          })
        : Scaffold(body: Center(child: Text('Loading...')));
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

  ///todo: insert break line data entry

  ///todo:avoid rebuild ayat number

  Future<void> loadProvider() async {
    await Provider.of<AyaProvider>(context, listen: false).readJsonData();
    await Provider.of<AyaProvider>(context, listen: false).readSliceData();
    await Provider.of<AyaProvider>(context, listen: false).readAya();
  }
}
