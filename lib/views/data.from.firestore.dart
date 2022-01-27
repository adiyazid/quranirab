import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/screens/Translation/translation.dart';
import 'package:quranirab/facebook/widgets/more_options_list.dart';
import 'package:quranirab/facebook/widgets/more_options_list2.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/TranslationPopup.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:quranirab/widget/responsive.dart' as w;
import 'nav.draw.dart';

class DataFromFirestore extends StatefulWidget {
  const DataFromFirestore({Key? key}) : super(key: key);

  @override
  _DataFromFirestoreState createState() => _DataFromFirestoreState();
}

class _DataFromFirestoreState extends State<DataFromFirestore> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('suras');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('created_at').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        elevation: 0,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: _list
                      .map((data) => ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PageScreen(
                                          data["id"], data["start_line"])));
                            },
                            child: Text(
                              '${data["start_line"]}',
                              style: const TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'MeQuran2',
                                  color: Colors.white),
                            ),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageScreen extends StatefulWidget {
  final String surah;
  final String surah_name;

  const PageScreen(this.surah, this.surah_name, {Key? key}) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('sura_relationships');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('sura_id', isEqualTo: widget.surah)
        .orderBy('created_at')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          widget.surah_name,
          style: const TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
        ),
      ),
      body: Center(
        child: Wrap(
          children: _list
              .map((data) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurahScreen(
                                    data["medina_mushaf_page_id"],
                                    widget.surah)));
                      },
                      child: Text(
                        'Page ${data["medina_mushaf_page_id"]}',
                        style: TextStyle(
                            fontSize: 40,
                            color: (isDark) ? Colors.white : Colors.black),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class SurahScreen extends StatefulWidget {
  final String id;
  final String surah;

  const SurahScreen(this.id, this.surah, {Key? key}) : super(key: key);

  @override
  _SurahScreenState createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final List _list = [];
  int? a = 0;
  String? b;

  bool visible = false;

  bool color = true;

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
  var c = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontsize = Provider.of<FontSizeController>(context);
    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? const Color(0xff666666) : Colors.white,
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
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: TabBarView(
              children: [
                TranslationPage(widget.surah, widget.id),
                Container(
                  color: themeProvider.isDarkMode
                      ? const Color(0xff9A9A9A)
                      : const Color(0xffFFF5EC),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: themeProvider.isDarkMode
                              ? const Color(0xff9A9A9A)
                              : const Color(0xffFFF5EC),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: _list.isNotEmpty
                                  ? Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              children: _list
                                                  .map(
                                                    (e) => TextSpan(
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              setState(() {
                                                                visible = true;
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
                                                      text: e.trim().replaceAll(
                                                          'b', '\n'),
                                                      style: TextStyle(
                                                          fontSize:
                                                              fontsize.value,
                                                          fontFamily:
                                                              'MeQuran2',
                                                          color: color
                                                              ? Colors.black
                                                              : Colors.blue),
                                                    ),
                                                  )
                                                  .toList())),
                                    )
                                  : const Text('Loading...'),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onDoubleTap: () {
                          setState(() {
                            visible = false;
                          });
                        },
                        child: Visibility(
                          visible: visible,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
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
                        ),
                      ),
                    ],
                  ),
                )
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
        height: MediaQuery.of(context).size.height * 0.08,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    primary: (themeProvider.isDarkMode)
                        ? const Color(0xff808BA1)
                        : const Color(0xfffcd77a)),
                child: const Text(
                  'Previous Page',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              const SizedBox(width: 25),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      primary: (themeProvider.isDarkMode)
                          ? const Color(0xff4C6A7A)
                          : const Color(0xffffeeb0)),
                  child: const Text(
                    'Beginning Surah',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
              const SizedBox(width: 25),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      primary: (themeProvider.isDarkMode)
                          ? const Color(0xff808BA1)
                          : const Color(0xfffcd77a)),
                  child: const Text(
                    'Next Page',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
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
}
