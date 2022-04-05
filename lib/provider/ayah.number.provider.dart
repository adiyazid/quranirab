import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/models/word.detail.dart';

import '../models/break.index.model.dart';
import '../models/slicing.data.model.dart';

class AyaProvider extends ChangeNotifier {
  var data = 'No data..';
  var page = 1;
  var category = 'Waiting to retrieve data...';

  double _value = fontData.size;

  int nums = 0;

  BreakIndex? _index;

  List<int>? breakIndex;
  List<SlicingDatum>? slice = <SlicingDatum>[];
  List<bool> select = [];
  List<bool> old = [];
  List isim = [];
  List haraf = [];
  List fail = [];
  final List<WordDetail> _wordTypeDetail = [];
  final List<WordDetail> _wordName = [];

  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');

  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');
  CollectionReference wordCategoryTranslation =
      FirebaseFirestore.instance.collection('category_translations');
  final CollectionReference _sliceData =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');

  List? list = [];

  get value => _value;

  get sliceData => _sliceData;

  void increment() {
    if (_value != 40) {
      _value = _value + 5;
      notifyListeners();
    }
  }

  void decrement() {
    _value = _value - 5;
    notifyListeners();
  }

  void setDefault() {
    select = old;
    notifyListeners();
  }

  void getPage(int no) {
    page = no;
    notifyListeners();
  }

