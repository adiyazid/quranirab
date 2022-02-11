import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart';
import 'package:quranirab/facebook/screens/home_screen_1.dart';
import 'package:quranirab/facebook/widgets/more_options_list.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/quiz_module/quiz.home.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/TranslationPopup.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:quranirab/widget/responsive.dart' as w;

class DataFromFirestore extends StatefulWidget {
  const DataFromFirestore({Key? key}) : super(key: key);

  @override
  _DataFromFirestoreState createState() => _DataFromFirestoreState();
}

class _DataFromFirestoreState extends State<DataFromFirestore> {
  late AsyncMemoizer _memoizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _memoizer = AsyncMemoizer();
    getData();
  }

  List _total = [];
  final CollectionReference _collectionSura =
      FirebaseFirestore.instance.collection('sura_relationships');

  Future<List> getTotalPage(String id) async {
    QuerySnapshot querySnapshot = await _collectionSura
        .where('sura_id', isEqualTo: id)
        .orderBy('created_at')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _total = allData;
    });
    var data = _total.map((e) => e["medina_mushaf_page_id"]).toList();
    return data;
  }

  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('suras');

  Future<void> getData() => _memoizer.runOnce(() async {
        // Get docs from collection reference
        QuerySnapshot querySnapshot =
            await _collectionRef.orderBy('created_at').get();

        // Get data from docs and convert map to List
        final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        setState(() {
          _list = allData;
        });
      });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontsize = Provider.of<FontSizeController>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? const Color(0xff666666) : Colors.white,
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
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        size: 26.0,
                      )),
                ),
                const Padding(
                    padding: EdgeInsets.only(right: 20.0), child: LangPopup()),
                const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SettingPopup()),
              ],
            ),
          ];
        },
        body: Center(
          child: SingleChildScrollView(
            child: _list.isEmpty
                ? Text('Loading...')
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          children: _list
                              .map((data) => Card(
                                    child: InkWell(
                                      onTap: () async {
                                        var a = await getTotalPage(data["id"]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SurahScreen(
                                                      a,
                                                      data["id"],
                                                      data["start_line"],
                                                      data["tname"],
                                                      data["ename"],
                                                    )));
                                      },
                                      child: ListTile(
                                        title: Text(
                                          '${data["start_line"]} (${data["tname"]})',
                                          style: TextStyle(
                                              fontSize: fontsize.value,
                                              fontFamily: 'MeQuran2',
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          '${data["ename"]}',
                                          style: TextStyle(
                                              fontSize: fontsize.value,
                                              fontFamily: 'MeQuran2',
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SurahScreen extends StatefulWidget {
  final List allpages;
  final String sura_id;
  final String surah;
  final String name;
  final String detail;

  const SurahScreen(
      this.allpages, this.sura_id, this.surah, this.name, this.detail,
      {Key? key})
      : super(key: key);

  @override
  _SurahScreenState createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  List _list = [];
  int? a = 0;
  String? b;

  int? start = 1;

  List _translate = [];
  final CollectionReference _collectionTranslate =
      FirebaseFirestore.instance.collection('quran_translations');

  var hizb;

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
          _list.add(doc['text1']);
        });
      }
    });
    _list.any((e) => e.contains('b'));
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
    final fontsize = Provider.of<FontSizeController>(context);
    return Scaffold(
      backgroundColor: (themeProvider.isDarkMode)
          ? const Color(0xff666666)
          : const Color(0xFFffffff),
      drawer: const Menu(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          size: 26.0,
                        )),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: LangPopup()),
                  const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: SettingPopup()),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(120),
                  child: Column(
                    children: [
                      Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  widget.detail,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.keyboard_arrow_down),
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
                        SizedBox(
                          width: 320,
                          child: Row(
                            children: [
                              VerticalDivider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 16),
                              hizb != null
                                  ? Flexible(
                                      child: Text(
                                        'Juz ${getJuzNumber(int.parse(widget.sura_id), start!)} / Hizb $hizb - Page ${widget.allpages[i]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, right: 8),
                          child: TransPopup(),
                        ),
                      ]),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                w.Responsive.isDesktop(context) ? 400.0 : 80),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TabBar(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Visibility(
                                      visible: true,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: (themeProvider.isDarkMode)
                                                  ? const Color(0xffffffff)
                                                  : const Color(0xffFFB55F)),
                                          color: (themeProvider.isDarkMode)
                                              ? const Color(0xff808ba1)
                                              : const Color(0xfffff3ca),
                                        ),
                                        child: const MoreOptionsList(
                                          surah: 'Straight',
                                          nukKalimah: '',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: ListView.builder(
                                          itemCount: _list.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final fontsize =
                                                Provider.of<FontSizeController>(
                                                    context);
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
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
                                                        const SizedBox(
                                                            width: 8),
                                                        CustomPopupMenu(
                                                          menuBuilder: () =>
                                                              ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
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
                                                                              behavior: HitTestBehavior.translucent,
                                                                              onTap: _controller.hideMenu,
                                                                              child: Container(
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
                                                      color: themeProvider
                                                              .isDarkMode
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    fontsize
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
                      Container(
                        color: themeProvider.isDarkMode
                            ? const Color(0xff9A9A9A)
                            : const Color(0xffFFF5EC),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.33,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (themeProvider.isDarkMode)
                                          ? const Color(0xffffffff)
                                          : const Color(0xffFFB55F)),
                                  color: (themeProvider.isDarkMode)
                                      ? const Color(0xff808ba1)
                                      : const Color(0xfffff3ca),
                                ),
                                child: MoreOptionsList(
                                  surah: 'Straight',
                                  nukKalimah: c,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: _list.isNotEmpty
                                  ? Container(
                                      color: themeProvider.isDarkMode
                                          ? const Color(0xff9A9A9A)
                                          : const Color(0xffFFF5EC),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                children: _list
                                                    .map(
                                                      (e) => TextSpan(
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                setState(() {
                                                                  visible =
                                                                      true;
                                                                });
                                                              },
                                                        onEnter: (e) {
                                                          setState(() {
                                                            color = false;
                                                          });
                                                        },
                                                        onExit: (e) {
                                                          setState(() {
                                                            color = true;
                                                          });
                                                        },
                                                        text: e
                                                            .trim()
                                                            .replaceAll(
                                                                'b', '\n'),
                                                        style: TextStyle(
                                                            fontSize:
                                                                fontsize.value,
                                                            fontFamily:
                                                                'MeQuran2',
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )
                                                    .toList())),
                                      ),
                                    )
                                  : const Text('Loading...'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Spacer(),
              ElevatedButton(
                onPressed: widget.allpages[i] != widget.allpages.first
                    ? () async {
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
                        print('${widget.allpages[i]}/${widget.allpages.last}');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 18),
                    primary: (themeProvider.isDarkMode)
                        ? const Color(0xff808BA1)
                        : const Color(0xfffcd77a)),
                child: const Text(
                  'Previous Page',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(width: 25),
              ElevatedButton(
                  onPressed: () async {
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
                  child: const Text(
                    'Beginning Surah',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  )),
              const SizedBox(width: 25),
              ElevatedButton(
                  onPressed: widget.allpages[i] != widget.allpages.last
                      ? () async {
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
                          print(
                              '${widget.allpages[i]}/${widget.allpages.last}');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 18),
                      primary: (themeProvider.isDarkMode)
                          ? const Color(0xff808BA1)
                          : const Color(0xfffcd77a)),
                  child: const Text(
                    'Next Page',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  )),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 80.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuizHome(int.parse(widget.allpages[i]))));
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 18),
                        primary: (themeProvider.isDarkMode)
                            ? const Color(0xff808BA1)
                            : const Color(0xfffcd77a)),
                    child: const Text(
                      'Quiz',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )),
              ),
            ],
          ),
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
  }
}
