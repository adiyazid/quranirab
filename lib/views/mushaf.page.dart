import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/views/surah_model.dart';
import 'package:quranirab/widget/language.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';

class MushafPage extends StatefulWidget {
  const MushafPage({Key? key}) : super(key: key);

  @override
  _MushafPageState createState() => _MushafPageState();
}

class _MushafPageState extends State<MushafPage> {
  ScrollController? _controller;
  SurahModel? surahModel;
  SurahModel? surahModel1;
  List<String>? surah = [];
  List<String>? sur = [];
  bool a = false;
  bool b = true;

  readJsonData() async {
    String jsonData = await rootBundle.loadString("assets/data/page.json");
    String jsonData1 = await rootBundle.loadString("assets/data/page.json");
    jsonData = jsonData.replaceAll("&lt;br /&gt;", "\\n");
    jsonData1 = jsonData1.replaceAll("&lt;br /&gt;", "");
    surahModel = SurahModel.fromJson(json.decode(jsonData));
    surahModel1 = SurahModel.fromJson(json.decode(jsonData1));
    setState(() {
      surah = surahModel
          ?.plist?.dictparent?.arrayparent?.dictchild?.ayahArray?[1].ayah;
      sur = surahModel1
          ?.plist?.dictparent?.arrayparent?.dictchild?.ayahArray?[1].ayah;
    });
  }

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

  bool isSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    super.initState();
    readJsonData();
    getData();
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

  var f = 50.0;
  Setting s = Setting();

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    var screenSize = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        drawer: Menu(),
        endDrawer: Setting(),
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
              tooltip: MaterialLocalizations.of(context).searchFieldLabel,
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
                padding: const EdgeInsets.only(right: 20.0), child: Language()),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
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
                          child: Text(
                            'The Straight',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          child: Text(
                            'Nu\' al-kalimah',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          child: Text(
                            'Isim',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          child: Text(
                            'Sorof',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          child: Text(
                            'Nahu',
                            style: Theme.of(context).textTheme.bodyText2,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: screenSize.width * 0.12,
                              height: 37,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
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
                                  borderRadius: BorderRadius.circular(8),
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
              padding: const EdgeInsets.only(left: 250.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: screenSize.width * 0.7,
                  height: 850,
                  child: PageView(
                    controller: controller,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: surah!
                                    .map((data) => TextSpan(
                                          text: data,
                                          style: TextStyle(
                                            fontFamily: 'Meor',
                                            fontSize: fontData.size,
                                            color: (themeProvider.isDarkMode)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: sur!.length,
                              controller: _controller,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: (themeProvider.isDarkMode)
                                      ? const Color(0xffC4C4C4)
                                      : const Color(0xffFFF5EC),
                                  child: ListTile(
                                    title: Text(
                                      '1:${index + 1}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _list[index],
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Expanded(
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              sur![index],
                                              style: TextStyle(
                                                  fontFamily: 'Meor',
                                                  fontSize: f,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )
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
                          primary: const Color(0xfffcd77a)),
                      child: const Text(
                        'Previous Page',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 25),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xffffeeb0)),
                        child: const Text(
                          'Beginning Surah',
                          style: TextStyle(color: Colors.black),
                        )),
                    const SizedBox(width: 25),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xfffcd77a)),
                        child: const Text(
                          'Next Page',
                          style: TextStyle(color: Colors.black),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  getFontSize() {
    if (fontData.index == 0) {
      fontData.size = 40;
      return fontData.size;
    } else if (fontData.index == 2) {
      fontData.size = 60;
      return fontData.size;
    }
  }
}
