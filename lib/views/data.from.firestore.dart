import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context){
      return Scaffold(
        drawer: navDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          elevation: 0,
          actions: [

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
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'MeQuran2',
                                    color: Colors.white
                                        ),
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
  final List _list = [];
  int? a = 0;
  String? b;

  void initState() {
    // TODO: implement initState
    getData();
    getStartAyah();
    super.initState();
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('quran_texts');
  final CollectionReference _collectionRefs =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');

  Future<void> getData() async {
    // Get docs from collection reference
    await _collectionRef
        .where('medina_mushaf_page_id', isEqualTo: widget.id)
        .where('sura_id', isEqualTo: widget.surah)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _list.add(doc['text1']);
        });
      }
    });
    _list.any((e) => e.contains('b'));
  }

  Future<void> getStartAyah() async {
    // Get docs from collection reference
    await _collectionRefs
        .where('id', isEqualTo: widget.id)
        .where('sura_id', isEqualTo: widget.surah)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          a = int.parse(doc['aya']);
        });
        print(a);
      }
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
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Center(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int i) {
                    if (context.debugDoingBuild) {
                      return const CircularProgressIndicator();
                    }
                    return Text(
                      _list.isNotEmpty
                          ? _list[i].replaceAll(
                              '﴿${ArabicNumbers().convert(i + a!)}﴾',
                              '﴾${ArabicNumbers().convert(i + a!)}﴿').trim()
                          : '',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 40,
                          fontFamily: 'MeQuran2',
                          color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
