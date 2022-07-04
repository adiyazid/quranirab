import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/models/item.model.dart';
import 'package:quranirab/provider/language.provider.dart';
import 'package:quranirab/views/sura.slice/sura.slice.dart';
import 'package:quranirab/widget/TranslationPopup.dart';
import 'package:quranirab/widget/responsive.dart' as w;

import '../provider/ayah.number.provider.dart';
import '../theme/theme_provider.dart';
import '../widget/LanguagePopup.dart';
import '../widget/menu.dart';
import '../widget/search.popup.dart';
import '../widget/setting.popup.dart';
import 'Translation/translation.dart';

class SurahScreen extends StatefulWidget {
  final List allpages;
  final String sura_id;
  final String name;
  final String detail;
  final int index;

  const SurahScreen(
      this.allpages, this.sura_id, this.name, this.detail, this.index,
      {Key? key})
      : super(key: key);

  @override
  _SurahScreenState createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen>
    with SingleTickerProviderStateMixin {
  List _list = [];
  int? a = 0;
  String? b;
  var hizb;
  int? start;

  late TabController _tabController;

  bool visible = false;

  bool color = true;

  var scrollController = ScrollController();
  var page;

  late int i;

  List menuItems = [
    ItemModel('Share', Icons.share),
    ItemModel('Bookmark', Icons.bookmarks),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2, initialIndex: 1);
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(context, const <String>{
        // Feature ids for every feature that you want to showcase in order.
        'quranirab_1',
        'quranirab_4',
      });
    });
    // You need to save an instance of a GlobalKey in order to call ensureVisible in onOpen.
    i = widget.index;

    getHizb();
    getData();
    getStartAyah(widget.allpages[i]);
    super.initState();
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('quran_texts');
  final CollectionReference _collectionStartAya =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');
  final CollectionReference _collectionHizb =
      FirebaseFirestore.instance.collection('hizbs');

  Future<void> getData() async {
    // Get docs from collection reference
    await _collectionRef
        .where('medina_mushaf_page_id', isEqualTo: widget.allpages[i])
        .where('sura_id', isEqualTo: widget.sura_id)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _list.add(doc['text']);
        });
      }
    });
  }

  Future<void> nextPage(String id) async {
    List a = [];
    // Get docs from collection reference
    await _collectionRef
        .where('medina_mushaf_page_id', isEqualTo: id)
        .where('sura_id', isEqualTo: widget.sura_id)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          a.add(doc['text']);
        });
      }
      setState(() {
        _list = a;
      });
    });
    var langId = Provider.of<LangProvider>(context, listen: false).langId;
    await Provider.of<LangProvider>(context, listen: false)
        .getTranslation(langId, widget.sura_id, start);
  }

  Future<void> getStartAyah(String id) async {
    await _collectionStartAya
        .where('id', isEqualTo: id)
        .where('sura_id', isEqualTo: widget.sura_id)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          setState(() {
            start = int.parse(doc['aya']);
          });
        }
      }
    });
    print('starting at $start for page $id and sura id ${widget.sura_id}');
    var ids = Provider.of<LangProvider>(context, listen: false).langId;
    await Provider.of<LangProvider>(context, listen: false)
        .getTranslation(ids, widget.sura_id, start);
    Provider.of<AyaProvider>(context, listen: false).getJuz(
        int.parse(widget.sura_id),
        '${Provider.of<AyaProvider>(context, listen: false).page}');
    // Get docs from collection reference
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: (themeProvider.isDarkMode)
              ? const Color(0xff666666)
              : const Color(0xFFffffff),
          drawer: const Menu(),
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  iconTheme: Theme.of(context).iconTheme,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.menu,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: const CircleAvatar(
                    backgroundImage: AssetImage('assets/quranirab.png'),
                    radius: 18.0,
                  ),
                  centerTitle: false,
                  floating: true,
                  actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: SearchPopup()),
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: LangPopup()),
                    DescribedFeatureOverlay(
                      description: Text(AppLocalizations.of(context)!.clickTo),
                      title: Text(AppLocalizations.of(context)!.customization),
                      tapTarget: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                      featureId: 'quranirab_4',
                      child: Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: SettingPopup()),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(140),
                    child: TopSura(
                        widget: widget,
                        widget1: widget,
                        hizb: hizb,
                        widget2: widget,
                        start: start,
                        tabController: _tabController,
                        themeProvider: themeProvider),
                  ),
                ),
              ];
            },
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Consumer<LangProvider>(builder: (context, lang, child) {
                  return Translation(
                    themeProvider: themeProvider,
                    list: _list,
                    translate: lang.translate,
                    widget: widget,
                    start: start ?? 1,
                    menuItems: menuItems,
                    i: i,
                    widget1: widget,
                    widget2: widget,
                    widget3: widget,
                    widget4: widget,
                    widget5: widget,
                  );
                }),
                SuraSlice(
                    "${Provider.of<AyaProvider>(context, listen: false).page}",
                    widget.sura_id),
              ],
            ),
          ),
          // floatingActionButton: Padding(
          //   padding: EdgeInsets.only(
          //       bottom: MediaQuery.of(context).size.height * 0.08),
          //   child: FloatingActionButton.extended(
          //       backgroundColor: themeProvider.isDarkMode
          //           ? Colors.blueGrey
          //           : Colors.orangeAccent,
          //       onPressed: () => Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => QuizHome(
          //                   Provider.of<AyaProvider>(context, listen: false)
          //                       .page))),
          //       label: Text(
          //         AppLocalizations.of(context)!.takeAQuiz,
          //         style: TextStyle(
          //             color:
          //                 themeProvider.isDarkMode ? Colors.white : Colors.black),
          //       )),
          // ),
          bottomSheet: BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: (themeProvider.isDarkMode)
                              ? const Color(0xffffffff)
                              : const Color(0xffFFB55F))),
                  color: themeProvider.isDarkMode
                      ? const Color(0xff666666)
                      : Colors.white,
                ),
                height: MediaQuery.of(context).size.height * 0.1,
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MediaQuery.of(context).size.width < 600
                          ? IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: widget.allpages[i] !=
                                      widget.allpages.first
                                  ? () async {
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .previousPage();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .setDefault();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .readJsonData();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .readSliceData();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .readAya();
                                      await Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .getStart(
                                              int.parse(widget.sura_id),
                                              Provider.of<AyaProvider>(context,
                                                      listen: false)
                                                  .page);
                                      if (i < int.parse(widget.allpages.last)) {
                                        setState(() {
                                          i--;
                                        });
                                        await getStartAyah(widget.allpages[i]);
                                        await nextPage(widget.allpages[i]);
                                      } else {
                                        await getStartAyah(widget.allpages[i]);
                                        await nextPage(widget.allpages[i]);
                                      }
                                    }
                                  : null,
                            )
                          : Flexible(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 18),
                                      primary: (themeProvider.isDarkMode)
                                          ? const Color(0xff808BA1)
                                          : const Color(0xfffcd77a)),
                                  onPressed: widget.allpages[i] !=
                                          widget.allpages.first
                                      ? () async {
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .previousPage();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .setDefault();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .readJsonData();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .readSliceData();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .readAya();
                                          await Provider.of<AyaProvider>(
                                                  context,
                                                  listen: false)
                                              .getStart(
                                                  int.parse(widget.sura_id),
                                                  Provider.of<AyaProvider>(
                                                          context,
                                                          listen: false)
                                                      .page);
                                          if (i <
                                              int.parse(widget.allpages.last)) {
                                            setState(() {
                                              i--;
                                            });
                                            await getStartAyah(
                                                widget.allpages[i]);
                                            await nextPage(widget.allpages[i]);
                                          } else {
                                            await getStartAyah(
                                                widget.allpages.first);
                                            await nextPage(
                                                widget.allpages.first);
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    AppLocalizations.of(context)!.prevPage,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                      Consumer<AyaProvider>(builder: (context, number, child) {
                        return ElevatedButton(
                            onPressed: number.page ==
                                    int.parse(widget.allpages.first)
                                ? null
                                : () async {
                                    Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .getPage(
                                            int.parse(widget.allpages.first));
                                    Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .setDefault();
                                    await Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .readJsonData();
                                    await Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .readSliceData();
                                    await Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .readAya();
                                    await Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .getStart(
                                            int.parse(widget.sura_id),
                                            Provider.of<AyaProvider>(context,
                                                    listen: false)
                                                .page);
                                    await getStartAyah(widget.allpages.first);
                                    await nextPage(widget.allpages.first);
                                    setState(() {
                                      i = 0;
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 18),
                                primary: (themeProvider.isDarkMode)
                                    ? const Color(0xff4C6A7A)
                                    : const Color(0xffffeeb0)),
                            child: Text(
                              AppLocalizations.of(context)!.beginningSurah,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ));
                      }),
                      MediaQuery.of(context).size.width < 600
                          ? IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: widget.allpages[i] !=
                                      widget.allpages.last
                                  ? () async {
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .nextPage();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .setDefault();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .readJsonData();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .readSliceData();
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .readAya();
                                      await Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .getStart(
                                              int.parse(widget.sura_id),
                                              Provider.of<AyaProvider>(context,
                                                      listen: false)
                                                  .page);
                                      if (i < int.parse(widget.allpages.last)) {
                                        setState(() {
                                          i++;
                                        });
                                        await getStartAyah(widget.allpages[i]);
                                        await nextPage(widget.allpages[i]);
                                      } else {
                                        await getStartAyah(
                                            widget.allpages.last);
                                        await nextPage(widget.allpages.last);
                                      }
                                    }
                                  : null,
                            )
                          : Flexible(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 18),
                                      primary: (themeProvider.isDarkMode)
                                          ? const Color(0xff808BA1)
                                          : const Color(0xfffcd77a)),
                                  onPressed: widget.allpages[i] !=
                                          widget.allpages.last
                                      ? () async {
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .nextPage();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .setDefault();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .readJsonData();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .readSliceData();
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .readAya();
                                          await Provider.of<AyaProvider>(
                                                  context,
                                                  listen: false)
                                              .getStart(
                                                  int.parse(widget.sura_id),
                                                  Provider.of<AyaProvider>(
                                                          context,
                                                          listen: false)
                                                      .page);
                                          if (i <
                                              int.parse(widget.allpages.last)) {
                                            setState(() {
                                              i++;
                                            });
                                            await getStartAyah(
                                                widget.allpages[i]);
                                            await nextPage(widget.allpages[i]);
                                          } else {
                                            await getStartAyah(
                                                widget.allpages.last);
                                            await nextPage(
                                                widget.allpages.last);
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    AppLocalizations.of(context)!.nextPage,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  Future<double> checkFont() async {
    var a = fontData.size;
    return a;
  }

  Future<void> getHizb() async {
    await _collectionHizb
        .where('medina_mushaf_page_id', isLessThanOrEqualTo: widget.allpages[i])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          hizb = doc['id'];
        });
      }
    });
    Provider.of<AyaProvider>(context, listen: false).setDefault();
    await Provider.of<AyaProvider>(context, listen: false).readJsonData();
    await Provider.of<AyaProvider>(context, listen: false).readSliceData();
    await Provider.of<AyaProvider>(context, listen: false).readAya();
    await Provider.of<AyaProvider>(context, listen: false).getStart(
        int.parse(widget.sura_id),
        Provider.of<AyaProvider>(context, listen: false).page);
    if (Provider.of<AyaProvider>(context, listen: false).visible == true) {
      await Provider.of<AyaProvider>(context, listen: false).set();
    }
  }
}

