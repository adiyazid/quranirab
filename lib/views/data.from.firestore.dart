import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';

import 'nav.draw.dart';

class DataFromFirestore extends StatefulWidget {
  const DataFromFirestore({Key? key}) : super(key: key);

  @override
  _DataFromFirestoreState createState() => _DataFromFirestoreState();
}

class _DataFromFirestoreState extends State<DataFromFirestore> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('suras');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('created_at').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
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
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: _list
                        .map((data) => ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PageScreen(
                                            data["id"], data["start_line"])));
                              },
                              child: Text(
                                '${data["start_line"]}',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'MeQuran2',
                                    color: (themeNotifier.isDark)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class PageScreen extends StatefulWidget {
  final String surah;
  final String surah_name;

  const PageScreen(this.surah, this.surah_name, {Key? key}) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('sura_relationships');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('sura_id', isEqualTo: widget.surah)
        .orderBy('created_at')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          widget.surah_name,
          style: const TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
        ),
      ),
      body: Center(
        child: Wrap(
          children: _list
              .map((data) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurahScreen(
                                    data["medina_mushaf_page_id"],
                                    widget.surah)));
                      },
                      child: Text(
                        'Page ${data["medina_mushaf_page_id"]}',
                        style: TextStyle(
                            fontSize: 40,
                            color: (isDark) ? Colors.white : Colors.black),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class SurahScreen extends StatefulWidget {
  final String id;
  final String surah;

  const SurahScreen(this.id, this.surah, {Key? key}) : super(key: key);

  @override
  _SurahScreenState createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('quran_texts');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('medina_mushaf_page_id', isEqualTo: widget.id)
        .where('sura_id', isEqualTo: widget.surah)
        .orderBy('created_at')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          'Page Number ${widget.id}',
          style: const TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: _list
                .map((data) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        '${data["text1"]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'MeQuran2',
                            color: (isDark) ? Colors.white : Colors.black),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
