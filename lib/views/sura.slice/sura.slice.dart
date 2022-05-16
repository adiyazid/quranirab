import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/language.provider.dart';

import '../../widget/more_options_list.dart';
import '../../theme/theme_provider.dart';

class SuraSlice extends StatefulWidget {
  final String page;
  final String suraId;

  const SuraSlice(this.page, this.suraId, {Key? key}) : super(key: key);

  @override
  _SuraSliceState createState() => _SuraSliceState();
}

class _SuraSliceState extends State<SuraSlice> {
  CollectionReference quranText =
      FirebaseFirestore.instance.collection('quran_texts');
  CollectionReference rawText =
      FirebaseFirestore.instance.collection('raw_quran_texts');

  CollectionReference wordText = FirebaseFirestore.instance.collection('words');
  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');
  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');

  var word = [];
  final category = [];
  var totalLine = 0;

  List<bool> select = [];

  int? length;
  bool hover = false;
  GlobalKey key = GlobalKey();

  double all = 0;

  @override
  void initState() {
    init();
    Provider.of<AyaProvider>(context, listen: false)
        .getStart(int.parse(widget.suraId), int.parse(widget.page));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      aya.checkRebuilt(aya.nums);

      return aya.loading
          ? Scaffold(
              drawerEnableOpenDragGesture: false,
              drawer: Drawer(
                backgroundColor: themeProvider.isDarkMode
                    ? const Color(0xff9A9A9A)
                    : const Color(0xffFFF5EC),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: (themeProvider.isDarkMode)
                            ? const Color(0xffffffff)
                            : const Color(0xffFFB55F)),
                    color: (themeProvider.isDarkMode)
                        ? const Color(0xffa0a7b7)
                        : const Color(0xfffff3ca),
                  ),
                  child: MoreOptionsList(
                    surah: aya.words ?? '',
                    wordId: aya.wordID,
                  ),
                ),
              ),
              body: aya.breakIndex!.isNotEmpty
                  ? Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int index = aya.checkSurahStart(
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .page);
                                  index <
                                      aya.checkSurahEnd(
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .page);
                                  index++)
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0 + index != 0
                                              ? aya.breakIndex![index - 1]
                                              : 0;
                                          i < aya.breakIndex![index];
                                          i++)
                                        aya.checkAya(
                                          aya.slice![i].end,
                                        )
                                            ? Row(
                                                children: [
                                                  Consumer<AyaProvider>(builder:
                                                      (context, aya, child) {
                                                    return aya.checkSymbol(
                                                            aya.slice![i].start)
                                                        ? Row(
                                                            children: [
                                                              Text(" ﲿ ",
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'MeQuran2',
                                                                    fontSize: aya
                                                                        .value,
                                                                  )),
                                                              InkWell(
                                                                onTap: () {
                                                                  Scaffold.of(
                                                                          context)
                                                                      .openDrawer();
                                                                  Provider.of<AyaProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getCategoryName(
                                                                          aya.slice![i]
                                                                              .wordId,
                                                                          Provider.of<LangProvider>(context, listen: false).langId);
                                                                  aya.setWords(aya
                                                                      .list!
                                                                      .join()
                                                                      .split('')
                                                                      .getRange(
                                                                          aya.slice![i].start -
                                                                              1,
                                                                          aya.slice![i]
                                                                              .end)
                                                                      .join());
                                                                  if (mounted) {
                                                                    setState(
                                                                            () {
                                                                          aya.updateValue(
                                                                              i);
                                                                          aya.set();
                                                                        });
                                                                  }
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
                                                                    softWrap:
                                                                        true,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'MeQuran2',
                                                                      fontSize:
                                                                          aya.value,
                                                                      color: aya.getBoolean(
                                                                              i)
                                                                          ? aya.getColor(aya
                                                                              .slice![i]
                                                                              .wordId)
                                                                          : null,
                                                                      // aya.getBoolean(_slice[i]['start'] - 1)
                                                                      //     ? aya.getColor(_slice[i]['word_id'])
                                                                      //     : Colors.black)),
                                                                    )),
                                                              ),
                                                            ],
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              Scaffold.of(
                                                                      context)
                                                                  .openDrawer();
                                                              Provider.of<AyaProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getCategoryName(
                                                                      aya
                                                                          .slice![
                                                                              i]
                                                                          .wordId,
                                                                      Provider.of<LangProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .langId);
                                                              aya.setWords(aya
                                                                  .list!
                                                                  .join()
                                                                  .split('')
                                                                  .getRange(
                                                                      aya.slice![i].start -
                                                                          1,
                                                                      aya
                                                                          .slice![
                                                                              i]
                                                                          .end)
                                                                  .join());
                                                              if (mounted) {
                                                                setState(() {
                                                                  aya.updateValue(
                                                                      i);
                                                                  aya.set();
                                                                });
                                                              }
                                                            },
                                                            child: Text(
                                                                aya.list!
                                                                    .join()
                                                                    .split('')
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
                                                                softWrap: true,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'MeQuran2',
                                                                  fontSize:
                                                                      aya.value,
                                                                  color: aya
                                                                          .getBoolean(
                                                                              i)
                                                                      ? aya.getColor(aya
                                                                          .slice![
                                                                              i]
                                                                          .wordId)
                                                                      : null,
                                                                )),
                                                          );
                                                  }),
                                                  aya.list!
                                                                  .join()
                                                                  .split('')
                                                                  .length -
                                                              aya.slice![i]
                                                                  .end <
                                                          3
                                                      ? Text(
                                                          " ${aya.list!.join().split('').length - aya.slice![i].end < 3 ? aya.ayaNumber.last : ""}",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'MeQuran2',
                                                            fontSize: Provider
                                                                    .of<AyaProvider>(
                                                                        context)
                                                                .value,
                                                          ),
                                                        )
                                                      : Container(),

                                                  //   SizedBox(width: 5,)
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Consumer<AyaProvider>(builder:
                                                      (context, aya, child) {
                                                    return aya.checkSymbol(
                                                            aya.slice![i].start)
                                                        ? Row(
                                                            children: [
                                                              Text(" ﲿ ",
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'MeQuran2',
                                                                    fontSize: aya
                                                                        .value,
                                                                  )),
                                                              InkWell(
                                                                onTap: () {
                                                                  Scaffold.of(
                                                                          context)
                                                                      .openDrawer();
                                                                  Provider.of<AyaProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getCategoryName(
                                                                          aya.slice![i]
                                                                              .wordId,
                                                                          Provider.of<LangProvider>(context, listen: false).langId);
                                                                  aya.setWords(aya
                                                                      .list!
                                                                      .join()
                                                                      .split('')
                                                                      .getRange(
                                                                          aya.slice![i].start -
                                                                              1,
                                                                          aya.slice![i]
                                                                              .end)
                                                                      .join());
                                                                  if (mounted) {
                                                                    setState(
                                                                            () {
                                                                          aya.updateValue(
                                                                              i);
                                                                          aya.set();
                                                                        });
                                                                  }
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
                                                                    softWrap:
                                                                        true,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'MeQuran2',
                                                                      fontSize:
                                                                          aya.value,
                                                                      color: aya.getBoolean(
                                                                              i)
                                                                          ? aya.getColor(aya
                                                                              .slice![i]
                                                                              .wordId)
                                                                          : null,
                                                                      // aya.getBoolean(_slice[i]['start'] - 1)
                                                                      //     ? aya.getColor(_slice[i]['word_id'])
                                                                      //     : Colors.black)),
                                                                    )),
                                                              ),
                                                            ],
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              Scaffold.of(
                                                                      context)
                                                                  .openDrawer();
                                                              Provider.of<AyaProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getCategoryName(
                                                                      aya
                                                                          .slice![
                                                                              i]
                                                                          .wordId,
                                                                      Provider.of<LangProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .langId);
                                                              aya.setWords(aya
                                                                  .list!
                                                                  .join()
                                                                  .split('')
                                                                  .getRange(
                                                                      aya.slice![i].start -
                                                                          1,
                                                                      aya
                                                                          .slice![
                                                                              i]
                                                                          .end)
                                                                  .join());
                                                              if (mounted) {
                                                                setState(() {
                                                                  aya.updateValue(
                                                                      i);
                                                                  aya.set();
                                                                });
                                                              }
                                                            },
                                                            child: Text(
                                                                aya.list!
                                                                    .join()
                                                                    .split('')
                                                                    .getRange(
                                                                        aya.slice![i].start -
                                                                            1,
                                                                        aya
                                                                            .slice![
                                                                                i]
                                                                            .end)
                                                                    .join()
                                                                    .replaceAll(
                                                                        'ﲿ',
                                                                        ''),
                                                                softWrap: true,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'MeQuran2',
                                                                  fontSize:
                                                                      aya.value,
                                                                  color: aya
                                                                          .getBoolean(
                                                                              i)
                                                                      ? aya.getColor(aya
                                                                          .slice![
                                                                              i]
                                                                          .wordId)
                                                                      : null,
                                                                )),
                                                          );
                                                  }),
                                                  Text(
                                                    "${aya.ayaNumber[aya.nums != 0 ? aya.nums - 1 : aya.nums]} ",
                                                    softWrap: true,
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
                      ],
                    )
                  : Container())
          : Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
              ));
    });
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

  Future<void> init() async {}
}
