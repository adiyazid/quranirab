import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../theme/theme_provider.dart';
import '../../widget/more_options_list.dart';

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

  final _aya = AutoSizeGroup();

  @override
  void initState() {
    init();
    Provider.of<AyaProvider>(context, listen: false)
        .getStart(int.parse(widget.suraId), int.parse(widget.page));
    FeatureDiscovery.clearPreferences(context, <String>{
      'quranirab_1',
      'quranirab_4',
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      final font = Provider.of<AyaProvider>(context);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      aya.checkRebuilt(aya.nums);

      return aya.loading
          ? Scaffold(
              backgroundColor: Colors.white,
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
              body: Zoom(
                backgroundColor: (themeProvider.isDarkMode)
                    ? const Color(0xff666666)
                    : const Color(0xFFffffff),
                canvasColor: (themeProvider.isDarkMode)
                    ? const Color(0xff666666)
                    : const Color(0xFFffffff),
                enableScroll: false,
                maxZoomWidth: context.width(),
                maxZoomHeight: context.height(),
                onTap: () {
                  print("You click the widget!");
                },
                initZoom: 0,
                child: aya.breakIndex!.isNotEmpty
                    ? SingleChildScrollView(
                        child: DescribedFeatureOverlay(
                          title: Text(
                            AppLocalizations.of(context)!.readingAya,
                            textAlign: TextAlign.justify,
                          ),
                          description: Text(
                              AppLocalizations.of(context)!.doubleClickToZoom),
                          tapTarget: Icon(
                            Icons.check,
                            size: 24,
                            color: Colors.black,
                          ),
                          featureId: 'quranirab_1',
                          child: Container(
                            margin: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Center(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: DescribedFeatureOverlay(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .wordsDetail),
                                        description: Text(
                                            AppLocalizations.of(context)!
                                                .pressEach),
                                        tapTarget: Icon(
                                          Icons.check,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                        featureId: 'quranirab_3',
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    1000
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5
                                                : MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
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
                                                                          AutoSizeText(
                                                                              " ﲿ ",
                                                                              group: _aya,
                                                                              textDirection: TextDirection.rtl,
                                                                              softWrap: true,
                                                                              style: TextStyle(
                                                                                fontFamily: 'MeQuran2',
                                                                                fontSize: font.value,
                                                                              )),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Scaffold.of(context).openDrawer();
                                                                              Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, aya.getLangID(context));

                                                                              aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  aya.updateValue(i);
                                                                                  aya.set();
                                                                                });
                                                                              }
                                                                            },
                                                                            child: AutoSizeText(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join(),
                                                                                group: _aya,
                                                                                textDirection: TextDirection.rtl,
                                                                                softWrap: true,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'MeQuran2',
                                                                                  fontSize: font.value,
                                                                                  color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                  // aya.getBoolean(_slice[i]['start'] - 1)
                                                                                  //     ? aya.getColor(_slice[i]['word_id'])
                                                                                  //     : Colors.black)),
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Scaffold.of(context)
                                                                              .openDrawer();
                                                                          Provider.of<AyaProvider>(context, listen: false).getCategoryName(
                                                                              aya.slice![i].wordId,
                                                                              aya.getLangID(context));
                                                                          aya.setWords(aya
                                                                              .list!
                                                                              .join()
                                                                              .split('')
                                                                              .getRange(aya.slice![i].start - 1, aya.slice![i].end)
                                                                              .join());
                                                                          if (mounted) {
                                                                            setState(() {
                                                                              aya.updateValue(i);
                                                                              aya.set();
                                                                            });
                                                                          }
                                                                        },
                                                                        child: AutoSizeText(
                                                                            aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join(),
                                                                            group: _aya,
                                                                            textDirection: TextDirection.rtl,
                                                                            softWrap: true,
                                                                            style: TextStyle(
                                                                              fontFamily: 'MeQuran2',
                                                                              fontSize: font.value,
                                                                              color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                            )),
                                                                      );
                                                              }),
                                                              aya.list!.join().split('').length -
                                                                          aya.slice![i]
                                                                              .end <
                                                                      3
                                                                  ? AutoSizeText(
                                                                      " ${aya.list!.join().split('').length - aya.slice![i].end < 3 ? aya.ayaNumber.last : ""}",
                                                                      softWrap:
                                                                          true,
                                                                      group:
                                                                          _aya,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'MeQuran2',
                                                                        fontSize:
                                                                            font.value,
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
                                                                        .slice![
                                                                            i]
                                                                        .start)
                                                                    ? Row(
                                                                        children: [
                                                                          AutoSizeText(
                                                                              " ﲿ ",
                                                                              group: _aya,
                                                                              textDirection: TextDirection.rtl,
                                                                              softWrap: true,
                                                                              style: TextStyle(
                                                                                fontFamily: 'MeQuran2',
                                                                                fontSize: font.value,
                                                                              )),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Scaffold.of(context).openDrawer();
                                                                              Provider.of<AyaProvider>(context, listen: false).getCategoryName(aya.slice![i].wordId, aya.getLangID(context));
                                                                              aya.setWords(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join());
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  aya.updateValue(i);
                                                                                  aya.set();
                                                                                });
                                                                              }
                                                                            },
                                                                            child: AutoSizeText(aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join(),
                                                                                group: _aya,
                                                                                textDirection: TextDirection.rtl,
                                                                                softWrap: true,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'MeQuran2',
                                                                                  fontSize: font.value,
                                                                                  color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Scaffold.of(context)
                                                                              .openDrawer();
                                                                          Provider.of<AyaProvider>(context, listen: false).getCategoryName(
                                                                              aya.slice![i].wordId,
                                                                              aya.getLangID(context));
                                                                          aya.setWords(aya
                                                                              .list!
                                                                              .join()
                                                                              .split('')
                                                                              .getRange(aya.slice![i].start - 1, aya.slice![i].end)
                                                                              .join());
                                                                          if (mounted) {
                                                                            setState(() {
                                                                              aya.updateValue(i);
                                                                              aya.set();
                                                                            });
                                                                          }
                                                                        },
                                                                        child: AutoSizeText(
                                                                            aya.list!.join().split('').getRange(aya.slice![i].start - 1, aya.slice![i].end).join().replaceAll(
                                                                                'ﲿ', ''),
                                                                            group:
                                                                                _aya,
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'MeQuran2',
                                                                              fontSize: font.value,
                                                                              color: aya.getBoolean(i) ? aya.getColor(aya.slice![i].wordId) : null,
                                                                            )),
                                                                      );
                                                              }),
                                                              AutoSizeText(
                                                                "${aya.ayaNumber[aya.nums != 0 ? aya.nums - 1 : aya.nums]} ",
                                                                softWrap: true,
                                                                group: _aya,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'MeQuran2',
                                                                  fontSize: font
                                                                      .value,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ))
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
