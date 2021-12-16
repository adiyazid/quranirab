import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/themes/theme_model.dart';

import '../nav.draw.dart';
import 'albaqarah.dart';

class Alfatihah extends StatefulWidget {
  const Alfatihah({Key? key}) : super(key: key);

  @override
  _AlfatihahState createState() => _AlfatihahState();
}

class _AlfatihahState extends State<Alfatihah> {
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
      surahList.removeWhere((element) {
        return element.sura_id != "1";
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
          title: const Text('Al-Fatihah'),
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
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15.0, left: 50),
              alignment: Alignment.topLeft,
              child: const Text(
                'Surah no : 1 Page no :1 ',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListView.builder(
                itemCount: length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Center(
                      child: (surahList[index].sura_id == '$i')
                          ? Text(
                              surahList[index].text,
                              style: const TextStyle(
                                  fontFamily: 'MeQuran2',
                                  fontSize: 30,
                                  color: Colors.black),
                            )
                          : null,
                    ),
                  );
                }),
            Container(
                padding: const EdgeInsets.only(bottom: 65.0),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AlBaqarah()));
                      },
                      child: const Text('Next Surah'),
                    )
                  ],
                )),
          ],
        ),
      );
    });
  }
}
