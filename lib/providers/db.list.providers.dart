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
        nameC.replaceRange(index, index, [name]);
        idC.replaceRange(index, index, [catId]);
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
        nameF.replaceRange(index, index, [name]);
        idF.replaceRange(index, index, [catId]);
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
        nameS.replaceRange(index, index, [name]);
        idS.replaceRange(index, index, [catId]);
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
        nameB.replaceRange(index, index, [name]);
        idB.replaceRange(index, index, [catId]);
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

  Future<void> remove(int number, String id) async {
    if (number == 1) {
      var position = chinese.indexOf(id);
      nameC.removeAt(position);
      idC.removeAt(position);
      chinese.removeAt(position);
      save('4');
      notifyListeners();
    } else if (number == 2) {
      var position = french.indexOf(id);
      nameF.removeAt(position);
      idF.removeAt(position);
      french.removeAt(position);
      save('5');
      notifyListeners();
    } else if (number == 3) {
      var position = spanish.indexOf(id);
      nameS.removeAt(position);
      idS.removeAt(position);
      spanish.removeAt(position);
      save('6');
      notifyListeners();
    } else if (number == 4) {
      var position = bengali.indexOf(id);
      nameB.removeAt(position);
      idB.removeAt(position);
      bengali.removeAt(position);
      save('7');
      notifyListeners();
    }
  }

  Future<void> update(id, name, int i) async {
    if (i == 1) {
      var position = idC.indexOf(id);
      nameC.replaceRange(position, position + 1, [name]);
      await save('4');
      notifyListeners();
    }
    if (i == 2) {
      var position = idF.indexOf(id);
      nameF.replaceRange(position, position + 1, [name]);
      await save('5');
      notifyListeners();
    }
    if (i == 3) {
      var position = idS.indexOf(id);
      nameS.replaceRange(position, position + 1, [name]);
      await save('6');
      notifyListeners();
    }
    if (i == 4) {
      var position = idB.indexOf(id);
      nameB.replaceRange(position, position + 1, [name]);
      await save('7');
      notifyListeners();
    }
  }
}
