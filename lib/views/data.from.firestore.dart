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
      FirebaseFirestore.instance.collection('quran_texts');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('sura_id', isEqualTo: "1")
        .where('medina_mushaf_page_id', isEqualTo: "1")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
    print(_list);
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: _list
                        .map((data) => TextSpan(
                              text: data["text"],
                              style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: "MeQuran2",
                                  color: (themeNotifier.isDark)
                                      ? Colors.white
                                      : Colors.black),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
