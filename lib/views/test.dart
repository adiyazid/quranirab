import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/views/quran.home.dart';

import 'nav.draw.dart';

class Test extends StatefulWidget {
  final int p;
  final String name;

  const Test(this.p, this.name, {Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<dynamic> surahList = [];
  int length = 0;

  ///current surah first page
  int? page;
  String? title;

  Future<String> loadFromAssets() async {
    return await rootBundle.loadString('assets/data/quran_text_all.json');
  }

  @override
  void initState() {
    super.initState();
    loadData(widget.p);
    page = widget.p;
    title = widget.name;
    print(page);
    print(title);
  }

  loadData(int p) async {
    var jsonString = await loadFromAssets();
    var a = jsonDecode(jsonString);
    var ayahData = a.entries.map((e) => surah.fromJson(e.value)).toList();
    setState(() {
      surahList = ayahData;
      surahList.removeWhere((element) {
        return element.medina_mushaf_page_id != "$p";
      });
      length = surahList.length;
    });
    print(length);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        drawer: navDrawer(),
        appBar: AppBar(
          title: Text(title!),
          centerTitle: true,
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
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 15.0, left: 50),
              alignment: Alignment.topLeft,
              child: Text(
                'Page Number :$page ',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,

              ///adjust if surah per page was too long
              width: 900,
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: RichText(
                  text: TextSpan(
                    children: surahList
                        .map((data) => TextSpan(
                              text: data.text,
                              style: const TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(bottom: 65.0, right: 40),
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QuranHome()));
                        },
                        child: const Text("Choose Surah again")),
                    const SizedBox(width: 25),
                    ElevatedButton(
                      ///more than current page
                      onPressed: (page! > 1)
                          ? () {
                              setState(() {
                                page = (page! - 1);
                              });
                              loadData(page!);
                            }
                          : null,
                      child: const Text('Previous Page'),
                    ),
                    const SizedBox(width: 25),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            page = widget.p;
                            title = widget.name;
                          });
                          loadData(page!);
                        },
                        child: const Text('Beginning of Surah')),
                    const SizedBox(width: 25),
                    ElevatedButton(
                        onPressed: (page! < 604)
                            ? () {
                                setState(() {
                                  page = (page! + 1);
                                });
                                loadData(page!);
                              }
                            : null,
                        child: const Text('Next Page')),
                    const SizedBox(width: 25),
                  ],
                )),
          ],
        ),
      );
    });
  }
}
