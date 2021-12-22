import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quranirab/models/surah.model.dart';
import 'package:quranirab/views/nav.draw.dart';
import 'package:quranirab/themes/theme_model.dart';

class Words extends StatefulWidget {
  const Words({Key? key}) : super(key: key);

  @override
  _WordsState createState() => _WordsState();
}

class _WordsState extends State<Words> {
  List<dynamic> ayatList = [];
  int length = 0;
  int i = 1;

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
      return Colors.blueAccent;
    }
  }

  Future<String> loadFromAssets() async {
    return await rootBundle.loadString('assets/data/words.json');
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var jsonString = await loadFromAssets();
    var a = jsonDecode(jsonString);
    var ayahData = a.entries.map((e) => SliceModel.fromJson(e.value)).toList();

    setState(() {
      ayatList = ayahData;
      ayatList.removeWhere((element) {
        return element.quranTextId != "1";
      });
      length = ayatList.length;
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
          centerTitle: true,
          title: const Text('Words-Json'),
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
          child: Container(
            width: 900,
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: ayatList
                      .map((data) => TextSpan(
                            text: data.text,
                            style: TextStyle(
                              fontFamily: 'MeQuran2',
                              fontSize: 40,
                              color: checkColor(data.text),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        // ListView.builder(
        //     itemCount: length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return Padding(
        //         padding: const EdgeInsets.only(top: 38.0),
        //         child: Center(
        //           child: Text(
        //             ayatList[index].text,
        //             style: TextStyle(
        //                 fontFamily: 'MeQuran2',
        //                 fontSize: 30,
        //                 color: checkColor(ayatList[index].text)),
        //           ),
        //         ),
        //       );
        //     }),
      );
    });
  }
}
