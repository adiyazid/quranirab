import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/widgets/circle_button.dart';
import 'package:quranirab/facebook/widgets/more_options_list.dart';
import 'package:quranirab/facebook/widgets/responsive.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/SettingPopup.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';

import 'Appbar/appbar.dart';

class FacebookHomeScreen extends StatefulWidget {
  const FacebookHomeScreen({Key? key}) : super(key: key);

  @override
  _FacebookHomeScreenState createState() => _FacebookHomeScreenState();
}

class _FacebookHomeScreenState extends State<FacebookHomeScreen> {
  final TrackingScrollController _trackingScrollController =
  TrackingScrollController();

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Responsive(
          mobile: () {
            return _HomeScreenMobile(
                scrollController: _trackingScrollController);
          },
          desktop: () {
            return _HomeScreenDesktop(
                scrollController: _trackingScrollController);
          },
        ),
      ),
    );
  }
}

class _HomeScreenMobile extends StatelessWidget {
  final TrackingScrollController scrollController;

  const _HomeScreenMobile({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      //endDrawer: const Setting(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            SizedBox(
              height: 115,
              child: CustomScrollView(
                controller: scrollController,
                slivers: const [
                  Appbar(),
                  // TabBarWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenDesktop extends StatefulWidget {
  final TrackingScrollController scrollController;

  const _HomeScreenDesktop({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<_HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<_HomeScreenDesktop> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xff666666),
      drawer: const Menu(),
      //endDrawer: const Setting(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                title: const CircleAvatar(
                  backgroundImage: AssetImage('assets/quranirab.png'),
                  radius: 18.0,
                ),
                centerTitle: false,
                floating: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(onPressed: () {  }, icon: const Icon(Icons.search,size: 26.0,)
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: LangPopup()
                  ),
                  const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: SettingPopup()
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(120),
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          color: const Color(0xff666666),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Al-Fatihah',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'The Opener',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
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
                            children: const [
                              VerticalDivider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 16),
                              Flexible(
                                child: Text(
                                  'Juz 1 / Hizb 1 - Page 1',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          MdiIcons.bookOpen,
                          color: (themeProvider.isDarkMode)
                              ? const Color(0xffD2D6DA)
                              : const Color(0xffE86F00),
                        ),
                        const Spacer(),
                      ]),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xff67748E),
                        child: TabBar(
                            indicatorPadding: const EdgeInsets.all(8),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // Creates border
                                color: const Color(0xff808BA1)),
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tab(
                                  child: Text(
                                    'Translationsa',
                                    style: TextStyle(
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
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              TranslationPage(),
              SurahPage('1', '1'),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  String text;
  IconData icon;

  ItemModel(this.text, this.icon);
}

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  List _list = [];
  final CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('quran_translations');

  List menuItems = [
    ItemModel('Share', Icons.share),
    ItemModel('Bookmark', Icons.bookmarks),
  ];
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('translation_id', isEqualTo: "2")
        .where('sura_id', isEqualTo: "1")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
    //convert dynamic map list into string list
    var data = _list.map((e) => e["text"]).toList();
    setState(() {
      _list = data;
    });
  }

  ScrollController? _controllers;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: (themeProvider.isDarkMode)
                ? const Color(0xffffffff)
                : const Color(0xffFFB55F)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.78,
                child: ListView.builder(
                  itemCount: _list.length,
                  controller: _controllers,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 132,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        color: (themeProvider.isDarkMode)
                            ? const Color(0xffC4C4C4)
                            : const Color(0xffFFF5EC),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xff67748E),
                                    ),
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        '1:${index + 1}',
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CustomPopupMenu(
                                    menuBuilder: () => ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        color: const Color(0xFF4C4C4C),
                                        child: IntrinsicWidth(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                            children: menuItems
                                                .map(
                                                  (item) => GestureDetector(
                                                behavior: HitTestBehavior
                                                    .translucent,
                                                onTap: _controller.hideMenu,
                                                child: Container(
                                                  height: 40,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        item.icon,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 10),
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical:
                                                              10),
                                                          child: Text(
                                                            item.text,
                                                            style:
                                                            const TextStyle(
                                                              color: Colors
                                                                  .white,
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
                                    pressType: PressType.singleClick,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xff67748E),
                                      ),
                                      width: 40,
                                      child: Icon(Icons.more_horiz),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _list[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SurahPage extends StatefulWidget {
  final String id;
  final String surah;

  const SurahPage(this.id, this.surah, {Key? key}) : super(key: key);

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool onhover = false;

  var ontap = false;
  Color? textColor;

  Color changeBlue() {
    var c = Colors.blueAccent;
    return c;
  }

  Color changeRed() {
    var c = Colors.redAccent;
    return c;
  }

  final List _list = [];
  int? a = 0;
  String? b;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    getStartAyah();
    super.initState();
  }

  final CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('quran_texts');
  final CollectionReference _collectionRefs =
  FirebaseFirestore.instance.collection('medina_mushaf_pages');

  Future<void> getData() async {
    // Get docs from collection reference
    await _collectionRef
        .where('medina_mushaf_page_id', isEqualTo: widget.id)
        .where('sura_id', isEqualTo: widget.surah)
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

  Future<void> getStartAyah() async {
    // Get docs from collection reference
    await _collectionRefs
        .where('id', isEqualTo: widget.id)
        .where('sura_id', isEqualTo: widget.surah)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          a = int.parse(doc['aya']);
        });
        print(a);
      }
    });
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Center(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int i) {
                if (context.debugDoingBuild) {
                  return const CircularProgressIndicator();
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      ontap = true;
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      ontap = false;
                    });
                  },
                  child: Tooltip(
                    message: 'Click to show details ayah ${i + 1}',
                    child: Text(
                      _list.isNotEmpty
                          ? _list[i]
                          .replaceAll(
                          '﴿${ArabicNumbers().convert(i + a!)}﴾',
                          '﴾${ArabicNumbers().convert(i + a!)}﴿')
                          .trim()
                          : '',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 40,
                          fontFamily: 'MeQuran2',
                          color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: ontap,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}