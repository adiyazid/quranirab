import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/themes/theme_model.dart';

import '../nav.draw.dart';

class AlQuran extends StatefulWidget {
  const AlQuran({Key? key}) : super(key: key);

  @override
  _AlQuranState createState() => _AlQuranState();
}

class _AlQuranState extends State<AlQuran> {
  List<dynamic> surahList = [];
  int length = 0;
  int i = 1;

  Future<String> loadFromAssets() async {
    return await rootBundle.loadString('assets/data/quran_text_all.json');
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var jsonString = await loadFromAssets();
    var a = jsonDecode(jsonString);
    var ayahData = a.entries.map((e) => surah.fromJson(e.value)).toList();

    setState(() {
      surahList = ayahData;
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
          title: const Text('Quran Text'),
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
        body: ListView.builder(
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0,right: 130),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    surahList[index].text,
                    style: const TextStyle(
                        fontFamily: 'MeQuran2',
                        fontSize: 30,
                        color: Colors.black),
                  ),
                ),
              );
            }),
      );
    });
  }
}
