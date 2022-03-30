import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AyaProvider extends ChangeNotifier {
  var data = 'No data..';
  var page = 1;
  var category = 'Waiting to retrieve data...';
  final List _allCategory = [];
  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');

  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');

  List<bool> select = [];
  List<bool> old = [];
  List isim = [];
  List haraf = [];
  List fail = [];

  setDefault() {
    select = old;
    notifyListeners();
  }

  getListId() {
    if (_allCategory.isNotEmpty) {
      return _allCategory;
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

  Future<void> getCategoryName(wordId) async {
    await wordRelationship
        .where('word_id', isEqualTo: wordId.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      _allCategory.clear();
      clear();
      notifyListeners();
      for (var doc in querySnapshot.docs) {
        getMainCategoryName(doc["word_category_id"].trim(), wordId);
        getLabelCategoryName(doc["word_category_id"].trim());
      }
    });
  }

  Future<void> getMainCategoryName(wordCategoryId, wordId) async {
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

  Future<void> getLabelCategoryName(wordCategoryId) async {
    await wordCategory
        .where('word_type', isEqualTo: 'label')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == wordCategoryId.toString()) {
          _allCategory.add(doc["tname"].trim());
          notifyListeners();
        }
      }
    });
  }
}
