import 'dart:convert';

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
  SurahModel? surahModel;
  List<String>? surah = [];

  readJsonData() async {
    String jsonData = await rootBundle.loadString("assets/data/page.json");
    jsonData = jsonData.replaceAll("&lt;br /&gt;", "\\n");
    surahModel = SurahModel.fromJson(json.decode(jsonData));
    setState(() {
      surah = surahModel
          ?.plist?.dictparent?.arrayparent?.dictchild?.ayahArray?[1].ayah;
      print(surah);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJsonData();
  }

  @override
  Widget build(BuildContext context) {
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
                  width: 220,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
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
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 700,
                  child: Column(
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
                      Row(
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
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }
}