  Future<void> readAya() async {
    clearPrevAya();
    notifyListeners();
    var prev = 0;
    // List<int> indexBreak = [];
    await FirebaseFirestore.instance
        .collection('quran_texts')
        .orderBy('created_at')
        .where('medina_mushaf_page_id', isEqualTo: "${page}")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String text = doc["text1"];
        for (int i = 0; i < doc["text"].split('').length; i++) {
          if (doc["text"].split('')[i].contains('ﳁ')) {
            list!.add('${doc["text"].substring(0, i)}');
            // _ayaNumber.add(doc["text"].substring(i));
            // _ayaPosition.add(prev + i - 1);
            prev = prev + i;
          }
        }
        notifyListeners();
      }
      for (int i = 0;
          i < list!.join().replaceAll('', '').split('').length;
          i++) {
        select.add(false);
      }
    });
  }

  Future<void> readJsonData() async {
    String jsonData = await rootBundle.loadString("break_index/break.json");
    _index = BreakIndex.fromJson(json.decode(jsonData));
    if (page == 1) {
      breakIndex = _index?.page1 ?? <int>[];
      notifyListeners();
    } else if (page == 2) {
      breakIndex = _index?.page2 ?? <int>[];
      notifyListeners();
    } else if (page == 440) {
      breakIndex = _index?.page440 ?? <int>[];
      notifyListeners();
    } else {
      breakIndex = <int>[];
      notifyListeners();
    }
  }

  Future<void> readSliceData() async {
    await sliceData
        .where('id', isEqualTo: "${page}")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        ///todo:parse json list to object list
        Iterable l = json.decode(doc["slicing_data"]);
        List<SlicingDatum> _slice = List<SlicingDatum>.from(
            l.map((model) => SlicingDatum.fromJson(model)));
        slice = _slice;
        notifyListeners();
      }
    });
    for (int i = 0; i < slice!.length; i++) {
      if (slice![i != slice!.length - 1 ? i + 1 : i].start - slice![i].end ==
          1) {
        print('data fix');
      } else {
        var a =
            slice![i != slice!.length - 1 ? i + 1 : i].start - slice![i].end;
        slice!.setAll(i, [
          SlicingDatum(
              start: slice![i].start,
              end: i != slice!.length - 1
                  ? slice![i].end + a - 1
                  : slice![i].end,
              wordId: slice![i].wordId)
        ]);
        notifyListeners();
      }
    }
  }

  getWordTypeList() {
    if (_wordTypeDetail.isNotEmpty) {
      return _wordTypeDetail;
    } else {
      return null;
    }
  }

  getWordNameList() {
    if (_wordName.isNotEmpty) {
      return _wordName;
    } else {
      return null;
    }
  }

  void loadList(List<bool> list) {
    select = list;
    old = list;
    notifyListeners();
  }

  void nextPage() {
    if (page != 604) {
      page = page + 1;
      notifyListeners();
      getPage(page);
    }
  }

  void previousPage() {
    if (page != 1) {
      page = page - 1;
      notifyListeners();
    }
  }

  void clear() {
    isim.clear();
    haraf.clear();
    fail.clear();
    notifyListeners();
  }

  Future<void> getCategoryName(wordId, langId) async {
    await wordRelationship
        .where('word_id', isEqualTo: wordId.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      _wordTypeDetail.clear();
      _wordName.clear();
      clear();
      notifyListeners();
      for (var doc in querySnapshot.docs) {
        // getCategoryNameTranslation(doc["word_category_id"].trim(), langId);
        getMainCategoryName(doc["word_category_id"].trim(), wordId, langId);
        getLabelCategoryName(doc["word_category_id"].trim(), langId);
      }
    });
  }

  Future<void> getMainCategoryName(wordCategoryId, wordId, langId) async {
    await wordCategory
        .where('word_type', isEqualTo: 'main')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == wordCategoryId.toString()) {
          category = doc["tname"].trim();
          if (doc["tname"].trim() == 'Ism') isim.add(wordId);
          if (doc["tname"].trim() == 'Fi‘l') fail.add(wordId);
          if (doc["tname"].trim() == 'Harf') haraf.add(wordId);
          notifyListeners();
        }
      }
    });
  }

  Color? getColor(wordId) {
    if (isim.contains(wordId)) {
      return Colors.blueAccent;
    } else if (haraf.contains(wordId)) {
      return Colors.redAccent;
    } else if (fail.contains(wordId)) {
      return Colors.green[400];
    } else {
      return Colors.black;
    }
  }

  getBoolean(index) {
    return select.elementAt(index);
  }

  void updateValue(int index) {
    var value = select.elementAt(index);
    if (select.contains(true)) {
      var initial = <bool>[];
      for (int i = 0; i < select.length; i++) {
        initial.add(false);
      }
      select.replaceRange(0, select.length, initial);
    }
    select.replaceRange(index, index, [!value]);
  }

  Future<void> getLabelCategoryName(wordCategoryId, String langId) async {
    await wordCategory
        .where('word_type', isEqualTo: 'label')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == wordCategoryId.toString()) {
          _wordTypeDetail.add(WordDetail(
              categoryId: int.parse(doc["id"].trim()),
              name: doc["tname"].trim(),
              type: doc["word_type"].trim()));
          notifyListeners();
        }
      }
    });
    await wordCategory
        .where('word_type', isEqualTo: 'main-label')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == wordCategoryId.toString()) {
          _wordTypeDetail.add(WordDetail(
              categoryId: int.parse(doc["id"].trim()),
              name: doc["tname"].trim(),
              type: doc["word_type"].trim()));
          notifyListeners();
        }
      }
    });
    await wordCategoryTranslation
        .where('language_id', isEqualTo: langId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["word_category_id"] == wordCategoryId.toString()) {
          _wordName.add(WordDetail(
              id: int.parse(doc["id"].trim()),
              categoryId: int.parse(doc["word_category_id"].trim()),
              name: doc["name"].trim(),
              type: ''));
          notifyListeners();
        }
      }
    });
  }

  Future<void> getCategoryNameTranslation(categoryId, langId) async {
    await wordCategoryTranslation
        .where('word_category_id', isEqualTo: categoryId)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((element) {
              if (element['language_id'] == langId) {
                print('${element['name']} ${element['word_category_id']}');
              }
            }));
  }

  void clearPrevAya() {
    list!.clear();
    notifyListeners();
  }
}
