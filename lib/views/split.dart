import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/themes/theme_model.dart';

import 'nav.draw.dart';

class Split extends StatefulWidget {
  const Split({Key? key}) : super(key: key);

  @override
  _SplitState createState() => _SplitState();
}

class _SplitState extends State<Split> {
  List<dynamic> surahList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<String> loadFromAssets() async {
    return await rootBundle.loadString('assets/data/quran_text_all.json');
  }

  Future<dynamic> loadData() async {
    var jsonString = await loadFromAssets();
    var a = jsonDecode(jsonString);
    var ayahData = a.entries.map((e) => surah.fromJson(e.value)).toList();
    setState(() {
      surahList = ayahData;
      surahList.removeWhere((element) {
        return element.medina_mushaf_page_id != "1";
      });
      surahList.removeWhere((element) {
        return element.sura_id != "1";
      });
    });
    return surahList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
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
                  body: Center(
                    child: Column(
                      children: [
                        Text(
                          ' bismi ${snapshot.data[0].text.substring(0, 5)} ',
                          style: const TextStyle(
                              fontFamily: 'MeQuran2',
                              color: Colors.black,
                              fontSize: 50),
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
          } else {
            return Container();
          }
        });
  }
}
