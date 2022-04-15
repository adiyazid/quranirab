import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:provider/provider.dart';

import 'package:quran/quran.dart';
import 'package:quranirab/facebook/screens/home_screen_1.dart';
import 'package:quranirab/models/font.size.dart';

import 'package:quranirab/views/slice/slice2.dart';

import 'package:quranirab/widget/TranslationPopup.dart';

import 'package:quranirab/widget/responsive.dart' as w;
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/ayah.number.provider.dart';
import '../theme/theme_provider.dart';
import '../widget/LanguagePopup.dart';
import '../widget/menu.dart';
import '../widget/search.popup.dart';
import '../widget/setting.popup.dart';

class SurahScreen extends StatefulWidget {
  final List allpages;
  final String sura_id;
  final String name;
  final String detail;

  const SurahScreen(this.allpages, this.sura_id, this.name, this.detail,
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
  int? start = 1;

  List _translate = [];
  final CollectionReference _collectionTranslate =
      FirebaseFirestore.instance.collection('quran_translations');

  late TabController _tabController;

  Future<void> getTranslation() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionTranslate
        .where('translation_id', isEqualTo: "2")
        .where('sura_id', isEqualTo: widget.sura_id)
        .get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _translate = allData;
    });
    //convert dynamic map list into string list
    var data = _translate.map((e) => e["text"]).toList();
    setState(() {
      _translate = data;
    });
    if (start != 1) {
      _translate.removeRange(0, start! - 1);
    }
  }

  bool visible = false;

  bool color = true;

  var scrollController = ScrollController();
  var page;

  var i = 0;

  List menuItems = [
    ItemModel('Share', Icons.share),
    ItemModel('Bookmark', Icons.bookmarks),
  ];
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2, initialIndex: 1);
    getHizb();
    getData();
    getTranslation();
    super.initState();
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('quran_texts');
  final CollectionReference _collectionRefs =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');
  final CollectionReference _collectionHizb =
      FirebaseFirestore.instance.collection('hizbs');

  Future<void> getData() async {
    // Get docs from collection reference
    await _collectionRef
        .where('medina_mushaf_page_id', isEqualTo: widget.allpages.first)
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
          a.add(doc['text1']);
        });
      }

      setState(() {
        _list = a;
      });
    });
    await getTranslation();
  }

  Future<void> getStartAyah(String id) async {
    // Get docs from collection reference
    await _collectionRefs
        .where('id', isEqualTo: id)
        .where('sura_id', isEqualTo: widget.sura_id)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          start = int.parse(doc['aya']);
        });
      }
    });
  }

  bool isDark = false;
  var c = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
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
              actions: const [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SearchPopup()),
                Padding(
                    padding: EdgeInsets.only(right: 20.0), child: LangPopup()),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SettingPopup()),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(140),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: ListTile(
                              title: Text(
                                widget.name,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                widget.detail,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                              trailing:
                                  Icon(Icons.keyboard_arrow_down_outlined),
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
                                  child: Consumer<AyaProvider>(
                                      builder: (context, aya, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Juz ${getJuzNumber(int.parse(widget.sura_id), start!)} / Hizb $hizb - Page ${aya.page}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              : Container(),
                          TransPopup(),
                        ]),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              w.Responsive.isDesktop(context) ? 400.0 : 80),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tab(
                                  child: Text(
                                    'Translations',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tab(
                                  child: Text(
                                    'Reading',
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
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // TranslationPage(widget.sura_id, widget.allpages[i]),
                    Container(
                      decoration: BoxDecoration(
                        color: (themeProvider.isDarkMode)
                            ? const Color(0xff666666)
                            : const Color(0xFFffffff),
                      ),
                      child: _list.isNotEmpty && _translate.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: ListView.builder(
                                        itemCount: _list.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final fontsize =
                                              Provider.of<AyaProvider>(context);
                                          return Card(
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 5,
                                            color: (themeProvider.isDarkMode)
                                                ? const Color(0xffC4C4C4)
                                                : const Color(0xffFFF5EC),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: (themeProvider
                                                                  .isDarkMode)
                                                              ? const Color(
                                                                  0xff67748E)
                                                              : const Color(
                                                                  0xffFFEEB0),
                                                        ),
                                                        width: 70,
                                                        child: Center(
                                                          child: Text(
                                                            '${widget.sura_id}:${start! + index}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    fontsize
                                                                        .value,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textSelectionColor),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      CustomPopupMenu(
                                                        menuBuilder: () =>
                                                            ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: Container(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            child:
                                                                IntrinsicWidth(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                children:
                                                                    menuItems
                                                                        .map(
                                                                          (item) =>
                                                                              GestureDetector(
                                                                            behavior:
                                                                                HitTestBehavior.translucent,
                                                                            onTap:
                                                                                _controller.hideMenu,
                                                                            child:
                                                                                Container(
                                                                              height: 40,
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Icon(
                                                                                    item.icon,
                                                                                    size: 15,
                                                                                    color: Theme.of(context).textSelectionColor,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: InkWell(
                                                                                      onTap: () async {
                                                                                        // Obtain shared preferences.
                                                                                        final prefs = await SharedPreferences.getInstance();
                                                                                        if (item.text == 'Bookmark') {
                                                                                          List<String> list = prefs.getStringList('bookmarks') ?? [];
                                                                                          setState(() {
                                                                                            if (list.contains(
                                                                                                  '${widget.sura_id}:${start! + index}',
                                                                                                ) ==
                                                                                                false) {
                                                                                              list.addAll([
                                                                                                '${widget.sura_id}:${start! + index}',
                                                                                                widget.sura_id,
                                                                                                widget.name,
                                                                                                widget.detail
                                                                                              ]);
                                                                                            }
                                                                                          });
                                                                                          prefs.setStringList('bookmarks', list);

                                                                                          ///use to chunk bookmark list
                                                                                          var lst = prefs.getStringList('bookmarks') ?? [];
                                                                                          var chunks = [];
                                                                                          int chunkSize = 4;
                                                                                          for (var i = 0; i < lst.length; i += chunkSize) {
                                                                                            chunks.add(lst.sublist(i, i + chunkSize > lst.length ? lst.length : i + chunkSize));
                                                                                          }
                                                                                          print(chunks);
                                                                                        } else {}
                                                                                      },
                                                                                      child: Container(
                                                                                        margin: const EdgeInsets.only(left: 10),
                                                                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                                                                        child: Text(
                                                                                          item.text,
                                                                                          style: TextStyle(
                                                                                            color: Theme.of(context).textSelectionColor,
                                                                                            fontSize: 12,
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
                                                                        .toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        pressType: PressType
                                                            .singleClick,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: (themeProvider
                                                                    .isDarkMode)
                                                                ? const Color(
                                                                    0xff67748E)
                                                                : const Color(
                                                                    0xffFFEEB0),
                                                          ),
                                                          width: 40,
                                                          child: Icon(
                                                            Icons.more_horiz,
                                                            color: Theme.of(
                                                                    context)
                                                                .textSelectionColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8),
                                                  child: Container(
                                                    color:
                                                        themeProvider.isDarkMode
                                                            ? const Color(
                                                                0xffC4C4C4)
                                                            : const Color(
                                                                0xffFFF5EC),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            _translate[index],
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                              fontSize: fontsize
                                                                  .value,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 16,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            _list[index]
                                                                .trim()
                                                                .replaceAll(
                                                                    'b', ''),
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    fontsize
                                                                        .value,
                                                                fontFamily:
                                                                    'MeQuran2',
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(child: Text('Loading...')),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            child: Slice2(
                                "${Provider.of<AyaProvider>(context).page}"))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: (themeProvider.isDarkMode)
                      ? const Color(0xffffffff)
                      : const Color(0xffFFB55F))),
          color:
              themeProvider.isDarkMode ? const Color(0xff666666) : Colors.white,
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MediaQuery.of(context).size.width < 600
                  ? IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: widget.allpages[i] != widget.allpages.first
                          ? () async {
                              Provider.of<AyaProvider>(context, listen: false)
                                  .previousPage();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .setDefault();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .readJsonData();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .readSliceData();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .readAya();
                              if (i < int.parse(widget.allpages.last)) {
                                setState(() {
                                  i--;
                                });
                                await getStartAyah(widget.allpages[i]);
                                await nextPage(widget.allpages[i]);
                              } else {
                                await getStartAyah(widget.allpages.first);
                                await nextPage(widget.allpages.first);
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
                          onPressed: widget.allpages[i] != widget.allpages.first
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
                                  if (i < int.parse(widget.allpages.last)) {
                                    setState(() {
                                      i--;
                                    });
                                    await getStartAyah(widget.allpages[i]);
                                    await nextPage(widget.allpages[i]);
                                  } else {
                                    await getStartAyah(widget.allpages.first);
                                    await nextPage(widget.allpages.first);
                                  }
                                }
                              : null,
                          child: Text(
                            'Previous page',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          )),
                    ),
              Consumer<AyaProvider>(builder: (context, number, child) {
                return ElevatedButton(
                    onPressed: number.page == int.parse(widget.allpages.first)
                        ? null
                        : () async {
                            Provider.of<AyaProvider>(context, listen: false)
                                .getPage(int.parse(widget.allpages.first));
                            Provider.of<AyaProvider>(context, listen: false)
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
                            await getStartAyah(widget.allpages.first);
                            await nextPage(widget.allpages.first);
                          },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 18),
                        primary: (themeProvider.isDarkMode)
                            ? const Color(0xff4C6A7A)
                            : const Color(0xffffeeb0)),
                    child: const Text(
                      'Beginning Surah',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ));
              }),
              MediaQuery.of(context).size.width < 600
                  ? IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: widget.allpages[i] != widget.allpages.last
                          ? () async {
                              Provider.of<AyaProvider>(context, listen: false)
                                  .nextPage();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .setDefault();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .readJsonData();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .readSliceData();
                              Provider.of<AyaProvider>(context, listen: false)
                                  .readAya();
                              if (i < int.parse(widget.allpages.last)) {
                                setState(() {
                                  i++;
                                });
                                await getStartAyah(widget.allpages[i]);
                                await nextPage(widget.allpages[i]);
                              } else {
                                await getStartAyah(widget.allpages.last);
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
                          onPressed: widget.allpages[i] != widget.allpages.last
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
                                  if (i < int.parse(widget.allpages.last)) {
                                    setState(() {
                                      i++;
                                    });
                                    await getStartAyah(widget.allpages[i]);
                                    await nextPage(widget.allpages[i]);
                                  } else {
                                    await getStartAyah(widget.allpages.last);
                                    await nextPage(widget.allpages.last);
                                  }
                                }
                              : null,
                          child: Text(
                            'Next page',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          )),
                    ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Spacer(),
          //     const Spacer(),
          //     ElevatedButton(
          //       onPressed: widget.allpages[i] != widget.allpages.first
          //           ? () async {
          //               if (i < int.parse(widget.allpages.last)) {
          //                 setState(() {
          //                   i--;
          //                 });
          //                 await getStartAyah(widget.allpages[i]);
          //                 await nextPage(widget.allpages[i]);
          //               } else {
          //                 await getStartAyah(widget.allpages.first);
          //                 await nextPage(widget.allpages.first);
          //               }
          //               print('${widget.allpages[i]}/${widget.allpages.last}');
          //             }
          //           : null,
          //       style: ElevatedButton.styleFrom(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 32, vertical: 18),
          //           primary: (themeProvider.isDarkMode)
          //               ? const Color(0xff808BA1)
          //               : const Color(0xfffcd77a)),
          //       child: const Text(
          //         'Previous Page',
          //         style: TextStyle(color: Colors.black, fontSize: 18),
          //       ),
          //     ),
          //     const SizedBox(width: 25),
          //     ElevatedButton(
          //         onPressed: () async {
          //           await getStartAyah(widget.allpages.first);
          //           await nextPage(widget.allpages.first);
          //           setState(() {
          //             i = 0;
          //           });
          //         },
          //         style: ElevatedButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 32, vertical: 18),
          //             primary: (themeProvider.isDarkMode)
          //                 ? const Color(0xff4C6A7A)
          //                 : const Color(0xffffeeb0)),
          //         child: const Text(
          //           'Beginning Surah',
          //           style: TextStyle(color: Colors.black, fontSize: 18),
          //         )),
          //     const SizedBox(width: 25),
          //     ElevatedButton(
          //         onPressed: widget.allpages[i] != widget.allpages.last
          //             ? () async {
          //                 if (i < int.parse(widget.allpages.last)) {
          //                   setState(() {
          //                     i++;
          //                   });
          //                   await getStartAyah(widget.allpages[i]);
          //                   await nextPage(widget.allpages[i]);
          //                 } else {
          //                   await getStartAyah(widget.allpages.last);
          //                   await nextPage(widget.allpages.last);
          //                 }
          //                 print(
          //                     '${widget.allpages[i]}/${widget.allpages.last}');
          //               }
          //             : null,
          //         style: ElevatedButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 32, vertical: 18),
          //             primary: (themeProvider.isDarkMode)
          //                 ? const Color(0xff808BA1)
          //                 : const Color(0xfffcd77a)),
          //         child: const Text(
          //           'Next Page',
          //           style: TextStyle(color: Colors.black, fontSize: 18),
          //         )),
          //     const Spacer(),
          //     Padding(
          //       padding: const EdgeInsets.only(right: 80.0),
          //       child: ElevatedButton(
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) =>
          //                         QuizHome(int.parse(widget.allpages[i]))));
          //           },
          //           style: ElevatedButton.styleFrom(
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 32, vertical: 18),
          //               primary: (themeProvider.isDarkMode)
          //                   ? const Color(0xff808BA1)
          //                   : const Color(0xfffcd77a)),
          //           child: const Text(
          //             'Quiz',
          //             style: TextStyle(color: Colors.black, fontSize: 18),
          //           )),
          //     ),
          //   ],
          // ),
        ),
      ),
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
    await Provider.of<AyaProvider>(context, listen: false).readJsonData();
    await Provider.of<AyaProvider>(context, listen: false).readSliceData();
    await Provider.of<AyaProvider>(context, listen: false).readAya();
    if (Provider.of<AyaProvider>(context, listen: false).visible == true) {
      await Provider.of<AyaProvider>(context, listen: false).set();
    }
  }
}