class TopSura extends StatelessWidget {
  const TopSura({
    Key? key,
    required this.widget,
    required this.widget1,
    required this.hizb,
    required this.widget2,
    required this.start,
    required TabController tabController,
    required this.themeProvider,
  })  : _tabController = tabController,
        super(key: key);

  final SurahScreen widget;
  final SurahScreen widget1;
  final hizb;
  final SurahScreen widget2;
  final int? start;
  final TabController _tabController;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: ListTile(
              title: Text(
                widget.name,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 500 ? 15 : 20,
                ),
              ),
              subtitle: Text(
                widget1.detail,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width < 500 ? 14 : 20,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          const SizedBox(
            width: 5,
            height: 40,
            child: VerticalDivider(
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          hizb != null
              ? Expanded(
                  child: Consumer<AyaProvider>(builder: (context, aya, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Juz ${aya.juz} / Hizb $hizb - Page ${aya.page}',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width < 500 ? 15 : 20,
                        ),
                      ),
                    );
                  }),
                )
              : Container(),
          DescribedFeatureOverlay(
              contentLocation: ContentLocation.below,
              description: Text(AppLocalizations.of(context)!.clickToDisplay),
              title: Text(AppLocalizations.of(context)!.translations +
                  " " +
                  AppLocalizations.of(context)!.language),
              tapTarget: ImageIcon(
                AssetImage(
                  "assets/translation_icon.png",
                ),
                color: Colors.black,
                size: 50,
              ),
              featureId: 'quranirab_5',
              child: TransPopup()),
        ]),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: w.Responsive.isDesktop(context) ? 400.0 : 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TabBar(
                controller: _tabController,
                indicatorPadding: const EdgeInsets.all(8),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // Creates border
                    color: Theme.of(context).primaryColor),
                tabs: [
                  DescribedFeatureOverlay(
                    title: Text(AppLocalizations.of(context)!.translations),
                    description:
                        Text(AppLocalizations.of(context)!.featureTranslation),
                    tapTarget: Icon(
                      Icons.check,
                      size: 24,
                      color: Colors.black,
                    ),
                    featureId: 'quranirab_2',
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tab(
                        child: Text(
                          AppLocalizations.of(context)!.translations,
                          style: TextStyle(
                              fontSize: 20,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tab(
                      child: Text(
                        AppLocalizations.of(context)!.reading,
                        style: TextStyle(
                            fontSize: 20,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
