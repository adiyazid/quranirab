import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/views/quran.home.dart';

import 'nav.draw.dart';

class Test extends StatefulWidget {
  final int p;
  final String name;
  final int s;
  final int e;

  const Test(this.p, this.name, this.s, this.e, {Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List<dynamic> surahList = [];
  int length = 0;

  ///current surah first page
  int? page;
  String? title;
  int? s;

  Future<String> loadFromAssets() async {
    return await rootBundle.loadString('assets/data/quran_text_all.json');
  }

  @override
  void initState() {
    super.initState();
    loadData(widget.p);
    page = widget.p;
    title = widget.name;
    s = widget.s;
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
      surahList.removeWhere((element) {
        return element.sura_id != "$s";
      });
      length = surahList.length;
    });
    print(length);
  }

  @override
  Widget build(BuildContext context) {

      return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: navDrawer(),
          appBar: AppBar(
            title: Text(title!),
            centerTitle: true,
            backgroundColor: Colors.orange[700],
            elevation: 0,
            actions: [

            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'RichText'),
                Tab(text: 'Column'),
              ],
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 15.0, left: 50),
                alignment: Alignment.topLeft,
                child: Text(
                  'Page Number :$page ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white ,
                  ),
                ),
              ),
              TabBarView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 1800,
                    padding: const EdgeInsets.all(25.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: surahList
                              .map((data) => TextSpan(
                                    text: data.text,
                                    style: TextStyle(
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
                    alignment: Alignment.center,
                    width: 1800,
                    padding: const EdgeInsets.all(25.0),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: surahList
                                .map(
                                  (e) => Text(
                                    e.text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'MeQuran2',
                                      fontSize: 30,
                                      color:  Colors.black,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )),
                  ),
                ],
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
                        onPressed: (page! > widget.p)
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
                          onPressed: (page! < widget.e)
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
        ),
      );

  }
}
