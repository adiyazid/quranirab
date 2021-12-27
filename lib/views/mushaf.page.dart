import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/views/surah_model.dart';

import 'nav.draw.dart';

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
      print(surah);
      sur = surahModel1
          ?.plist?.dictparent?.arrayparent?.dictchild?.ayahArray?[1].ayah;
      print(sur);
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

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    var screenSize = MediaQuery.of(context).size;

    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          drawer: navDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.orange[700],
            elevation: 0,
            actions: [
              IconButton(
                  icon: Icon(
                      themeNotifier.isDark
                          ? Icons.nightlight_round
                          : Icons.wb_sunny,
                      color: themeNotifier.isDark
                          ? Colors.white
                          : Colors.grey.shade900),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  })
            ],
          ),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: (themeNotifier.isDark)
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
                          color: (themeNotifier.isDark)
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
                                    color: (themeNotifier.isDark)
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
                                    color: (themeNotifier.isDark)
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
                                              fontSize: 50,
                                              color: (themeNotifier.isDark)
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
                                    color: (themeNotifier.isDark)
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
                                                style: const TextStyle(
                                                    fontFamily: 'Meor',
                                                    fontSize: 40,
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
    });
  }
}
