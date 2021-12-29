import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quranirab/views/nav.draw.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/views/split.dart';

import 'data.from.firestore.dart';
import 'mushaf.page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearch = false;
  List _suraList = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('suras');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy("created_at").get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _suraList = allData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  final TextEditingController _search = TextEditingController();
  String surah = 'Surah Name';
  String detail = 'Surah Detail';
  String arab = 'Arabic Name';

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        drawer: navDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          elevation: 20,
          actions: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _search,
                onChanged: (v) async {
                  setState(() {
                    if (v.isEmpty) {
                      isSearch = false;
                    }
                    isSearch = true;
                  });
                },
                decoration: InputDecoration(
                  label: const Text(
                    "Search",
                    style: TextStyle(color: Colors.black),
                  ),
                  suffixIcon: (isSearch)
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _search.clear();
                              isSearch = false;
                            });
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ))
                      : const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
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
        body: Column(
          children: [
            isSearch
                ? buildSuggestions(context)
                : Container(
                    height: 300,
                  ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  width: 500,
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange),
                  ),
                  //             <--- BoxDecoration here
                  child: GestureDetector(
                    child: ListTile(
                      leading: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(5)),
                          width: 25,
                          height: 25,
                          child: const Text(
                            '1',
                            textAlign: TextAlign.center,
                          )),
                      title: Text(surah),
                      subtitle: Text(detail),
                      trailing: Text(arab),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MushafPage())),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DataFromFirestore()));
                },
                child: const Text('Data from firestore')),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Split()));
                },
                child: const Text('Test'))
          ],
        ),
      );
    });
  }

  buildSuggestions(BuildContext context) {
    List listToShow;
    if (_search.text.isNotEmpty) {
      listToShow = _suraList
          .map((e) => e["tname"])
          .where((e) => e.toLowerCase().contains(_search.text))
          .toList();
    } else {
      listToShow = _suraList.map((e) => e["tname"]).toList();
    }

    return Visibility(
      visible: isSearch,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 300,
          width: 300,
          margin: const EdgeInsets.all(30.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange),
          ),
          child: ListView.builder(
            itemCount: listToShow.length,
            itemBuilder: (_, i) {
              var surahs = listToShow[i];
              return GestureDetector(
                child: ListTile(
                  title: Text(surahs),
                ),
                onTap: () {
                  getDetails(surahs);
                  setState(() {
                    isSearch = false;
                    surah = surahs;
                    _search.clear();
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> getDetails(String surah) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.where("tname", isEqualTo: surah).get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc["ename"]);
    final allData1 = querySnapshot.docs.map((doc) => doc["start_line"]);

    setState(() {
      detail = allData.first;
      arab = allData1.first;
    });
  }
}
