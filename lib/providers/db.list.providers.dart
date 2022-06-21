import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DbListProvider extends ChangeNotifier {
  List chinese = [];
  List french = [];
  List spanish = [];
  List bengali = [];
  List nameC = [];
  List nameF = [];
  List nameS = [];
  List nameB = [];
  List idC = [];
  List idF = [];
  List idS = [];
  List idB = [];
  void add(String id, String name, lang, String catId) {
    if (lang == '4') {
      if (!chinese.contains(id)) {
        chinese.add(id);
      }
      var index = chinese.indexOf(id);
      if (nameC.isEmpty) {
        nameC.add(name);
        idC.add(catId);
      } else {
        nameC.replaceRange(index, index + 1, [name]);
        idC.replaceRange(index, index + 1, [catId]);
      }
    }
    if (lang == '5') {
      if (!french.contains(id)) {
        french.add(id);
      }
      var index = french.indexOf(id);
      if (nameF.isEmpty) {
        nameF.add(name);
        idF.add(catId);
      } else {
        nameF.replaceRange(index, index + 1, [name]);
        idF.replaceRange(index, index + 1, [catId]);
      }
    }
    if (lang == '6') {
      if (!spanish.contains(id)) {
        spanish.add(id);
      }
      var index = spanish.indexOf(id);
      if (nameS.isEmpty) {
        nameS.add(name);
        idS.add(catId);
      } else {
        nameS.replaceRange(index, index + 1, [name]);
        idS.replaceRange(index, index + 1, [catId]);
      }
    }
    if (lang == '7') {
      if (!bengali.contains(id)) {
        bengali.add(id);
      }
      var index = bengali.indexOf(id);
      if (nameB.isEmpty) {
        nameB.add(name);
        idB.add(catId);
      } else {
        nameB.replaceRange(index, index + 1, [name]);
        idB.replaceRange(index, index + 1, [catId]);
      }
    }
    notifyListeners();
    save(lang);
  }

  Future<void> save(String id) async {
    if (id == '4') {
      await FirebaseFirestore.instance
          .collection('translation_progress')
          .doc('chinese')
          .set({"datalist": chinese, "name": nameC, "id": idC},
              SetOptions(merge: true));
    } else if (id == '5') {
      await FirebaseFirestore.instance
          .collection('translation_progress')
          .doc('french')
          .set({"datalist": french, "name": nameF, "id": idF},
              SetOptions(merge: true));
    } else if (id == '6') {
      await FirebaseFirestore.instance
          .collection('translation_progress')
          .doc('spanish')
          .set({"datalist": spanish, "name": nameS, "id": idS},
              SetOptions(merge: true));
    } else if (id == '7') {
      await FirebaseFirestore.instance
          .collection('translation_progress')
          .doc('benggali')
          .set({"datalist": bengali, "name": nameB, "id": idB},
              SetOptions(merge: true));
    }
  }

  Future<void> getDbList() async {
    await FirebaseFirestore.instance
        .collection('translation_progress')
        .doc('chinese')
        .get()
        .then((value) {
      chinese = value['datalist'];
      nameC = value['name'];
      idC = value['id'];
    });
    await FirebaseFirestore.instance
        .collection('translation_progress')
        .doc('french')
        .get()
        .then((value) {
      french = value['datalist'];
      nameF = value['name'];
      idF = value['id'];
    });
    await FirebaseFirestore.instance
        .collection('translation_progress')
        .doc('spanish')
        .get()
        .then((value) {
      spanish = value['datalist'];
      nameS = value['name'];
      idS = value['id'];
    });
    await FirebaseFirestore.instance
        .collection('translation_progress')
        .doc('benggali')
        .get()
        .then((value) {
      bengali = value['datalist'];
      nameB = value['name'];
      idB = value['id'];
    });
    notifyListeners();
    print(chinese + french + spanish + bengali);
  }
}
