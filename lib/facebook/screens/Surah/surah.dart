import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/widgets/more_options_list.dart';
import 'package:quranirab/theme/theme_provider.dart';

class SurahPage extends StatefulWidget {
  final String id;
  final String surah;

  const SurahPage(this.id, this.surah, {Key? key}) : super(key: key);

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  bool onhover = false;

  var ontap = false;
  Color? textColor;

  bool visible = false;

  final List _type = [];

  final List _id = [];

  var suraScrollController = ScrollController();

  Color changeBlue() {
    var c = Colors.blueAccent;
    return c;
  }

  Color changeRed() {
    var c = Colors.redAccent;
    return c;
  }

  final List _list = [];
  List _slice = [];
  final List _raw = [];
  final List _words = [];
  int? a = 0;
  var word;
  String? b;
  var c = '';

  @override
  void initState() {
    // TODO: implement
    getSlice();
    getData();
    getStartAyah();
    getRaw();
    super.initState();
  }


  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('quran_texts');
  final CollectionReference _collectionRefs =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');
  final CollectionReference _raw_quran =
      FirebaseFirestore.instance.collection('raw_quran_texts');
  final CollectionReference _word =
      FirebaseFirestore.instance.collection('words');
  final CollectionReference _categories =
      FirebaseFirestore.instance.collection('category_translations');
  final CollectionReference _relationship =
      FirebaseFirestore.instance.collection('word_relationships');

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

  Future<void> getRaw() async {
    // Get docs from collection reference
    await _raw_quran
        .where('sura_id', isEqualTo: widget.surah)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _raw.add(doc['text']);
        });
      }
    });
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
      }
    });
  }

  Future<void> getWordId(String id) async {
    // Get docs from collection reference
    await _word
        .where('id', isEqualTo: id)
        .where('medina_mushaf_page_id', isEqualTo: '1')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _words.add(doc['text']);
        });
      }
    });
  }

  Future<void> getSlice() async {
    // Get docs from collection reference
    await _collectionRefs
        .where('id', isEqualTo: widget.id)
        .where('sura_id', isEqualTo: widget.surah)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          b = doc['slicing_data'];
          _slice = json.decode(b!);
        });
        for (int i = 0; i < _slice.length; i++) {
          _id.add(_slice[i]['word_id']);
          getWordId(_slice[i]['word_id'].toString());
        }
      }
    });
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      color: themeProvider.isDarkMode
          ? const Color(0xff9A9A9A)
          : const Color(0xffFFF5EC),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Visibility(
              visible: visible,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: (themeProvider.isDarkMode)
                          ? const Color(0xffffffff)
                          : const Color(0xffFFB55F)),
                  color: (themeProvider.isDarkMode)
                      ? const Color(0xff808ba1)
                      : const Color(0xfffff3ca),
                ),
                child: MoreOptionsList(
                  surah: 'Straight',
                  nukKalimah: c,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: SingleChildScrollView(
                  controller: suraScrollController,
                  child: Column(
                    children: [
                      for (int i = 0; i < _words.length; i++)
                        Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: _words.isNotEmpty
                                ? Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: InkWell(
                                        onTap: () async {
                                          var k = await getNukKalimah(_id[i]);
                                          setState(() {
                                            c = k;
                                            visible = true;
                                          });
                                        },
                                        child: Text(
                                          '${_words[i]}',
                                          style: const TextStyle(
                                              fontSize: 40,
                                              fontFamily: 'MeQuran2',
                                              color: Colors.black),
                                        )),
                                  )
                                : const Text('Loading...'),
                          ),
                        ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Center(
                      //     child: _list.isNotEmpty
                      //         ? Directionality(
                      //             textDirection: TextDirection.rtl,
                      //             child: GestureDetector(
                      //               onTap: () => setState(() {
                      //                 visible = true;
                      //               }),
                      //               child: RichText(
                      //                   textAlign: TextAlign.center,
                      //                   text: TextSpan(
                      //                       children: _list
                      //                           .map(
                      //                             (e) => TextSpan(
                      //                               text: e
                      //                                   .trim()
                      //                                   .replaceAll('b', '\n'),
                      //                               style: const TextStyle(
                      //                                   fontSize: 40,
                      //                                   fontFamily: 'MeQuran2',
                      //                                   color: Colors.black),
                      //                             ),
                      //                           )
                      //                           .toList())),
                      //             ),
                      //           )
                      //         : const Text('Loading...'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getNukKalimah(int wordId) async {
    String g = '';
    var category_id = await _relationship
        .where('word_id', isEqualTo: '$wordId')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['word_category_id'] != null) {
          return doc['word_category_id'];
        } else {
          return null;
        }
      }
    });

    await _categories
        .where('word_category_id',
            isEqualTo: category_id != null ? '$category_id' : null)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          if (doc['language_id'] == '1') {
            g = doc['name'];
          }
        });
      }
    });
    return g;
  }
}
