import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/language.provider.dart';

import '../more_options_list.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      aya.checkRebuilt(aya.nums);
      final size = MediaQuery.of(context).size;
      final themeProvider = Provider.of<ThemeProvider>(context);
      return aya.loading
          ? Scaffold(
              body: SingleChildScrollView(
                  child: aya.breakIndex!.isNotEmpty
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (size.width > 1400)
                                  buildPopup(aya.visible, aya.words),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 80.0),
                                  child: SizedBox(
                                    width: widthBasedOnFont(aya.value),
                                    child: Column(
                                      children: [
                                        for (int index = 0;
                                            index < aya.breakIndex!.length;
                                            index++)
                                          Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Row(
                                              mainAxisAlignment:
                                                  aya.breakIndex!.length > 7
                                                      ? MainAxisAlignment
                                                          .spaceBetween
                                                      : MainAxisAlignment
                                                          .center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                for (int i = 0 + index != 0
                                                        ? aya.breakIndex![
                                                            index - 1]
                                                        : 0;
                                                    i < aya.breakIndex![index];
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
                                                                      .slice![i]
                                                                      .start)
                                                                  ? Row(
                                                                      children: [
                                                                        Text(
                                                                            " ﲿ ",
                                                                            textDirection: TextDirection
                                                                                .rtl,
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'MeQuran2',
                                                                              fontSize: aya.value,
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
                                                                                      backgroundColor: (themeProvider.isDarkMode) ? const Color(0xffa0a7b7) : const Color(0xfffff3ca),
                                                                                      context: context,
                                                                                      transitionDuration: Duration(milliseconds: 200),
                                                                                      bodyBuilder: (context) => ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join()),
                                                                                      onPop: () {
                                                                                        Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                        aya.defaultSelect();
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
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              ///todo:space around text
                                                                              if (aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join().contains(' '))
                                                                                Text(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join(),
                                                                                    textDirection: TextDirection.rtl,
                                                                                    softWrap: true,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'MeQuran2',
                                                                                      fontSize: aya.value,
                                                                                      color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                    )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : !aya.list!
                                                                          .join()
                                                                          .split(
                                                                              '')
                                                                          .getRange(
                                                                              aya.slice![i].start - 1,
                                                                              aya.slice![i].end)
                                                                          .join()
                                                                          .contains(' ')
                                                                      ? Row(
                                                                          children: [
                                                                            ///todo: initial position
                                                                            if (i == 0 ||
                                                                                i > 1 && aya.list!.join().split('').getRange(aya.slice![i - 1].start - 1, aya.slice![i - 1].end).join() != 'ﺑﲐ' && aya.list!.join().split('').getRange(aya.slice![i - 2].start - 1, aya.slice![i - 2].end).join() != 'ﺑﲐ' && aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() != 'ﺰﱺﺍﺩﱧ' && aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() != 'ﺄﱁﺧﱹﺮﱺﺟﱺ' && aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() != 'ﺄﱁﺯﱺﻟﱋ' && aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() != 'ﻬﱻﻤﱧﺎ ')
                                                                              InkWell(
                                                                                onTap: aya.visible
                                                                                    ? null
                                                                                    : () {
                                                                                        print(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                        Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                        aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                        if (size.width < 1400) {
                                                                                          showPopover(
                                                                                            backgroundColor: (themeProvider.isDarkMode) ? const Color(0xffa0a7b7) : const Color(0xfffff3ca),
                                                                                            context: context,
                                                                                            transitionDuration: Duration(milliseconds: 200),
                                                                                            bodyBuilder: (context) => ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join()),
                                                                                            onPop: () {
                                                                                              Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                              aya.defaultSelect();
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
                                                                                    )),
                                                                              ),

                                                                            ///todo:+1 from initial position
                                                                            if (i < aya.breakIndex![index] - 1 && aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join() != 'ﻬﱻﻤﱧﺎ ' && aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join().contains(' ') ||
                                                                                aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() == 'ﻓﱁ' && aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join() != 'ﻬﱻﻤﱧﺎ ' ||
                                                                                aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() == 'ﺑﲐ')
                                                                              InkWell(
                                                                                onTap: aya.visible
                                                                                    ? null
                                                                                    : () {
                                                                                        print(aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join());
                                                                                        Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i + 1].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                        aya.setWords(aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join());
                                                                                        if (size.width < 1400) {
                                                                                          showPopover(
                                                                                            backgroundColor: (themeProvider.isDarkMode) ? const Color(0xffa0a7b7) : const Color(0xfffff3ca),
                                                                                            context: context,
                                                                                            transitionDuration: Duration(milliseconds: 200),
                                                                                            bodyBuilder: (context) => ListItems(aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join()),
                                                                                            onPop: () {
                                                                                              Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                              aya.defaultSelect();
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
                                                                                              aya.updateValue(i + 1);
                                                                                              aya.set();
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                child: Text(aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join().trim(),
                                                                                    textDirection: TextDirection.rtl,
                                                                                    softWrap: true,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'MeQuran2',
                                                                                      fontSize: aya.value,
                                                                                      color: aya.getBoolean(i + 1) ? aya.getColor(aya.slice![i + 1].wordId) : null,
                                                                                    )),
                                                                              ),

                                                                            ///todo:+2 from initial position
                                                                            if (i < aya.breakIndex![index] - 2 && aya.list!.join().split('').getRange(aya.slice![i + 2].start - 1, aya.slice![i + 2].end).join() == 'ﻬﱻﻤﱧﺎ ' && aya.list!.join().split('').getRange(aya.slice![i + 1].start - 1, aya.slice![i + 1].end).join() == 'ﺄﱁﺯﱺﻟﱋ' ||
                                                                                i < aya.breakIndex![index] - 2 && aya.list!.join().split('').getRange(aya.slice![i + 2].start - 1, aya.slice![i + 2].end).join() == 'ﻬﱻﻤﱧﺎ ')
                                                                              InkWell(
                                                                                onTap: aya.visible
                                                                                    ? null
                                                                                    : () {
                                                                                        print(aya.list!.join().split('').getRange(aya.slice![i + 2].start - 1, aya.slice![i + 2].end).join());
                                                                                        Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i + 2].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                        aya.setWords(aya.list!.join().split('').getRange(aya.slice![i + 2].start - 1, aya.slice![i + 2].end).join());
                                                                                        if (size.width < 1400) {
                                                                                          showPopover(
                                                                                            backgroundColor: (themeProvider.isDarkMode) ? const Color(0xffa0a7b7) : const Color(0xfffff3ca),
                                                                                            context: context,
                                                                                            transitionDuration: Duration(milliseconds: 200),
                                                                                            bodyBuilder: (context) => ListItems(aya.list!.join().split('').getRange(aya.slice![i + 2].start - 1, aya.slice![i + 2].end).join()),
                                                                                            onPop: () {
                                                                                              Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                              aya.defaultSelect();
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
                                                                                              aya.updateValue(i + 2);
                                                                                              aya.set();
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                child: aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() != 'ﻭﱺ' && aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() != 'ﺃﱁﺑﱦﺼﱺ﮳ﺮﱺ'
                                                                                    ? Text(aya.list!.join().split('').getRange(aya.slice![i + 2].start - 1, aya.slice![i + 2].end).join().trim(),
                                                                                        textDirection: TextDirection.rtl,
                                                                                        softWrap: true,
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'MeQuran2',
                                                                                          fontSize: aya.value,
                                                                                          color: aya.getBoolean(i + 2) ? aya.getColor(aya.slice![i + 2].wordId) : null,
                                                                                        ))
                                                                                    : Text(''),
                                                                              ),
                                                                          ],
                                                                        )
                                                                      : Row(
                                                                          children: [
                                                                            if (i == 0 ||
                                                                                aya.list!.join().split('').getRange(aya.slice![i - 1].start - 1, aya.slice![i - 1].end).join().contains(' '))
                                                                              aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join() == 'ﺄﱁﺯﱺﻟﱋ' && aya.list!.join().split('').getRange(aya.slice![i - 1].start - 1, aya.slice![i - 1].end).join() == 'ﺄﱁﺯﱺﻟﱋ'
                                                                                  ? Container()
                                                                                  : InkWell(
                                                                                      onTap: aya.visible
                                                                                          ? null
                                                                                          : () {
                                                                                              print(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                              Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                                              aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                              if (size.width < 1400) {
                                                                                                showPopover(
                                                                                                  backgroundColor: (themeProvider.isDarkMode) ? const Color(0xffa0a7b7) : const Color(0xfffff3ca),
                                                                                                  context: context,
                                                                                                  transitionDuration: Duration(milliseconds: 200),
                                                                                                  bodyBuilder: (context) => ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join()),
                                                                                                  onPop: () {
                                                                                                    Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                                    aya.defaultSelect();
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
                                                                                          )),
                                                                                    )
                                                                          ],
                                                                        );
                                                            }),
                                                            aya.list!
                                                                            .join()
                                                                            .split(
                                                                                '')
                                                                            .length -
                                                                        aya.slice![i]
                                                                            .end <
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
                                                                          Provider.of<AyaProvider>(context)
                                                                              .value,
                                                                    ),
                                                                  )
                                                                : Container(),

                                                            //   SizedBox(width: 5,)
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
                                                                      .slice![i]
                                                                      .start)
                                                                  ? Row(
                                                                      children: [
                                                                        Text(
                                                                            " ﲿ ",
                                                                            textDirection: TextDirection
                                                                                .rtl,
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'MeQuran2',
                                                                              fontSize: aya.value,
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
                                                                                      backgroundColor: (themeProvider.isDarkMode) ? const Color(0xffa0a7b7) : const Color(0xfffff3ca),
                                                                                      context: context,
                                                                                      transitionDuration: const Duration(milliseconds: 200),
                                                                                      bodyBuilder: (context) {
                                                                                        return ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                      },
                                                                                      onPop: () {
                                                                                        Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                        aya.defaultSelect();
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
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : InkWell(
                                                                      onTap: aya
                                                                              .visible
                                                                          ? null
                                                                          : () {
                                                                              Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, Provider.of<LangProvider>(context, listen: false).langId);
                                                                              aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                              if (size.width < 1400) {
                                                                                showPopover(
                                                                                  backgroundColor: (themeProvider.isDarkMode) ? const Color(0xffa0a7b7) : const Color(0xfffff3ca),
                                                                                  context: context,
                                                                                  transitionDuration: const Duration(milliseconds: 200),
                                                                                  bodyBuilder: (context) {
                                                                                    return ListItems(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                                  },
                                                                                  onPop: () {
                                                                                    Provider.of<AyaProvider>(context, listen: false).clear();
                                                                                    aya.defaultSelect();
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
                                                                      child: i != 0 && aya.list!.join().split('').getRange(aya.slice![i - 1].start - 1, aya.slice![i - 1].end).join().replaceAll('ﲿ', '') != 'ﺑﲐ' && aya.list!.join().split('').getRange(aya.slice![i - 1].start - 1, aya.slice![i - 1].end).join().replaceAll('ﲿ', '') != 'ﻟﱊﲘ' ||
                                                                              i ==
                                                                                  0
                                                                          ? Text(
                                                                              aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join().replaceAll('ﲿ', ''),
                                                                              softWrap: true,
                                                                              style: TextStyle(
                                                                                fontFamily: 'MeQuran2',
                                                                                fontSize: aya.value,
                                                                                color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                              ))
                                                                          : Text(''),
                                                                    );
                                                            }),
                                                            Text(
                                                              "${aya.ayaNumber[aya.nums != 0 ? aya.nums - 1 : aya.nums]} ",
                                                              softWrap: true,
                                                              style: TextStyle(
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
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container()))
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

  void cancelLoad() {
    setState(() {
      loading = false;
    });
  }

  buildPopup(visible, words) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Visibility(
      visible: visible,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            color: themeProvider.isDarkMode
                ? const Color(0xff9A9A9A)
                : const Color(0xffFFF5EC),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.33,
              decoration: BoxDecoration(
                border: Border.all(
                    color: (themeProvider.isDarkMode)
                        ? const Color(0xffffffff)
                        : const Color(0xffFFB55F)),
                color: (themeProvider.isDarkMode)
                    ? const Color(0xffa0a7b7)
                    : const Color(0xfffff3ca),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: MoreOptionsList(
                  surah: words ?? '',
                  nukKalimah: 'c',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  widthBasedOnFont(value) {
    if (value == 20) return MediaQuery.of(context).size.width * 0.37;
    if (value == 25) return MediaQuery.of(context).size.width * 0.46;
    if (value == 30) return MediaQuery.of(context).size.width * 0.55;
    if (value == 35) return MediaQuery.of(context).size.width * 0.63;
  }
}
