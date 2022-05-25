import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/language.dart';
import 'package:quranirab/widget/menu.dart';


class MushafPage extends StatefulWidget {
  const MushafPage({Key? key}) : super(key: key);

  @override
  _MushafPageState createState() => _MushafPageState();
}

class _MushafPageState extends State<MushafPage> {
  ScrollController? _controller;

  List _suraList = [];
  final CollectionReference _collectionRefs =
      FirebaseFirestore.instance.collection('suras');

  Future<void> getDatas() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRefs.orderBy("created_at").get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _suraList = allData;
    });
  }

  bool a = false;
  bool b = true;
  bool isSearch = false;

  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('quran_translations');

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

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    super.initState();
    getData();
    getDatas();
  }

  Color? _check() {
    if (a) {
      return const Color(0xffE0BD61);
    } else {
      return null;
    }
  }

  Color? _checkDark() {
    if (a) {
      return const Color(0xff4C6A7A);
    } else {
      return null;
    }
  }

  Color? _check2() {
    if (b) {
      return const Color(0xffE0BD61);
    } else {
      return null;
    }
  }

  Color? _checkDark2() {
    if (b) {
      return const Color(0xff4C6A7A);
    } else {
      return null;
    }
  }

  final TextEditingController _search = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var alfatihah =
        ' بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ﴾١﴿ bٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ ﴾٢﴿ bٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ﴾٣﴿ مَـٰلِكِ يَوْمِ ٱلدِّينِ ﴾٤﴿b إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴾٥﴿ ٱهْدِنَاbٱلصِّرَ ٰطَ ٱلْمُسْتَقِيمَ ﴾٦﴿ صِرَ ٰطَ ٱلَّذِينَ أَنْعَمْتَbعَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْbوَلَا ٱلضَّآلِّينَ ﴾٧﴿b';

    final PageController controller = PageController();
    var screenSize = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FutureBuilder(
        future: checkFontSize(),
        initialData: 50,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Scaffold(
                  drawer: const Menu(),
                  appBar: AppBar(
                    iconTheme: Theme.of(context).iconTheme,
                    title: Row(
                      children: const [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/quranirab.png'),
                          radius: 18.0,
                        ),
                      ],
                    ),
                    elevation: 0,
                    centerTitle: false,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    actions: <Widget>[
                      IconButton(
                        tooltip:
                            MaterialLocalizations.of(context).searchFieldLabel,
                        onPressed: () => setState(() {
                          isSearch = true;
                        }),
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Language()),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(
                            Icons.settings,
                          ),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        ),
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      isSearch ? buildSuggestions(context) : Container(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          color: (themeProvider.isDarkMode)
                              ? const Color(0xff808ba1)
                              : const Color(0xfffff3ca),
                          width: screenSize.width * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14.0, top: 153),
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                    child: const Text(
                                      'The Straight',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                    child: const Text(
                                      'Nu\' al-kalimah',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                    child: const Text(
                                      'Isim',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                    child: const Text(
                                      'Sorof',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                    child: const Text(
                                      'Nahu',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 250.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: (themeProvider.isDarkMode)
                                      ? const Color(0xff808BA1)
                                      : const Color(0xffFFF3CA)),
                              width: screenSize.width * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        width: screenSize.width * 0.12,
                                        height: 37,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: (themeProvider.isDarkMode)
                                                ? _checkDark()
                                                : _check()),
                                        child: const Center(
                                            child: Text(
                                          'Translation',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.black),
                                        )),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          a = true;
                                          b = false;
                                          controller.jumpToPage(1);
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width: screenSize.width * 0.12,
                                        height: 37,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: (themeProvider.isDarkMode)
                                                ? _checkDark2()
                                                : _check2()),
                                        child: const Center(
                                            child: Text(
                                          'Reading',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.black),
                                        )),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          a = false;
                                          b = true;
                                          controller.jumpToPage(0);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 128, left: 250.0),
                        child: Align(
                          child: SizedBox(
                            height: screenSize.height,
                            width: screenSize.width * 0.5,
                            child:PageView(
                              controller: controller,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          alfatihah.replaceAll('b', '\n'),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: 'MeQuran2',
                                              fontSize: 40),
                                        )),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _list.length,
                                        controller: _controller,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            color: (themeProvider.isDarkMode)
                                                ? const Color(0xffC4C4C4)
                                                : const Color(0xffFFF5EC),
                                            child: ListTile(
                                              title: Text(
                                                '1:${index + 1}',
                                                style:
                                                    const TextStyle(fontSize: 18),
                                              ),
                                              subtitle: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _list[index],
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 250, bottom: 30.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    primary: (themeProvider.isDarkMode)
                                        ? const Color(0xff808BA1)
                                        : const Color(0xfffcd77a)),
                                child: const Text(
                                  'Previous Page',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 25),
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      primary: (themeProvider.isDarkMode)
                                          ? const Color(0xff4C6A7A)
                                          : const Color(0xffffeeb0)),
                                  child: const Text(
                                    'Beginning Surah',
                                    style: TextStyle(color: Colors.black),
                                  )),
                              const SizedBox(width: 25),
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      primary: (themeProvider.isDarkMode)
                                          ? const Color(0xff808BA1)
                                          : const Color(0xfffcd77a)),
                                  child: const Text(
                                    'Next Page',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<double> checkFontSize() async {
    return fontData.size;
  }

  buildSuggestions(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    List listToShow;
    if (_search.text.isNotEmpty) {
      listToShow = _suraList
          .map((e) => e["tname"])
          .where((e) =>
              e.toLowerCase().contains(_search.text) ||
              e.toUpperCase().contains(_search.text))
          .toList();
    } else {
      listToShow = _suraList.map((e) => e["tname"]).toList();
    }

    return Visibility(
      visible: isSearch,
      child: Positioned(
        right: 100,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 300,
            width: 200,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: (themeProvider.isDarkMode)
                  ? const Color(0xff67748E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.orange),
            ),
            child: Stack(children: [
              Positioned(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    child: TextField(
                      controller: _search,
                      onChanged: (v) async {
                        setState(() {
                          if (v.isEmpty) {
                            isSearch = false;
                          }
                          isSearch = true;
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          label: Text(
                            "Search",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _search.clear();
                                  isSearch = false;
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Theme.of(context).iconTheme.color,
                              ))),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 55,
                left: 5,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    height: 310,
                    child: ListView.builder(
                      itemCount: listToShow.length,
                      itemBuilder: (_, i) {
                        var surahs = listToShow[i];
                        return GestureDetector(
                          child: ListTile(
                            title: Text(surahs),
                          ),
                          onTap: () {
                            setState(() {
                              isSearch = false;
                              _search.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
