import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/views/surah/almaidah.dart';

import '../nav.draw.dart';
import 'alaraf.dart';

class AlAnAm extends StatefulWidget {
  AlAnAm({Key? key}) : super(key: key);

  @override
  _AlAnAmState createState() => _AlAnAmState();
}

class _AlAnAmState extends State<AlAnAm> {
  List<dynamic> surahList = [];
  int length = 0;
  ///current surah no
  int i = 6;
  ///current surah first page
  int page = 128;
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
        return element.sura_id != "$i";
      });
      surahList.removeWhere((element) {
        return element.medina_mushaf_page_id != "$page";
      });
      length = surahList.length;
    });
    print(length);
  }

  checkColor(text) {
    if (text == ('ﺑ') ||
        text == ('ﴦ') ||
        text == ('ﻭ') ||
        text == ('ﵖﱔﵐ') ||
        text == ('ﻋﱺﻠﱁﻴ')) {
      return Colors.redAccent;
    } else if (text == ('ﺃﱁﻧﱦﻌﱧﻤ') ||
        text == ('ﭐﻫﱹﺪ') ||
        text == ('ﻧﱧﻌﱦﺒﱨﺪ') ||
        text == ('ﻧﱧﺴﱹﺘﱧﻌﲘﻴﻦ')) {
      return Colors.greenAccent;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          return Scaffold(
            drawer: navDrawer(),
            appBar: AppBar(
              ///surah name
              title: const Text('Al-An\'am'),
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
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 15.0, left: 50),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Surah no : $i Page no :$page ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Center(
                  child: Container(
                    ///adjust if surah per page was too long
                    width: 1000,
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: RichText(
                          text: TextSpan(
                            children: surahList
                                .map((data) => TextSpan(
                              text: data.text,
                              style: TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize: 30,
                                color: checkColor(data.text),
                              ),
                            ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(bottom: 65.0),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          ///more than current page
                            onPressed: (page > 128)
                                ? () {
                              setState(() {
                                page = page - 1;
                              });
                              loadData();
                            }
                                : () {
                              ///navigate to previous surah screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlMaidah()));
                            },
                            ///current surah start page
                            child: (page == 128)
                                ? const Text('Previous Surah')
                                : const Text('Previous Page')),
                        const SizedBox(width: 25),
                        ElevatedButton(
                          ///less than surah last page - 1
                            onPressed: (page < 150)
                                ? () {
                              setState(() {
                                page = page + 1;
                              });
                              loadData();
                            }
                                : () {
                              ///navigate to next surah
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlAraf()));
                            },
                            ///equal to last surah page - 1
                            child: (page == 150)
                                ? const Text('Next Surah')
                                : const Text('Next Page')),
                        const SizedBox(width: 25),
                        ///not equal to last surah page - 1
                        if (page != 150)
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  page = 150;
                                });
                                loadData();
                              },
                              child: const Text('End of Surah')),
                      ],
                    )),
              ],
            ),
          );
        });
  }
}
