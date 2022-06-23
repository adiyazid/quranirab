import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LangProvider extends ChangeNotifier {
  String langId = '1';
  String? suraIds;
  int? starts;
  List translate = [];
  final CollectionReference _collectionTranslate =
      FirebaseFirestore.instance.collection('quran_translations');

  void changeLang(String id) {
    langId = id;
    getTranslation(id, suraIds, starts);
    notifyListeners();
  }

  Future<void> getTranslation(String id, suraId, int? start) async {
    starts = start ?? 1;
    suraIds = suraId;
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionTranslate
        .where('translation_id', isEqualTo: id)
        .where('sura_id', isEqualTo: suraId)
        .get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    translate = allData;
    //convert dynamic map list into string list
    var data = translate.map((e) => e["text"]).toList();
    translate = data;
    if (start != 1 && start != null) {
      translate.removeRange(0, start - 1);
    }
    notifyListeners();
  }
}
