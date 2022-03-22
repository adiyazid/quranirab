import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AyaProvider extends ChangeNotifier {
  var data = 'No data..';
  var page = 1;
  var category = 'Waiting to retrieve data...';

  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');

  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');

  List<bool> select = [];

  currentValue() {
    notifyListeners();
    return data;
  }

  void loadList(List<bool> list) {
    select = list;
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

  Future<void> getCategoryName(element) async {
    await wordRelationship
        .where('word_id', isEqualTo: element.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        getMainCategoryName(doc["word_category_id"].trim());
      }
    });
  }

  Future<void> getMainCategoryName(trim) async {
    await wordCategory
        .where('word_type', isEqualTo: 'main')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == trim.toString()) {
          category = doc["tname"].trim();
          notifyListeners();
        } else {
          null;
        }
      }
    });
  }

  Color? getColor() {
    if (category == 'Ism') {
      return Colors.blueAccent;
    } else if (category == 'Harf') {
      return Colors.redAccent;
    } else if (category == 'Fi‘l') {
      return Colors.green[400];
    }
    return Colors.black;
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
}
