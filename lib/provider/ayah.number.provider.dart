import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quranirab/models/word.detail.dart';
import '../models/break.index.model.dart';
import '../models/slicing.data.model.dart';
import '../models/surah.split.model.dart';

class AyaProvider extends ChangeNotifier {
  WordDetail? data;
  var page = 1;
  var category = 'Waiting to retrieve data...';
  final storageRef = FirebaseStorage.instance.ref();
  double value = 12;
  int? start;
  int? end;
  int nums = 0;
  List<WordDetail> allChild = [];
  BreakIndex? _index;
  List _sPos = [];
  List ayaPosition = [];
  List ayaNumber = [];
  List<int>? breakIndex;
  List<SlicingData>? slice = <SlicingData>[];
  List<bool> select = [];
  List<bool> old = [];
  List isim = [];
  List haraf = [];
  List fail = [];
  final List<WordDetail> wordDetail = [];
  List<WordDetail> wordName = [];

  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');
  final CollectionReference wordTable =
      FirebaseFirestore.instance.collection('words');
  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');
  CollectionReference wordCategoryTranslation =
      FirebaseFirestore.instance.collection('category_translations');
  final CollectionReference _sliceData =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');

  List? list = [];

  String? words;
  int? sura_id;
  bool loading = false;
  bool loadingCategory = false;
  int wordID = 0;
  int? newNum;

  int? numStart;

  List pageFix = [];

  bool nodata = false;

  List<WordDetail> labelCategory = [];

  List<WordDetail> parent = [];

  bool success = false;

  double maxScreen = 0.0;

  get sliceData => _sliceData;
  bool visible = false;

  void decrement() {
    value = value - 1;
    notifyListeners();
  }

  void setDefault() {
    nums = 0;
    loading = false;
    notifyListeners();
  }

  void getPage(int no) {
    page = no;
    _sPos.clear();
    if (visible == true) visible = !visible;
    notifyListeners();
  }

  Future<void> readAya() async {
    clearPrevAya();
    notifyListeners();
    var prev = 0;
    var text = '';

    // List<int> indexBreak = [];
    await FirebaseFirestore.instance
        .collection('quran_texts')
        .orderBy('created_at')
        .where('medina_mushaf_page_id', isEqualTo: "${page}")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        for (int i = 0; i < doc["text"].split('').length; i++) {
          text = doc["text"];
          if (text.split('')[i].contains('ﳁ')) {
            list!.add(text.substring(0, i));
            ayaNumber.add(text.substring(i));
            ayaPosition.add(prev + i - 1);
            prev = prev + i;
          }
        }
        notifyListeners();
      }
      if (select.isEmpty) {
        for (int i = 0; i < list!.join().split('').length; i++) {
          select.add(false);
        }
        old = select;
      } else if (select.isNotEmpty) {
        if (select.contains(true)) {
          select.clear();
          for (int i = 0; i < list!.join().split('').length; i++) {
            select.add(false);
          }
          print('[set to default]');
        }
        notifyListeners();
      }
      for (int i = 0; i < list!.join().split('').length; i++) {
        if (list!.join().split('')[i] == 'ﲿ') {
          _sPos.add(i);
        }
      }
    });
    if (slice!.last.end != list!.join().split('').length) {
      var last = slice!.last;
      slice!.remove(last);
      slice!.add(SlicingData(
          start: last.start,
          end: list!.join().split('').length,
          wordId: last.wordId));
      notifyListeners();
      print("[fix last surah of slice data]");
    }
    loading = true;
    notifyListeners();
  }

  Future<void> readSliceData() async {
    await sliceData
        .where('id', isEqualTo: "${page}")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        ///todo:parse json list to object list
        Iterable l = json.decode(doc["slicing_data"]);
        List<SlicingData> _slice = List<SlicingData>.from(
            l.map((model) => SlicingData.fromJson(model)));
        slice = _slice;
        notifyListeners();
      }
    });
    for (int i = 0; i < slice!.length; i++) {
      if (slice![i != slice!.length - 1 ? i + 1 : i].start - slice![i].end ==
          1) {
      } else {
        var a =
            slice![i != slice!.length - 1 ? i + 1 : i].start - slice![i].end;
        slice!.setAll(i, [
          SlicingData(
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
    if (wordDetail.isNotEmpty) {
      return wordDetail;
    } else {
      return null;
    }
  }

  getWordNameList() {
    if (wordName.isNotEmpty) {
      return wordName;
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
      _sPos.clear();
      notifyListeners();
      getPage(page);
    }
  }

  void previousPage() {
    if (page != 1) {
      page = page - 1;
      _sPos.clear();
      notifyListeners();
      getPage(page);
    }
  }

  void clearCategory() {
    isim.clear();
    haraf.clear();
    fail.clear();
    loadingCategory = false;
    nodata = false;
    notifyListeners();
  }

  void setWords(word) {
    words = word;
  }

  Future<void> getCategoryName(wordId, langId) async {
    wordID = wordId;
    loadingCategory = false;
    clearCategory();
    notifyListeners();
    await wordRelationship
        .where('word_id', isEqualTo: wordId.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var relationshipID = doc["id"];
        var categoryID = doc["word_category_id"];
        getMainCategoryName(doc["word_category_id"], wordId, relationshipID);
        getSubCategory(categoryID, relationshipID, langId);
      }
    });
    loadingCategory = true;

    notifyListeners();
  }

  Future<void> getMainCategoryName(wordCategoryId, wordId, id) async {
    await wordCategory
        .where('word_type', isEqualTo: 'main')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["id"] == wordCategoryId.toString()) {
          category = doc["tname"];
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
    }
    return null;
  }

  void checkRebuilt(no) {
    if (no != 0 && pageFix.contains(page)) {
      nums = numStart ?? 0;
    } else {
      nums = 0;
    }
    if (start == null) nums = 0;
    if (no == 0) nums = numStart ?? 0;
  }

  getBoolean(index) {
    return select.elementAt(index);
  }

  void updateValue(int index) {
    //var value = select.elementAt(index);
    if (select.contains(true)) {
      select = old;
      notifyListeners();
    }
    select.replaceRange(index, index + 1, [true]);
  }

  Future<void> getSubCategory(wordCategoryId, id, String langID) async {
    await wordCategory
        .where('id', isEqualTo: wordCategoryId)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        var parent = doc['ancestry'] ?? '';
        var name = await getCategoryNameTranslation(wordCategoryId, langID);
        wordDetail.add(WordDetail(
            childType: doc["child_type"] ?? '',
            isparent:
                parent.split("/").length == 1 || parent == '' ? true : false,
            hasChild:
                parent.split("/").length > 1 || parent == '' ? true : false,
            parent: doc["ancestry"],
            id: int.parse(id),
            categoryId: int.parse(doc["id"]),
            name: name != '' ? name : doc["name"],
            type: doc["word_type"] ?? 'None'));
        notifyListeners();
      }
    });
    wordDetail.sort((a, b) => a.categoryId!.compareTo(b.categoryId!));
  }

  Future<String> getCategoryNameTranslation(categoryId, langId) async {
    var name = '';
    await wordCategoryTranslation
        .where('word_category_id', isEqualTo: categoryId)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((element) {
              if (element['language_id'] == langId) {
                name = element['name']
                        .replaceAll("<i>", "")
                        .replaceAll("</i>", " ") ??
                    'No Translation';
              }
            }));
    return name;
  }

  void clearPrevAya() {
    list!.clear();
    ayaPosition.clear();
    ayaNumber.clear();
    parent.clear();
    notifyListeners();
  }

  checkAya(index) {
    var total = list!.length;
    var lengthAya1 = list![0].split(' ').length;
    var d = _sPos.contains(index - 2);
    var a = ayaPosition.contains(index != 0 ? index - 1 : index);
    var b = ayaPosition.contains(index);
    var c = ayaPosition.contains(index + 1);
    if (d) {
      nums = nums + 1;
      return false;
    }
    if (!a) {
      return true;
    }
    if (!a && !b) {
      return true;
    }
    if (!a && !b && !c) {
      return true;
    }
    if (nums < total && index > lengthAya1) {
      nums = nums + 1;
    }
    return false;
  }

  set() {
    wordDetail.clear();
    visible = !visible;
    notifyListeners();
  }

  checkSymbol(int end) {
    if (_sPos.contains(end - 3)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> readJsonData() async {
    var jsonData = {
      "page_1": [5, 10, 15, 22, 28, 34, 37],
      "page_2": [8, 17, 30, 43, 51, 53],
      "page_3": [
        14,
        28,
        39,
        54,
        65,
        77,
        91,
        100,
        112,
        127,
        139,
        153,
        166,
        174,
        185
      ],
      "page_4": [
        13,
        26,
        39,
        52,
        63,
        80,
        96,
        107,
        119,
        131,
        146,
        158,
        172,
        184,
        194
      ],
      "page_5": [
        11,
        22,
        35,
        47,
        59,
        71,
        82,
        94,
        104,
        118,
        125,
        136,
        147,
        158,
        170
      ],
      "page_6": [
        13,
        27,
        42,
        53,
        65,
        80,
        96,
        111,
        124,
        137,
        153,
        165,
        183,
        198,
        214
      ],
      "page_7": [
        14,
        27,
        39,
        53,
        66,
        83,
        95,
        106,
        116,
        128,
        143,
        156,
        169,
        182,
        196
      ],
      "page_8": [
        11,
        22,
        35,
        47,
        58,
        68,
        78,
        92,
        106,
        121,
        134,
        145,
        155,
        167,
        178
      ],
      "page_9": [
        13,
        25,
        34,
        46,
        55,
        69,
        79,
        90,
        107,
        123,
        135,
        149,
        162,
        174,
        186
      ],
      "page_10": [
        10,
        25,
        39,
        52,
        65,
        78,
        89,
        102,
        116,
        131,
        141,
        160,
        170,
        186,
        195
      ],
      "page_11": [
        19,
        33,
        45,
        58,
        71,
        87,
        99,
        113,
        130,
        146,
        159,
        170,
        181,
        195,
        210
      ],
      "page_12": [
        12,
        24,
        35,
        47,
        63,
        72,
        85,
        94,
        105,
        114,
        123,
        135,
        145,
        155,
        163
      ],
      "page_13": [
        13,
        24,
        33,
        45,
        57,
        67,
        79,
        89,
        100,
        113,
        125,
        140,
        155,
        164,
        178
      ],
      "page_14": [
        15,
        25,
        35,
        47,
        61,
        72,
        86,
        99,
        113,
        122,
        131,
        144,
        155,
        165,
        176
      ],
      "page_15": [
        10,
        20,
        35,
        46,
        60,
        72,
        88,
        100,
        113,
        126,
        137,
        150,
        160,
        171,
        180
      ],
      "page_16": [
        12,
        19,
        30,
        44,
        57,
        72,
        87,
        101,
        111,
        122,
        132,
        141,
        151,
        163,
        173
      ],
      "page_17": [
        15,
        31,
        43,
        53,
        65,
        74,
        84,
        97,
        111,
        123,
        135,
        146,
        156,
        167,
        184
      ],
      "page_18": [
        10,
        21,
        34,
        48,
        63,
        75,
        88,
        99,
        113,
        123,
        138,
        150,
        161,
        173,
        184
      ],
      "page_19": [
        15,
        30,
        46,
        61,
        73,
        89,
        105,
        118,
        136,
        148,
        162,
        175,
        187,
        204,
        217
      ],
      "page_20": [
        12,
        25,
        44,
        56,
        69,
        82,
        96,
        111,
        124,
        140,
        150,
        164,
        176,
        188,
        204
      ],
      "page_21": [
        11,
        23,
        37,
        49,
        63,
        81,
        94,
        106,
        120,
        136,
        145,
        157,
        171,
        184,
        197
      ],
      "page_22": [
        14,
        27,
        39,
        50,
        64,
        78,
        92,
        102,
        116,
        132,
        148,
        162,
        179,
        192,
        203
      ],
      "page_23": [
        14,
        25,
        39,
        52,
        65,
        80,
        95,
        108,
        123,
        144,
        154,
        166,
        179,
        196,
        208
      ],
      "page_24": [
        15,
        28,
        39,
        56,
        67,
        76,
        89,
        102,
        116,
        128,
        141,
        156,
        167,
        179,
        190
      ],
      "page_25": [
        11,
        25,
        41,
        50,
        61,
        73,
        89,
        100,
        113,
        125,
        143,
        155,
        168,
        182,
        195
      ],
      "page_26": [
        19,
        32,
        42,
        57,
        70,
        83,
        96,
        114,
        123,
        133,
        145,
        156,
        167,
        177,
        190
      ],
      "page_27": [
        12,
        24,
        36,
        48,
        59,
        70,
        80,
        94,
        111,
        125,
        138,
        147,
        158,
        169,
        185
      ],
      "page_28": [
        15,
        26,
        37,
        47,
        59,
        71,
        84,
        93,
        105,
        119,
        131,
        142,
        152,
        166,
        179
      ],
      "page_29": [
        11,
        25,
        39,
        54,
        64,
        75,
        88,
        100,
        112,
        121,
        133,
        145,
        156,
        165,
        173
      ],
      "page_30": [
        15,
        28,
        44,
        58,
        72,
        85,
        101,
        115,
        128,
        144,
        162,
        179,
        196,
        210,
        221
      ],
      "page_31": [
        12,
        25,
        38,
        46,
        56,
        63,
        77,
        85,
        93,
        105,
        114,
        128,
        140,
        150,
        161
      ],
      "page_32": [
        10,
        27,
        39,
        51,
        64,
        77,
        90,
        102,
        112,
        121,
        129,
        141,
        151,
        162,
        172
      ],
      "page_33": [
        13,
        27,
        37,
        50,
        59,
        72,
        88,
        100,
        116,
        126,
        139,
        152,
        163,
        177,
        191
      ],
      "page_34": [
        13,
        29,
        40,
        54,
        68,
        80,
        91,
        104,
        114,
        123,
        132,
        141,
        155,
        166,
        176
      ],
      "page_35": [
        13,
        26,
        38,
        49,
        60,
        73,
        86,
        98,
        108,
        122,
        132,
        149,
        161,
        171,
        181
      ],
      "page_36": [
        16,
        29,
        42,
        51,
        67,
        84,
        98,
        110,
        124,
        138,
        156,
        172,
        187,
        204,
        216
      ],
      "page_37": [
        15,
        29,
        43,
        56,
        71,
        86,
        100,
        116,
        126,
        141,
        154,
        171,
        188,
        203,
        218
      ],
      "page_38": [
        12,
        26,
        40,
        54,
        67,
        78,
        88,
        102,
        114,
        128,
        141,
        154,
        167,
        179,
        191
      ],
      "page_39": [
        10,
        23,
        34,
        43,
        54,
        66,
        75,
        83,
        94,
        105,
        120,
        127,
        138,
        151,
        161
      ],
      "page_40": [
        13,
        26,
        37,
        52,
        65,
        76,
        88,
        101,
        114,
        126,
        135,
        148,
        159,
        168,
        179
      ],
      "page_41": [
        11,
        30,
        45,
        58,
        70,
        79,
        89,
        101,
        113,
        122,
        131,
        145,
        154,
        160,
        172
      ],
      "page_42": [
        13,
        25,
        39,
        52,
        69,
        83,
        102,
        112,
        128,
        143,
        160,
        173,
        184,
        197,
        209
      ],
      "page_43": [
        11,
        21,
        30,
        41,
        53,
        66,
        79,
        90,
        103,
        119,
        132,
        145,
        157,
        167,
        178
      ],
      "page_44": [
        14,
        28,
        42,
        54,
        65,
        76,
        87,
        102,
        116,
        125,
        138,
        151,
        167,
        179,
        190
      ],
      "page_45": [
        9,
        22,
        35,
        47,
        61,
        75,
        88,
        98,
        112,
        126,
        141,
        150,
        163,
        173,
        182
      ],
      "page_46": [
        14,
        24,
        37,
        49,
        60,
        71,
        82,
        94,
        102,
        109,
        118,
        127,
        137,
        150,
        161
      ],
      "page_47": [
        10,
        23,
        37,
        55,
        64,
        76,
        88,
        104,
        117,
        132,
        150,
        160,
        172,
        184,
        195
      ],
      "page_48": [
        14,
        29,
        43,
        59,
        72,
        86,
        98,
        109,
        123,
        134,
        148,
        159,
        173,
        188,
        199
      ],
      "page_49": [
        13,
        29,
        43,
        57,
        71,
        85,
        96,
        113,
        128,
        141,
        155,
        171,
        188,
        208,
        217
      ],
      "page_50": [12, 26, 42, 55, 66, 77, 89, 103, 118, 135, 151, 166, 178],
      "page_51": [
        14,
        25,
        43,
        54,
        63,
        75,
        86,
        99,
        107,
        116,
        125,
        134,
        148,
        159,
        169
      ],
      "page_52": [
        17,
        24,
        31,
        46,
        55,
        66,
        79,
        93,
        110,
        127,
        138,
        149,
        158,
        166,
        176
      ],
      "page_53": [
        13,
        26,
        42,
        55,
        69,
        78,
        92,
        106,
        118,
        130,
        140,
        153,
        165,
        181,
        192
      ],
      "page_54": [
        12,
        27,
        41,
        57,
        72,
        82,
        94,
        107,
        123,
        139,
        158,
        171,
        185,
        198,
        211
      ],
      "page_55": [
        14,
        26,
        39,
        50,
        65,
        77,
        90,
        102,
        115,
        128,
        139,
        154,
        165,
        179,
        190
      ],
      "page_56": [
        10,
        28,
        44,
        54,
        70,
        84,
        95,
        110,
        124,
        138,
        152,
        170,
        179,
        189,
        201
      ],
      "page_57": [
        16,
        26,
        39,
        53,
        65,
        79,
        92,
        104,
        115,
        126,
        139,
        153,
        171,
        188,
        196
      ],
      "page_58": [
        17,
        29,
        43,
        59,
        76,
        84,
        98,
        110,
        128,
        140,
        150,
        167,
        176,
        187,
        197
      ],
      "page_59": [
        12,
        23,
        37,
        51,
        64,
        80,
        91,
        102,
        121,
        138,
        147,
        161,
        173,
        188,
        199
      ],
      "page_60": [
        14,
        24,
        38,
        50,
        64,
        77,
        90,
        102,
        115,
        128,
        145,
        159,
        168,
        181,
        190
      ],
      "page_61": [
        15,
        26,
        38,
        50,
        62,
        74,
        86,
        95,
        105,
        117,
        129,
        142,
        155,
        167,
        181
      ],
      "page_62": [
        13,
        25,
        37,
        52,
        63,
        74,
        87,
        99,
        113,
        127,
        139,
        149,
        162,
        175,
        188
      ],
      "page_63": [
        13,
        26,
        44,
        56,
        72,
        87,
        103,
        116,
        126,
        141,
        152,
        165,
        178,
        190,
        204
      ],
      "page_64": [
        15,
        25,
        36,
        46,
        56,
        69,
        85,
        97,
        111,
        124,
        134,
        143,
        153,
        163,
        175
      ],
      "page_65": [
        14,
        25,
        37,
        50,
        62,
        75,
        89,
        102,
        119,
        135,
        149,
        162,
        177,
        189,
        198
      ],
      "page_66": [
        13,
        28,
        40,
        54,
        68,
        79,
        97,
        107,
        121,
        135,
        149,
        161,
        173,
        184,
        193
      ],
      "page_67": [
        12,
        20,
        29,
        38,
        52,
        66,
        76,
        87,
        99,
        111,
        121,
        136,
        147,
        159,
        171
      ],
      "page_68": [
        11,
        23,
        36,
        51,
        65,
        79,
        89,
        102,
        115,
        128,
        145,
        158,
        177,
        189,
        199
      ],
      "page_69": [
        11,
        20,
        30,
        42,
        54,
        62,
        74,
        87,
        97,
        108,
        120,
        127,
        137,
        148,
        159
      ],
      "page_70": [
        11,
        24,
        35,
        51,
        68,
        81,
        96,
        107,
        118,
        134,
        151,
        169,
        184,
        198,
        211
      ],
      "page_71": [
        17,
        34,
        51,
        63,
        79,
        94,
        107,
        119,
        134,
        144,
        158,
        171,
        183,
        198,
        210
      ],
      "page_72": [
        15,
        31,
        43,
        55,
        71,
        88,
        100,
        111,
        127,
        140,
        153,
        163,
        174,
        187,
        197
      ],
      "page_73": [
        16,
        27,
        42,
        55,
        70,
        80,
        93,
        110,
        123,
        138,
        154,
        169,
        182,
        198,
        211
      ],
      "page_74": [
        14,
        28,
        38,
        50,
        64,
        77,
        92,
        108,
        117,
        128,
        140,
        148,
        159,
        169,
        180
      ],
      "page_75": [
        14,
        31,
        40,
        56,
        69,
        80,
        91,
        100,
        111,
        125,
        142,
        154,
        174,
        190,
        204
      ],
      "page_76": [
        15,
        29,
        46,
        59,
        70,
        81,
        92,
        105,
        119,
        133,
        145,
        156,
        165,
        178
      ],
      "page_77": [
        17,
        33,
        49,
        65,
        80,
        98,
        113,
        131,
        144,
        165,
        181,
        197,
        212,
        228
      ],
      "page_78": [
        13,
        27,
        36,
        51,
        63,
        76,
        86,
        96,
        108,
        123,
        138,
        159,
        174,
        190,
        199
      ],
      "page_79": [
        11,
        26,
        35,
        49,
        63,
        74,
        88,
        99,
        110,
        121,
        131,
        139,
        146,
        159,
        168
      ],
      "page_80": [
        10,
        24,
        35,
        48,
        60,
        71,
        83,
        91,
        99,
        112,
        122,
        136,
        149,
        163,
        173
      ],
      "page_81": [
        11,
        23,
        34,
        43,
        52,
        63,
        71,
        85,
        95,
        104,
        114,
        127,
        137,
        145,
        154
      ],
      "page_82": [
        9,
        22,
        34,
        48,
        61,
        71,
        80,
        92,
        107,
        115,
        129,
        138,
        152,
        163,
        174
      ],
      "page_83": [
        11,
        21,
        30,
        43,
        55,
        66,
        78,
        88,
        97,
        112,
        125,
        138,
        149,
        160,
        169
      ],
      "page_84": [
        10,
        22,
        33,
        45,
        61,
        71,
        86,
        98,
        112,
        123,
        132,
        145,
        151,
        161,
        171
      ],
      "page_85": [
        10,
        26,
        40,
        55,
        68,
        80,
        91,
        103,
        112,
        124,
        137,
        150,
        163,
        175,
        183
      ],
      "page_86": [
        16,
        26,
        42,
        61,
        79,
        91,
        104,
        119,
        133,
        147,
        160,
        170,
        183,
        192,
        201
      ],
      "page_87": [
        15,
        28,
        42,
        53,
        72,
        84,
        97,
        106,
        119,
        131,
        145,
        162,
        174,
        193,
        204
      ],
      "page_88": [
        14,
        25,
        38,
        49,
        58,
        67,
        80,
        88,
        103,
        114,
        127,
        137,
        149,
        160,
        170
      ],
      "page_89": [
        15,
        31,
        48,
        59,
        73,
        83,
        91,
        101,
        115,
        131,
        144,
        160,
        169,
        178,
        190
      ],
      "page_90": [
        13,
        26,
        44,
        54,
        64,
        78,
        92,
        108,
        121,
        134,
        149,
        161,
        177,
        192,
        209
      ],
      "page_91": [
        15,
        25,
        37,
        52,
        66,
        77,
        91,
        105,
        117,
        130,
        141,
        151,
        165,
        180,
        194
      ],
      "page_92": [
        16,
        28,
        43,
        58,
        73,
        91,
        106,
        121,
        136,
        157,
        172,
        186,
        206,
        221,
        236
      ],
      "page_93": [
        13,
        23,
        37,
        47,
        58,
        69,
        78,
        85,
        95,
        110,
        126,
        136,
        144,
        155,
        165
      ],
      "page_94": [
        10,
        25,
        39,
        49,
        61,
        77,
        94,
        102,
        113,
        126,
        139,
        155,
        171,
        186,
        200
      ],
      "page_95": [
        16,
        34,
        45,
        62,
        74,
        87,
        99,
        111,
        125,
        137,
        146,
        159,
        171,
        184,
        196
      ],
      "page_96": [
        11,
        22,
        30,
        45,
        56,
        68,
        78,
        89,
        102,
        113,
        127,
        140,
        154,
        166,
        177
      ],
      "page_97": [
        12,
        22,
        33,
        45,
        57,
        70,
        84,
        94,
        105,
        120,
        136,
        147,
        155,
        167,
        177
      ],
      "page_98": [
        11,
        22,
        34,
        45,
        59,
        69,
        79,
        93,
        105,
        117,
        127,
        139,
        153,
        163,
        178
      ],
      "page_99": [
        13,
        26,
        39,
        50,
        62,
        78,
        88,
        101,
        115,
        132,
        144,
        159,
        172,
        183,
        193
      ],
      "page_100": [
        13,
        25,
        42,
        57,
        71,
        83,
        100,
        112,
        131,
        141,
        149,
        164,
        180,
        196,
        205
      ],
      "page_101": [
        16,
        30,
        43,
        53,
        66,
        77,
        88,
        103,
        113,
        124,
        135,
        150,
        162,
        171,
        182
      ],
      "page_102": [
        13,
        25,
        35,
        49,
        60,
        68,
        80,
        94,
        105,
        118,
        132,
        145,
        157,
        175,
        191
      ],
      "page_103": [
        17,
        34,
        48,
        61,
        81,
        100,
        117,
        133,
        145,
        160,
        176,
        189,
        204,
        214,
        227
      ],
      "page_104": [
        17,
        28,
        40,
        53,
        66,
        75,
        87,
        100,
        110,
        123,
        139,
        150,
        162,
        177,
        191
      ],
      "page_105": [
        11,
        22,
        39,
        56,
        69,
        80,
        90,
        102,
        114,
        128,
        140,
        153,
        167,
        183,
        196
      ],
      "page_106": [11, 29, 47, 61, 73, 86, 100, 112, 126, 141, 154, 167, 179],
      "page_107": [
        15,
        28,
        41,
        53,
        71,
        86,
        96,
        111,
        127,
        144,
        156,
        170,
        184,
        194,
        207
      ],
      "page_108": [
        13,
        26,
        39,
        54,
        66,
        80,
        92,
        102,
        115,
        134,
        145,
        156,
        170,
        180,
        190
      ],
      "page_109": [
        12,
        21,
        33,
        49,
        57,
        69,
        82,
        97,
        110,
        120,
        131,
        144,
        155,
        171,
        181
      ],
      "page_110": [
        12,
        28,
        38,
        46,
        57,
        65,
        74,
        83,
        91,
        101,
        111,
        122,
        133,
        142,
        155
      ],
      "page_111": [
        12,
        29,
        41,
        55,
        69,
        85,
        98,
        111,
        124,
        137,
        149,
        164,
        173,
        187,
        201
      ],
      "page_112": [
        17,
        32,
        47,
        57,
        66,
        80,
        92,
        106,
        124,
        139,
        148,
        162,
        174,
        188,
        198
      ],
      "page_113": [
        12,
        24,
        35,
        49,
        59,
        69,
        79,
        89,
        101,
        114,
        125,
        138,
        149,
        163,
        175
      ],
      "page_114": [
        12,
        24,
        36,
        49,
        61,
        72,
        83,
        92,
        107,
        116,
        126,
        140,
        156,
        168,
        178
      ],
      "page_115": [
        11,
        26,
        39,
        47,
        59,
        70,
        82,
        95,
        107,
        122,
        133,
        147,
        159,
        172,
        182
      ],
      "page_116": [
        16,
        30,
        43,
        58,
        71,
        82,
        99,
        114,
        128,
        140,
        155,
        171,
        189,
        203,
        214
      ],
      "page_117": [
        13,
        31,
        43,
        60,
        75,
        90,
        103,
        120,
        131,
        144,
        159,
        173,
        188,
        201,
        216
      ],
      "page_118": [
        17,
        31,
        48,
        65,
        79,
        96,
        115,
        128,
        139,
        154,
        167,
        182,
        200,
        212,
        223
      ],
      "page_119": [
        15,
        30,
        44,
        56,
        66,
        82,
        95,
        105,
        117,
        133,
        145,
        158,
        174,
        187,
        199
      ],
      "page_120": [19, 33, 48, 63, 78, 90, 103, 115, 128, 143, 153, 165, 177],
      "page_121": [
        15,
        31,
        39,
        51,
        61,
        71,
        81,
        92,
        104,
        115,
        123,
        135,
        148,
        159,
        161
      ],
      "page_122": [
        7,
        18,
        30,
        49,
        63,
        74,
        86,
        95,
        108,
        119,
        132,
        146,
        156,
        170,
        182,
        195
      ],
      "page_123": [
        14,
        25,
        36,
        48,
        60,
        76,
        87,
        103,
        118,
        130,
        145,
        159,
        172,
        186,
        196,
        209,
        223
      ],
      "page_124": [
        14,
        29,
        37,
        50,
        65,
        76,
        87,
        97,
        110,
        121,
        135,
        147,
        162,
        177,
        188
      ],
      "page_125": [
        18,
        33,
        46,
        59,
        73,
        84,
        98,
        108,
        124,
        139,
        151,
        164,
        178,
        191,
        206
      ],
      "page_126": [
        15,
        27,
        42,
        54,
        64,
        78,
        93,
        106,
        120,
        132,
        148,
        159,
        173,
        185,
        198
      ],
      "page_127": [
        13,
        32,
        46,
        60,
        77,
        93,
        115,
        132,
        153,
        170,
        186,
        200,
        212,
        229,
        243
      ],
      "page_128": [11, 23, 37, 49, 63, 78, 92, 108, 124, 142, 159, 174, 188],
      "page_129": [
        18,
        32,
        45,
        54,
        67,
        79,
        93,
        104,
        115,
        129,
        142,
        156,
        170,
        186,
        196
      ],
      "page_130": [
        18,
        36,
        53,
        66,
        81,
        97,
        111,
        128,
        143,
        160,
        176,
        189,
        203,
        219,
        234
      ],
      "page_131": [
        23,
        40,
        55,
        73,
        86,
        103,
        114,
        130,
        145,
        156,
        173,
        189,
        203,
        218,
        230
      ],
      "page_132": [
        13,
        28,
        41,
        56,
        68,
        82,
        94,
        110,
        120,
        135,
        150,
        162,
        175,
        190,
        205
      ],
      "page_133": [
        13,
        30,
        42,
        55,
        65,
        76,
        92,
        105,
        121,
        134,
        147,
        162,
        174,
        189,
        200
      ],
      "page_134": [
        15,
        29,
        42,
        55,
        69,
        79,
        92,
        105,
        122,
        134,
        147,
        161,
        173,
        188,
        199
      ],
      "page_135": [
        15,
        29,
        42,
        55,
        69,
        82,
        96,
        111,
        124,
        139,
        150,
        167,
        180,
        194,
        203
      ],
      "page_136": [
        12,
        23,
        36,
        48,
        61,
        73,
        86,
        102,
        112,
        124,
        138,
        153,
        164,
        177,
        185
      ],
      "page_137": [
        14,
        27,
        36,
        51,
        62,
        79,
        90,
        103,
        115,
        127,
        143,
        158,
        168,
        182,
        192
      ],
      "page_138": [
        14,
        26,
        37,
        52,
        65,
        74,
        85,
        98,
        113,
        124,
        142,
        151,
        168,
        181,
        194
      ],
      "page_139": [
        18,
        30,
        43,
        59,
        70,
        86,
        100,
        115,
        130,
        142,
        154,
        168,
        184,
        200,
        214
      ],
      "page_140": [
        12,
        22,
        33,
        44,
        58,
        70,
        82,
        97,
        110,
        122,
        136,
        151,
        169,
        183,
        194
      ],
      "page_141": [
        15,
        27,
        36,
        53,
        65,
        78,
        93,
        108,
        120,
        137,
        153,
        168,
        184,
        196,
        208
      ],
      "page_142": [
        16,
        29,
        42,
        52,
        68,
        80,
        95,
        104,
        117,
        130,
        142,
        155,
        167,
        180,
        194
      ],
      "page_143": [
        17,
        32,
        47,
        58,
        70,
        85,
        100,
        118,
        133,
        144,
        156,
        168,
        180,
        191,
        200
      ],
      "page_144": [
        14,
        25,
        35,
        46,
        55,
        69,
        80,
        94,
        108,
        121,
        128,
        140,
        151,
        163,
        173,
        187
      ],
      "page_145": [
        12,
        23,
        33,
        42,
        55,
        65,
        76,
        88,
        104,
        119,
        129,
        137,
        149,
        162
      ],
      "page_146": [
        13,
        25,
        38,
        47,
        59,
        72,
        82,
        94,
        103,
        112,
        122,
        135,
        146,
        158,
        166
      ],
      "page_147": [
        9,
        20,
        30,
        41,
        51,
        63,
        75,
        85,
        98,
        110,
        125,
        137,
        149,
        161,
        175
      ],
      "page_148": [
        14,
        23,
        39,
        50,
        64,
        76,
        88,
        100,
        113,
        124,
        135,
        147,
        159,
        173,
        184
      ],
      "page_149": [
        14,
        25,
        41,
        51,
        64,
        78,
        87,
        101,
        114,
        125,
        139,
        152,
        166,
        182,
        192
      ],
      "page_150": [
        14,
        28,
        41,
        53,
        70,
        85,
        102,
        113,
        130,
        144,
        159,
        173,
        190,
        203,
        217
      ],
      "page_151": [14, 27, 40, 55, 69, 86, 100, 112, 122, 137, 150, 165, 176],
      "page_152": [
        19,
        36,
        50,
        66,
        82,
        97,
        114,
        128,
        141,
        157,
        169,
        183,
        199,
        215,
        227
      ],
      "page_153": [
        19,
        31,
        45,
        58,
        69,
        83,
        94,
        110,
        124,
        139,
        155,
        168,
        180,
        191,
        201
      ],
      "page_154": [
        13,
        26,
        40,
        50,
        66,
        82,
        97,
        109,
        127,
        142,
        155,
        167,
        181,
        194,
        207
      ],
      "page_155": [
        13,
        24,
        41,
        53,
        69,
        79,
        93,
        106,
        118,
        129,
        139,
        152,
        170,
        185,
        198
      ],
      "page_156": [
        13,
        29,
        40,
        54,
        66,
        78,
        92,
        102,
        117,
        130,
        143,
        157,
        168,
        182,
        193
      ],
      "page_157": [
        16,
        28,
        41,
        57,
        70,
        80,
        90,
        100,
        113,
        124,
        138,
        148,
        159,
        178,
        186
      ],
      "page_158": [
        15,
        24,
        41,
        53,
        69,
        80,
        93,
        107,
        121,
        138,
        149,
        163,
        176,
        191,
        205
      ],
      "page_159": [
        16,
        29,
        42,
        52,
        66,
        79,
        90,
        102,
        116,
        129,
        142,
        153,
        167,
        179,
        191
      ],
      "page_160": [
        12,
        21,
        31,
        38,
        50,
        64,
        72,
        83,
        98,
        109,
        122,
        134,
        147,
        158,
        166
      ],
      "page_161": [
        12,
        22,
        34,
        43,
        54,
        68,
        77,
        87,
        97,
        105,
        117,
        128,
        136,
        148,
        157
      ],
      "page_162": [
        13,
        32,
        48,
        66,
        82,
        97,
        113,
        125,
        140,
        155,
        168,
        182,
        192,
        205,
        217
      ],
      "page_163": [
        16,
        32,
        43,
        55,
        67,
        79,
        90,
        105,
        118,
        133,
        145,
        158,
        173,
        184,
        195
      ],
      "page_164": [
        15,
        28,
        43,
        58,
        69,
        80,
        94,
        105,
        119,
        132,
        143,
        155,
        170,
        182,
        191
      ],
      "page_165": [
        12,
        26,
        40,
        53,
        67,
        84,
        97,
        113,
        125,
        139,
        152,
        169,
        181,
        192,
        201
      ],
      "page_166": [
        15,
        29,
        43,
        60,
        71,
        81,
        98,
        112,
        125,
        137,
        158,
        167,
        180,
        193,
        205
      ],
      "page_167": [
        14,
        30,
        44,
        55,
        66,
        74,
        85,
        94,
        109,
        124,
        136,
        152,
        166,
        180,
        191
      ],
      "page_168": [
        17,
        30,
        42,
        59,
        68,
        80,
        94,
        108,
        123,
        133,
        144,
        161,
        172,
        190,
        200
      ],
      "page_169": [
        15,
        31,
        48,
        62,
        76,
        86,
        99,
        110,
        127,
        137,
        151,
        164,
        182,
        197,
        213
      ],
      "page_170": [
        13,
        28,
        40,
        50,
        59,
        70,
        81,
        92,
        111,
        120,
        132,
        145,
        159,
        169,
        181
      ],
      "page_171": [
        13,
        24,
        35,
        49,
        61,
        73,
        86,
        98,
        105,
        118,
        130,
        138,
        147,
        157,
        169
      ],
      "page_172": [
        16,
        28,
        43,
        57,
        75,
        88,
        101,
        113,
        125,
        136,
        149,
        165,
        181,
        192,
        204
      ],
      "page_173": [
        18,
        35,
        51,
        68,
        81,
        99,
        109,
        124,
        136,
        155,
        166,
        178,
        186,
        200,
        210
      ],
      "page_174": [
        15,
        33,
        44,
        59,
        72,
        85,
        97,
        111,
        122,
        137,
        151,
        165,
        185,
        199,
        214
      ],
      "page_175": [
        18,
        31,
        43,
        58,
        71,
        84,
        99,
        112,
        123,
        139,
        148,
        160,
        174,
        188,
        202
      ],
      "page_176": [
        11,
        23,
        34,
        48,
        60,
        71,
        80,
        92,
        105,
        121,
        132,
        145,
        158,
        170,
        182
      ],
      "page_177": [14, 30, 39, 55, 65, 74, 87, 99, 111, 123, 134, 147, 157],
      "page_178": [
        14,
        24,
        40,
        51,
        66,
        78,
        94,
        106,
        118,
        134,
        145,
        157,
        171,
        184,
        195
      ],
      "page_179": [
        17,
        29,
        39,
        48,
        67,
        81,
        98,
        111,
        120,
        133,
        147,
        163,
        179,
        189,
        199
      ],
      "page_180": [
        10,
        26,
        37,
        51,
        65,
        78,
        91,
        104,
        122,
        134,
        149,
        159,
        171,
        184,
        197
      ],
      "page_181": [
        13,
        25,
        36,
        46,
        56,
        70,
        81,
        90,
        102,
        110,
        125,
        134,
        146,
        159,
        171
      ],
      "page_182": [
        18,
        30,
        45,
        55,
        66,
        78,
        89,
        101,
        113,
        128,
        140,
        153,
        165,
        177,
        188
      ],
      "page_183": [
        18,
        31,
        42,
        56,
        67,
        80,
        96,
        106,
        117,
        127,
        137,
        148,
        161,
        175,
        187
      ],
      "page_184": [
        15,
        27,
        43,
        56,
        68,
        80,
        94,
        104,
        117,
        129,
        143,
        156,
        169,
        181,
        196
      ],
      "page_185": [
        15,
        29,
        41,
        55,
        67,
        76,
        87,
        98,
        113,
        124,
        137,
        147,
        159,
        175,
        187
      ],
      "page_186": [
        15,
        31,
        44,
        57,
        73,
        88,
        103,
        117,
        131,
        144,
        155,
        170,
        183,
        199,
        213
      ],
      "page_187": [
        12,
        26,
        39,
        49,
        68,
        81,
        91,
        106,
        117,
        133,
        148,
        161,
        173,
        187
      ],
      "page_188": [
        9,
        20,
        33,
        44,
        59,
        70,
        82,
        92,
        107,
        119,
        134,
        145,
        156,
        166,
        179
      ],
      "page_189": [
        15,
        24,
        37,
        49,
        64,
        75,
        85,
        94,
        106,
        119,
        128,
        141,
        155,
        168,
        182
      ],
      "page_190": [
        16,
        27,
        36,
        46,
        58,
        73,
        85,
        97,
        113,
        122,
        133,
        142,
        154,
        166,
        175
      ],
      "page_191": [
        12,
        21,
        32,
        46,
        54,
        68,
        81,
        91,
        100,
        109,
        118,
        125,
        135,
        146,
        153
      ],
      "page_192": [
        13,
        23,
        36,
        44,
        54,
        63,
        73,
        84,
        98,
        114,
        122,
        131,
        144,
        152,
        162
      ],
      "page_193": [
        12,
        26,
        40,
        46,
        62,
        71,
        80,
        90,
        102,
        114,
        124,
        135,
        148,
        155,
        164
      ],
      "page_194": [
        14,
        26,
        39,
        53,
        65,
        80,
        89,
        101,
        114,
        127,
        136,
        150,
        161,
        174,
        186
      ],
      "page_195": [
        14,
        23,
        37,
        46,
        56,
        69,
        79,
        91,
        101,
        112,
        124,
        137,
        149,
        164,
        175
      ],
      "page_196": [
        17,
        29,
        46,
        53,
        67,
        85,
        97,
        113,
        123,
        135,
        147,
        157,
        167,
        180,
        193
      ],
      "page_197": [
        14,
        27,
        42,
        47,
        62,
        71,
        87,
        99,
        110,
        119,
        128,
        140,
        146,
        154,
        168
      ],
      "page_198": [
        13,
        28,
        41,
        51,
        61,
        74,
        82,
        95,
        106,
        115,
        124,
        136,
        146,
        156,
        165
      ],
      "page_199": [
        12,
        22,
        37,
        57,
        74,
        87,
        100,
        112,
        129,
        144,
        158,
        170,
        175,
        183,
        198
      ],
      "page_200": [
        14,
        31,
        39,
        53,
        69,
        83,
        96,
        113,
        128,
        142,
        160,
        176,
        189,
        204,
        216
      ],
      "page_201": [
        14,
        24,
        37,
        47,
        59,
        71,
        84,
        95,
        108,
        117,
        131,
        144,
        154,
        165,
        177
      ],
      "page_202": [
        13,
        26,
        37,
        49,
        66,
        79,
        89,
        101,
        111,
        124,
        135,
        145,
        155,
        167,
        180
      ],
      "page_203": [
        9,
        23,
        34,
        44,
        55,
        66,
        76,
        89,
        105,
        118,
        131,
        145,
        158,
        171,
        184
      ],
      "page_204": [
        10,
        22,
        38,
        50,
        62,
        72,
        84,
        99,
        108,
        120,
        130,
        141,
        151,
        164,
        177
      ],
      "page_205": [
        4,
        9,
        18,
        29,
        39,
        50,
        62,
        80,
        92,
        105,
        119,
        131,
        140,
        149,
        161
      ],
      "page_206": [
        12,
        27,
        42,
        55,
        65,
        78,
        92,
        103,
        114,
        124,
        135,
        148,
        156,
        169,
        182
      ],
      "page_207": [
        12,
        25,
        40,
        53,
        64,
        77,
        87,
        97,
        108,
        121,
        130,
        140,
        152,
        163
      ],
      "page_208": [
        10,
        24,
        36,
        48,
        60,
        75,
        87,
        99,
        111,
        121,
        134,
        145,
        157,
        167
      ],
      "page_209": [
        15,
        27,
        37,
        50,
        62,
        78,
        87,
        100,
        111,
        126,
        143,
        155,
        172,
        183,
        193
      ],
      "page_210": [
        12,
        27,
        43,
        55,
        72,
        85,
        98,
        106,
        119,
        133,
        145,
        155,
        168,
        182,
        194
      ],
      "page_211": [
        16,
        28,
        42,
        57,
        72,
        89,
        101,
        114,
        128,
        144,
        156,
        169,
        185,
        196,
        207
      ],
      "page_212": [
        13,
        25,
        41,
        53,
        64,
        80,
        96,
        110,
        125,
        138,
        151,
        163,
        179,
        190,
        202
      ],
      "page_213": [
        14,
        28,
        43,
        57,
        73,
        86,
        99,
        114,
        129,
        149,
        159,
        178,
        196,
        211,
        225
      ],
      "page_214": [
        16,
        26,
        39,
        53,
        72,
        86,
        100,
        111,
        128,
        140,
        156,
        174,
        185,
        196,
        213
      ],
      "page_215": [
        17,
        30,
        43,
        56,
        67,
        82,
        101,
        113,
        130,
        139,
        152,
        166,
        179,
        195,
        208
      ],
      "page_216": [
        12,
        22,
        33,
        44,
        55,
        66,
        74,
        85,
        97,
        107,
        120,
        132,
        141,
        152,
        161
      ],
      "page_217": [
        18,
        34,
        50,
        67,
        79,
        98,
        113,
        128,
        148,
        159,
        174,
        189,
        204,
        222,
        236
      ],
      "page_218": [
        15,
        29,
        45,
        57,
        69,
        83,
        99,
        117,
        131,
        145,
        159,
        169,
        184,
        199,
        213
      ],
      "page_219": [
        12,
        22,
        36,
        51,
        65,
        78,
        91,
        106,
        122,
        141,
        153,
        167,
        178,
        188,
        198
      ],
      "page_220": [
        14,
        29,
        43,
        54,
        66,
        76,
        88,
        100,
        112,
        125,
        141,
        155,
        167,
        179,
        197
      ],
      "page_221": [16, 34, 45, 61, 77, 90, 101, 119, 135, 151, 165, 177, 189],
      "page_222": [
        15,
        26,
        36,
        50,
        61,
        75,
        87,
        100,
        117,
        129,
        143,
        155,
        167,
        182,
        195
      ],
      "page_223": [
        13,
        25,
        41,
        53,
        68,
        78,
        92,
        111,
        123,
        140,
        152,
        162,
        174,
        183,
        194
      ],
      "page_224": [
        13,
        24,
        34,
        48,
        59,
        69,
        79,
        90,
        105,
        118,
        134,
        147,
        160,
        179,
        194
      ],
      "page_225": [
        17,
        33,
        49,
        61,
        75,
        91,
        108,
        123,
        139,
        153,
        166,
        182,
        197,
        211,
        225
      ],
      "page_226": [
        16,
        30,
        44,
        58,
        71,
        84,
        100,
        114,
        129,
        142,
        156,
        168,
        180,
        195,
        207
      ],
      "page_227": [
        18,
        33,
        52,
        64,
        80,
        93,
        106,
        119,
        135,
        149,
        162,
        176,
        189,
        203,
        217
      ],
      "page_228": [
        15,
        30,
        46,
        61,
        78,
        95,
        113,
        127,
        145,
        159,
        173,
        188,
        206,
        223,
        240
      ],
      "page_229": [
        17,
        34,
        45,
        61,
        74,
        85,
        100,
        111,
        121,
        135,
        149,
        163,
        176,
        191,
        204
      ],
      "page_230": [
        15,
        27,
        41,
        53,
        66,
        81,
        96,
        111,
        123,
        139,
        160,
        175,
        193,
        208,
        220
      ],
      "page_231": [
        16,
        24,
        36,
        50,
        62,
        74,
        85,
        94,
        107,
        120,
        134,
        147,
        163,
        175,
        193
      ],
      "page_232": [
        14,
        28,
        43,
        55,
        75,
        90,
        103,
        115,
        127,
        142,
        155,
        166,
        180,
        194,
        208
      ],
      "page_233": [
        12,
        23,
        33,
        47,
        60,
        75,
        90,
        102,
        112,
        125,
        142,
        156,
        170,
        183,
        194
      ],
      "page_234": [
        15,
        29,
        43,
        60,
        76,
        91,
        104,
        118,
        128,
        135,
        146,
        157,
        171,
        185,
        197
      ],
      "page_235": [14, 29, 40, 56, 69, 83, 97, 113, 124, 133, 149, 164, 176],
      "page_236": [
        15,
        26,
        38,
        54,
        66,
        81,
        96,
        110,
        121,
        134,
        151,
        167,
        186,
        199,
        210
      ],
      "page_237": [
        18,
        34,
        48,
        62,
        77,
        91,
        100,
        118,
        131,
        142,
        155,
        170,
        182,
        195,
        206
      ],
      "page_238": [
        14,
        29,
        44,
        57,
        67,
        80,
        94,
        106,
        120,
        133,
        146,
        156,
        169,
        179,
        194
      ],
      "page_239": [
        14,
        31,
        49,
        67,
        82,
        97,
        113,
        129,
        143,
        156,
        171,
        186,
        198,
        216,
        228
      ],
      "page_240": [
        13,
        29,
        38,
        47,
        58,
        73,
        85,
        94,
        107,
        118,
        134,
        144,
        155,
        166,
        178
      ],
      "page_241": [
        12,
        28,
        40,
        49,
        61,
        77,
        89,
        104,
        119,
        136,
        148,
        161,
        175,
        190,
        206
      ],
      "page_242": [
        16,
        32,
        48,
        62,
        75,
        89,
        101,
        117,
        137,
        152,
        173,
        190,
        203,
        219,
        233
      ],
      "page_243": [
        16,
        29,
        43,
        57,
        67,
        82,
        100,
        113,
        127,
        143,
        156,
        168,
        185,
        199,
        214
      ],
      "page_244": [
        13,
        25,
        38,
        55,
        71,
        85,
        98,
        111,
        126,
        137,
        147,
        162,
        177,
        190,
        202
      ],
      "page_245": [
        15,
        27,
        41,
        55,
        71,
        86,
        102,
        117,
        130,
        144,
        156,
        166,
        176,
        185,
        198
      ],
      "page_246": [
        16,
        28,
        40,
        56,
        65,
        79,
        91,
        108,
        119,
        133,
        144,
        158,
        169,
        182,
        195
      ],
      "page_247": [
        14,
        30,
        45,
        57,
        71,
        84,
        101,
        118,
        132,
        144,
        155,
        166,
        177,
        193,
        207
      ],
      "page_248": [
        14,
        25,
        38,
        51,
        62,
        76,
        89,
        103,
        112,
        127,
        139,
        154,
        165,
        176,
        187
      ],
      "page_249": [13, 23, 37, 48, 63, 76, 88, 99, 112, 125, 141, 152, 162],
      "page_250": [
        11,
        26,
        38,
        53,
        64,
        76,
        84,
        99,
        112,
        126,
        144,
        157,
        169,
        181,
        192
      ],
      "page_251": [
        17,
        37,
        49,
        62,
        77,
        92,
        109,
        122,
        136,
        151,
        164,
        177,
        190,
        210,
        222
      ],
      "page_252": [
        20,
        31,
        45,
        56,
        71,
        83,
        98,
        114,
        125,
        139,
        151,
        165,
        179,
        192,
        205
      ],
      "page_253": [
        12,
        26,
        42,
        56,
        69,
        82,
        94,
        107,
        120,
        133,
        146,
        161,
        175,
        190,
        204
      ],
      "page_254": [
        10,
        22,
        30,
        43,
        58,
        72,
        90,
        104,
        117,
        131,
        147,
        161,
        174,
        187,
        199
      ],
      "page_255": [13, 24, 36, 46, 59, 66, 74, 85, 98, 110, 122, 133, 143],
      "page_256": [
        12,
        22,
        32,
        45,
        60,
        71,
        84,
        96,
        108,
        125,
        144,
        155,
        169,
        182,
        194
      ],
      "page_257": [
        14,
        29,
        42,
        60,
        72,
        86,
        100,
        109,
        120,
        131,
        144,
        157,
        167,
        178,
        187
      ],
      "page_258": [
        13,
        27,
        40,
        56,
        71,
        86,
        98,
        112,
        131,
        146,
        159,
        170,
        184,
        196,
        207
      ],
      "page_259": [
        13,
        22,
        33,
        44,
        57,
        67,
        79,
        92,
        104,
        117,
        131,
        142,
        156,
        170,
        181
      ],
      "page_260": [
        14,
        26,
        38,
        48,
        66,
        81,
        92,
        103,
        118,
        129,
        141,
        153,
        167,
        178,
        189
      ],
      "page_261": [
        10,
        21,
        34,
        46,
        57,
        71,
        82,
        94,
        104,
        113,
        122,
        131,
        141,
        154,
        167
      ],
      "page_262": [10, 19, 30, 42, 56, 69, 80, 95, 110, 122, 134, 147, 158],
      "page_263": [
        12,
        23,
        36,
        49,
        64,
        79,
        93,
        108,
        120,
        135,
        146,
        161,
        174,
        187,
        195
      ],
      "page_264": [
        14,
        25,
        41,
        54,
        64,
        78,
        89,
        101,
        112,
        124,
        134,
        147,
        160,
        172,
        181
      ],
      "page_265": [
        14,
        29,
        41,
        52,
        64,
        75,
        89,
        97,
        111,
        124,
        141,
        153,
        161,
        171,
        186
      ],
      "page_266": [
        17,
        28,
        41,
        55,
        66,
        83,
        97,
        108,
        119,
        135,
        146,
        157,
        171,
        186,
        197
      ],
      "page_267": [12, 25, 33, 45, 61, 71, 85, 98, 112, 121, 131, 144, 155],
      "page_268": [
        13,
        24,
        36,
        51,
        60,
        73,
        85,
        94,
        105,
        118,
        127,
        137,
        148,
        159,
        171
      ],
      "page_269": [
        13,
        23,
        37,
        48,
        59,
        69,
        79,
        91,
        101,
        112,
        122,
        133,
        146,
        158,
        169
      ],
      "page_270": [
        11,
        23,
        32,
        47,
        60,
        70,
        86,
        99,
        108,
        119,
        128,
        140,
        153,
        167,
        184
      ],
      "page_271": [
        15,
        32,
        44,
        57,
        71,
        84,
        92,
        105,
        119,
        129,
        143,
        160,
        176,
        190,
        199
      ],
      "page_272": [
        16,
        31,
        44,
        57,
        68,
        83,
        98,
        111,
        124,
        136,
        146,
        164,
        181,
        196,
        208
      ],
      "page_273": [
        15,
        33,
        46,
        60,
        74,
        87,
        100,
        114,
        128,
        140,
        153,
        168,
        183,
        197,
        209
      ],
      "page_274": [
        16,
        32,
        47,
        59,
        74,
        87,
        101,
        117,
        131,
        143,
        157,
        175,
        186,
        200,
        212
      ],
      "page_275": [
        13,
        25,
        36,
        50,
        63,
        73,
        86,
        100,
        111,
        121,
        131,
        142,
        153,
        163,
        176
      ],
      "page_276": [
        15,
        26,
        41,
        55,
        64,
        76,
        89,
        97,
        107,
        119,
        134,
        145,
        157,
        171,
        182
      ],
      "page_277": [
        13,
        24,
        37,
        49,
        60,
        72,
        82,
        95,
        107,
        117,
        127,
        141,
        156,
        169,
        182
      ],
      "page_278": [
        12,
        27,
        39,
        52,
        66,
        75,
        88,
        100,
        112,
        126,
        137,
        148,
        163,
        175,
        186
      ],
      "page_279": [
        13,
        23,
        34,
        44,
        53,
        67,
        76,
        88,
        97,
        105,
        115,
        124,
        134,
        146,
        158
      ],
      "page_280": [
        11,
        22,
        32,
        44,
        57,
        71,
        84,
        94,
        107,
        122,
        132,
        143,
        152,
        169,
        183
      ],
      "page_281": [
        16,
        30,
        42,
        54,
        69,
        82,
        92,
        106,
        118,
        129,
        144,
        161,
        174,
        190,
        200
      ],
      "page_282": [11, 26, 38, 49, 60, 73, 86, 100, 111, 127, 144, 155, 169],
      "page_283": [
        18,
        29,
        38,
        51,
        64,
        80,
        92,
        104,
        120,
        134,
        150,
        165,
        182,
        198,
        212
      ],
      "page_284": [
        16,
        28,
        41,
        50,
        62,
        75,
        86,
        100,
        115,
        130,
        143,
        155,
        168,
        179,
        190
      ],
      "page_285": [
        18,
        32,
        43,
        59,
        72,
        84,
        95,
        111,
        124,
        138,
        152,
        168,
        179,
        193,
        204
      ],
      "page_286": [
        16,
        29,
        42,
        58,
        75,
        88,
        106,
        119,
        132,
        147,
        164,
        179,
        188,
        201,
        218
      ],
      "page_287": [
        12,
        26,
        40,
        52,
        66,
        77,
        90,
        104,
        118,
        131,
        144,
        154,
        167,
        179,
        189
      ],
      "page_288": [
        14,
        30,
        48,
        60,
        72,
        87,
        102,
        116,
        130,
        140,
        158,
        171,
        183,
        195,
        207
      ],
      "page_289": [
        14,
        28,
        40,
        54,
        69,
        85,
        100,
        113,
        128,
        138,
        151,
        164,
        181,
        196,
        208
      ],
      "page_290": [
        14,
        27,
        40,
        50,
        60,
        73,
        85,
        100,
        111,
        122,
        138,
        151,
        164,
        182,
        198
      ],
      "page_291": [
        13,
        26,
        39,
        55,
        67,
        79,
        90,
        103,
        115,
        129,
        142,
        156,
        165,
        178,
        192
      ],
      "page_292": [
        16,
        30,
        42,
        61,
        76,
        87,
        101,
        114,
        126,
        140,
        155,
        168,
        178,
        196,
        209
      ],
      "page_293": [19, 36, 55, 68, 81, 96, 111, 126, 143, 158, 169, 177, 189],
      "page_294": [
        16,
        28,
        41,
        56,
        69,
        80,
        95,
        110,
        121,
        134,
        149,
        165,
        179,
        192,
        204
      ],
      "page_295": [
        15,
        31,
        41,
        53,
        67,
        79,
        93,
        108,
        122,
        138,
        154,
        168,
        184,
        197,
        210
      ],
      "page_296": [
        16,
        30,
        45,
        56,
        67,
        81,
        97,
        112,
        125,
        141,
        154,
        167,
        183,
        195,
        209
      ],
      "page_297": [
        13,
        26,
        44,
        61,
        77,
        90,
        101,
        111,
        125,
        136,
        147,
        163,
        178,
        195,
        210
      ],
      "page_298": [
        16,
        33,
        49,
        62,
        80,
        99,
        115,
        126,
        140,
        154,
        172,
        184,
        199,
        213,
        226
      ],
      "page_299": [
        9,
        23,
        38,
        58,
        70,
        84,
        99,
        114,
        130,
        146,
        156,
        170,
        184,
        199,
        214
      ],
      "page_300": [
        14,
        24,
        37,
        47,
        57,
        70,
        86,
        101,
        116,
        129,
        143,
        155,
        169,
        179,
        191
      ],
      "page_301": [
        18,
        34,
        49,
        63,
        77,
        94,
        108,
        120,
        134,
        152,
        166,
        182,
        197,
        212,
        227
      ],
      "page_302": [
        15,
        33,
        45,
        59,
        74,
        89,
        101,
        114,
        127,
        143,
        154,
        171,
        182,
        198,
        212
      ],
      "page_303": [
        19,
        30,
        47,
        63,
        79,
        93,
        107,
        122,
        134,
        144,
        157,
        176,
        192,
        207,
        220
      ],
      "page_304": [
        20,
        34,
        47,
        62,
        78,
        91,
        104,
        118,
        132,
        152,
        162,
        178,
        196,
        214,
        230
      ],
      "page_305": [9, 22, 34, 47, 61, 72, 86, 98, 109, 125, 137, 148, 159],
      "page_306": [
        12,
        29,
        41,
        52,
        63,
        79,
        93,
        106,
        119,
        135,
        148,
        157,
        169,
        185,
        197
      ],
      "page_307": [
        15,
        29,
        45,
        57,
        71,
        84,
        98,
        113,
        125,
        135,
        149,
        169,
        180,
        195,
        206
      ],
      "page_308": [
        16,
        31,
        46,
        63,
        80,
        91,
        103,
        115,
        129,
        144,
        160,
        174,
        188,
        204,
        217
      ],
      "page_309": [
        19,
        33,
        46,
        61,
        73,
        90,
        106,
        118,
        130,
        142,
        153,
        167,
        181,
        198,
        216
      ],
      "page_310": [
        16,
        30,
        44,
        58,
        69,
        82,
        98,
        108,
        123,
        134,
        147,
        163,
        176,
        187,
        198
      ],
      "page_311": [
        16,
        25,
        39,
        52,
        65,
        78,
        92,
        101,
        111,
        121,
        130,
        142,
        154,
        165,
        177
      ],
      "page_312": [12, 27, 40, 53, 64, 75, 87, 101, 116, 126, 146, 160, 173],
      "page_313": [
        18,
        30,
        44,
        60,
        72,
        89,
        102,
        115,
        128,
        139,
        155,
        169,
        185,
        199,
        214
      ],
      "page_314": [
        16,
        37,
        54,
        72,
        90,
        104,
        121,
        136,
        150,
        165,
        181,
        199,
        211,
        225,
        237
      ],
      "page_315": [
        16,
        31,
        44,
        59,
        77,
        96,
        113,
        129,
        140,
        152,
        165,
        180,
        191,
        203,
        218
      ],
      "page_316": [
        16,
        33,
        47,
        63,
        75,
        92,
        108,
        123,
        139,
        153,
        173,
        189,
        207,
        217,
        230
      ],
      "page_317": [
        17,
        30,
        46,
        63,
        77,
        93,
        111,
        123,
        138,
        156,
        166,
        182,
        196,
        213,
        226
      ],
      "page_318": [
        14,
        29,
        45,
        64,
        78,
        93,
        111,
        127,
        140,
        154,
        168,
        184,
        198,
        213,
        225
      ],
      "page_319": [
        18,
        30,
        42,
        50,
        64,
        77,
        89,
        100,
        114,
        128,
        143,
        155,
        167,
        182,
        194
      ],
      "page_320": [
        13,
        28,
        44,
        56,
        74,
        88,
        102,
        114,
        130,
        143,
        159,
        172,
        186,
        200,
        214
      ],
      "page_321": [
        16,
        33,
        49,
        61,
        74,
        88,
        103,
        119,
        137,
        152,
        170,
        184,
        200,
        213,
        223
      ],
      "page_322": [10, 25, 34, 48, 58, 68, 83, 96, 111, 123, 135, 147, 162],
      "page_323": [
        14,
        26,
        42,
        57,
        69,
        82,
        98,
        114,
        128,
        138,
        148,
        163,
        177,
        193,
        205
      ],
      "page_324": [
        17,
        31,
        41,
        54,
        67,
        82,
        94,
        108,
        122,
        136,
        146,
        158,
        173,
        184,
        197
      ],
      "page_325": [
        14,
        24,
        32,
        42,
        52,
        65,
        76,
        87,
        103,
        114,
        123,
        135,
        147,
        162,
        172
      ],
      "page_326": [
        13,
        25,
        38,
        50,
        63,
        76,
        88,
        101,
        115,
        130,
        144,
        161,
        173,
        184,
        195
      ],
      "page_327": [
        13,
        26,
        42,
        54,
        68,
        81,
        93,
        104,
        117,
        129,
        146,
        158,
        173,
        187,
        198
      ],
      "page_328": [
        15,
        27,
        41,
        52,
        64,
        79,
        91,
        107,
        116,
        129,
        144,
        154,
        168,
        181,
        195
      ],
      "page_329": [
        11,
        22,
        33,
        52,
        65,
        75,
        86,
        99,
        112,
        125,
        134,
        147,
        161,
        172,
        184
      ],
      "page_330": [
        13,
        25,
        37,
        48,
        59,
        72,
        82,
        91,
        101,
        116,
        125,
        133,
        144,
        157,
        167
      ],
      "page_331": [
        11,
        20,
        28,
        40,
        55,
        66,
        76,
        86,
        100,
        113,
        125,
        135,
        147,
        157
      ],
      "page_332": [
        13,
        25,
        37,
        48,
        59,
        75,
        87,
        100,
        112,
        124,
        137,
        150,
        163,
        176
      ],
      "page_333": [
        17,
        32,
        46,
        61,
        71,
        87,
        102,
        114,
        125,
        137,
        150,
        161,
        173,
        189,
        203
      ],
      "page_334": [
        14,
        26,
        38,
        50,
        62,
        75,
        91,
        99,
        112,
        123,
        136,
        152,
        163,
        173,
        184
      ],
      "page_335": [
        13,
        24,
        37,
        51,
        62,
        75,
        87,
        96,
        106,
        118,
        128,
        139,
        151,
        163,
        174
      ],
      "page_336": [
        17,
        30,
        42,
        56,
        68,
        82,
        92,
        103,
        119,
        136,
        154,
        168,
        183,
        194,
        205
      ],
      "page_337": [
        17,
        29,
        43,
        55,
        68,
        79,
        93,
        105,
        118,
        130,
        142,
        156,
        168,
        182,
        192
      ],
      "page_338": [
        14,
        26,
        42,
        55,
        67,
        77,
        91,
        103,
        115,
        127,
        139,
        153,
        169,
        181,
        191
      ],
      "page_339": [
        11,
        20,
        33,
        44,
        58,
        66,
        78,
        92,
        102,
        112,
        123,
        134,
        146,
        156,
        167
      ],
      "page_340": [
        14,
        27,
        40,
        52,
        65,
        78,
        92,
        103,
        119,
        125,
        141,
        155,
        164,
        180,
        191
      ],
      "page_341": [
        12,
        25,
        37,
        49,
        57,
        67,
        80,
        93,
        104,
        116,
        127,
        139,
        152,
        166
      ],
      "page_342": [9, 20, 30, 44, 54, 67, 73, 85, 96, 109, 121, 132, 143, 156],
      "page_343": [
        18,
        33,
        47,
        58,
        78,
        91,
        106,
        121,
        136,
        151,
        165,
        180,
        197,
        211,
        224
      ],
      "page_344": [
        16,
        30,
        46,
        61,
        79,
        93,
        107,
        123,
        140,
        150,
        162,
        176,
        189,
        204,
        213
      ],
      "page_345": [
        14,
        29,
        44,
        59,
        73,
        86,
        99,
        115,
        129,
        142,
        158,
        173,
        187,
        198,
        211
      ],
      "page_346": [
        15,
        27,
        42,
        56,
        70,
        82,
        94,
        105,
        118,
        133,
        147,
        163,
        176,
        189,
        200
      ],
      "page_347": [
        18,
        33,
        46,
        60,
        72,
        86,
        98,
        113,
        126,
        137,
        151,
        160,
        172,
        187,
        198
      ],
      "page_348": [
        15,
        31,
        43,
        54,
        67,
        82,
        93,
        105,
        114,
        126,
        138,
        152,
        163,
        174,
        184
      ],
      "page_349": [
        15,
        29,
        45,
        61,
        76,
        88,
        101,
        114,
        127,
        143,
        155,
        165,
        184,
        195
      ],
      "page_350": [
        18,
        34,
        52,
        64,
        78,
        88,
        103,
        117,
        130,
        146,
        158,
        173,
        185,
        199
      ],
      "page_351": [
        16,
        32,
        48,
        61,
        76,
        89,
        104,
        122,
        138,
        153,
        166,
        178,
        190,
        203,
        215
      ],
      "page_352": [
        13,
        25,
        41,
        54,
        66,
        81,
        91,
        103,
        118,
        132,
        141,
        151,
        165,
        176,
        188
      ],
      "page_353": [
        15,
        33,
        42,
        56,
        66,
        78,
        88,
        103,
        118,
        132,
        146,
        157,
        166,
        182,
        191
      ],
      "page_354": [
        15,
        27,
        41,
        54,
        71,
        83,
        97,
        112,
        124,
        135,
        145,
        160,
        174,
        188,
        203
      ],
      "page_355": [
        14,
        25,
        41,
        55,
        69,
        83,
        99,
        111,
        131,
        144,
        161,
        174,
        188,
        206,
        219
      ],
      "page_356": [
        13,
        32,
        46,
        58,
        68,
        85,
        100,
        115,
        129,
        142,
        158,
        170,
        185,
        201,
        211
      ],
      "page_357": [
        17,
        32,
        45,
        54,
        67,
        82,
        94,
        108,
        117,
        131,
        145,
        157,
        170,
        184,
        195
      ],
      "page_358": [
        12,
        23,
        33,
        44,
        54,
        66,
        79,
        90,
        100,
        110,
        120,
        130,
        142,
        153,
        161
      ],
      "page_359": [16, 28, 40, 56, 65, 76, 86, 99, 114, 130, 142, 156, 169],
      "page_360": [
        13,
        27,
        41,
        56,
        68,
        79,
        88,
        99,
        110,
        125,
        132,
        144,
        155,
        167,
        180
      ],
      "page_361": [
        12,
        24,
        34,
        45,
        57,
        69,
        81,
        93,
        108,
        120,
        132,
        144,
        157,
        167,
        177
      ],
      "page_362": [
        12,
        27,
        37,
        52,
        59,
        71,
        81,
        91,
        104,
        117,
        128,
        139,
        153,
        166,
        180
      ],
      "page_363": [
        15,
        23,
        35,
        48,
        61,
        76,
        88,
        98,
        114,
        125,
        138,
        148,
        162,
        172,
        185
      ],
      "page_364": [
        11,
        25,
        40,
        54,
        65,
        77,
        89,
        105,
        117,
        131,
        141,
        152,
        165,
        178,
        193
      ],
      "page_365": [
        15,
        28,
        42,
        52,
        64,
        80,
        94,
        106,
        118,
        128,
        139,
        150,
        162,
        172,
        184
      ],
      "page_366": [
        12,
        25,
        35,
        47,
        57,
        69,
        81,
        93,
        105,
        121,
        131,
        141,
        152,
        163
      ],
      "page_367": [
        12,
        24,
        38,
        56,
        73,
        87,
        102,
        113,
        127,
        141,
        155,
        168,
        185,
        197
      ],
      "page_368": [
        18,
        33,
        48,
        61,
        76,
        87,
        100,
        113,
        131,
        142,
        157,
        169,
        186,
        196,
        207
      ],
      "page_369": [
        13,
        30,
        45,
        63,
        75,
        86,
        102,
        117,
        133,
        151,
        165,
        174,
        190,
        203,
        216
      ],
      "page_370": [
        11,
        27,
        41,
        55,
        67,
        78,
        94,
        105,
        116,
        132,
        144,
        157,
        172,
        186,
        198
      ],
      "page_371": [
        14,
        30,
        44,
        55,
        70,
        83,
        98,
        111,
        124,
        140,
        152,
        165,
        183,
        198,
        212
      ],
      "page_372": [
        17,
        30,
        44,
        64,
        79,
        92,
        104,
        120,
        136,
        150,
        158,
        173,
        188,
        200,
        213
      ],
      "page_373": [
        14,
        29,
        41,
        56,
        75,
        86,
        97,
        111,
        120,
        132,
        146,
        161,
        176,
        189,
        200
      ],
      "page_374": [
        14,
        30,
        43,
        56,
        71,
        83,
        100,
        113,
        128,
        139,
        153,
        169,
        183,
        191,
        203
      ],
      "page_375": [
        15,
        29,
        40,
        53,
        65,
        80,
        94,
        105,
        121,
        135,
        151,
        161,
        172,
        185,
        197
      ],
      "page_376": [
        15,
        29,
        41,
        53,
        62,
        78,
        88,
        101,
        111,
        120,
        133,
        143,
        158,
        171
      ],
      "page_377": [
        10,
        20,
        34,
        45,
        58,
        75,
        92,
        106,
        119,
        136,
        150,
        166,
        182,
        194
      ],
      "page_378": [
        16,
        28,
        42,
        54,
        67,
        81,
        93,
        107,
        120,
        136,
        149,
        162,
        173,
        186,
        203
      ],
      "page_379": [
        15,
        26,
        41,
        54,
        65,
        75,
        88,
        104,
        119,
        133,
        149,
        162,
        175,
        189,
        203
      ],
      "page_380": [
        18,
        33,
        51,
        67,
        82,
        98,
        116,
        135,
        153,
        166,
        183,
        200,
        214,
        228,
        243
      ],
      "page_381": [
        14,
        25,
        34,
        49,
        59,
        67,
        85,
        99,
        110,
        123,
        134,
        147,
        160,
        170,
        178
      ],
      "page_382": [
        13,
        25,
        39,
        50,
        62,
        74,
        88,
        99,
        111,
        123,
        133,
        143,
        155,
        166,
        177
      ],
      "page_383": [
        15,
        28,
        41,
        52,
        66,
        82,
        93,
        103,
        116,
        127,
        139,
        152,
        167,
        178,
        188
      ],
      "page_384": [
        15,
        29,
        41,
        55,
        68,
        81,
        95,
        110,
        127,
        142,
        157,
        171,
        185,
        197,
        209
      ],
      "page_385": [16, 30, 43, 58, 72, 87, 104, 112, 123, 133, 146, 156, 166],
      "page_386": [
        14,
        26,
        43,
        57,
        70,
        79,
        93,
        105,
        118,
        130,
        145,
        158,
        170,
        187,
        197
      ],
      "page_387": [
        17,
        27,
        42,
        57,
        71,
        90,
        104,
        115,
        130,
        144,
        160,
        173,
        185,
        199,
        212
      ],
      "page_388": [
        13,
        24,
        34,
        46,
        58,
        75,
        87,
        103,
        113,
        124,
        137,
        150,
        164,
        175,
        188
      ],
      "page_389": [
        13,
        30,
        41,
        52,
        63,
        76,
        88,
        99,
        111,
        124,
        137,
        151,
        165,
        180,
        192
      ],
      "page_390": [
        15,
        26,
        42,
        52,
        65,
        82,
        94,
        108,
        125,
        133,
        144,
        154,
        165,
        174,
        184
      ],
      "page_391": [
        17,
        29,
        41,
        55,
        68,
        79,
        92,
        106,
        118,
        131,
        146,
        160,
        172,
        187,
        196
      ],
      "page_392": [
        12,
        26,
        47,
        59,
        73,
        91,
        103,
        114,
        129,
        141,
        155,
        166,
        180,
        191,
        204
      ],
      "page_393": [
        16,
        32,
        48,
        59,
        71,
        86,
        100,
        115,
        125,
        137,
        150,
        164,
        176,
        190,
        203
      ],
      "page_394": [
        13,
        26,
        38,
        49,
        63,
        78,
        89,
        102,
        117,
        127,
        143,
        157,
        169,
        184,
        195
      ],
      "page_395": [
        18,
        32,
        44,
        56,
        69,
        82,
        94,
        110,
        120,
        131,
        147,
        157,
        171,
        188,
        198
      ],
      "page_396": [14, 29, 42, 52, 67, 79, 92, 104, 120, 130, 140, 154, 168],
      "page_397": [
        14,
        27,
        46,
        62,
        75,
        90,
        105,
        122,
        133,
        146,
        160,
        173,
        185,
        200,
        210
      ],
      "page_398": [
        14,
        29,
        40,
        50,
        63,
        78,
        91,
        101,
        113,
        124,
        135,
        147,
        160,
        174,
        186
      ],
      "page_399": [
        17,
        31,
        44,
        53,
        64,
        77,
        88,
        102,
        116,
        128,
        140,
        150,
        161,
        176,
        184
      ],
      "page_400": [
        13,
        22,
        38,
        49,
        62,
        78,
        88,
        98,
        110,
        123,
        134,
        148,
        158,
        168,
        177
      ],
      "page_401": [
        14,
        24,
        40,
        55,
        69,
        78,
        87,
        96,
        106,
        116,
        127,
        137,
        148,
        156,
        168
      ],
      "page_402": [
        11,
        28,
        42,
        55,
        68,
        80,
        94,
        102,
        116,
        130,
        147,
        158,
        170,
        181,
        191
      ],
      "page_403": [
        12,
        25,
        36,
        52,
        68,
        78,
        91,
        102,
        115,
        130,
        143,
        156,
        174,
        188,
        200
      ],
      "page_404": [15, 28, 41, 54, 68, 80, 96, 107, 120, 129, 140, 149, 159],
      "page_405": [
        13,
        23,
        35,
        50,
        63,
        75,
        90,
        104,
        116,
        130,
        143,
        155,
        165,
        175,
        186
      ],
      "page_406": [
        12,
        22,
        33,
        44,
        57,
        70,
        82,
        94,
        106,
        117,
        130,
        143,
        155,
        168,
        179
      ],
      "page_407": [
        16,
        28,
        40,
        54,
        64,
        76,
        89,
        100,
        110,
        124,
        136,
        147,
        158,
        167,
        179
      ],
      "page_408": [
        15,
        30,
        43,
        57,
        72,
        86,
        100,
        112,
        124,
        139,
        147,
        162,
        174,
        186,
        197
      ],
      "page_409": [
        12,
        24,
        37,
        52,
        66,
        79,
        98,
        114,
        128,
        139,
        152,
        167,
        181,
        193,
        204
      ],
      "page_410": [
        16,
        29,
        42,
        54,
        66,
        77,
        86,
        95,
        108,
        121,
        131,
        144,
        159,
        169,
        182
      ],
      "page_411": [8, 18, 30, 39, 54, 65, 81, 93, 104, 117, 135, 148, 158],
      "page_412": [
        17,
        32,
        48,
        62,
        78,
        92,
        107,
        122,
        136,
        148,
        161,
        175,
        190,
        203,
        214
      ],
      "page_413": [
        17,
        31,
        48,
        66,
        75,
        88,
        103,
        120,
        129,
        144,
        157,
        170,
        182,
        193,
        205
      ],
      "page_414": [
        14,
        27,
        41,
        55,
        69,
        82,
        96,
        110,
        124,
        139,
        152,
        162,
        174,
        186
      ],
      "page_415": [
        10,
        23,
        35,
        47,
        62,
        74,
        87,
        95,
        107,
        122,
        134,
        149,
        161,
        172
      ],
      "page_416": [
        11,
        26,
        40,
        52,
        69,
        81,
        98,
        107,
        121,
        133,
        148,
        161,
        174,
        190,
        204
      ],
      "page_417": [
        11,
        25,
        38,
        52,
        66,
        80,
        92,
        106,
        119,
        133,
        148,
        157,
        170,
        180
      ],
      "page_418": [
        12,
        22,
        34,
        47,
        58,
        72,
        83,
        98,
        113,
        126,
        135,
        148,
        159,
        167
      ],
      "page_419": [
        16,
        29,
        41,
        55,
        70,
        84,
        94,
        105,
        116,
        130,
        145,
        160,
        174,
        192,
        203
      ],
      "page_420": [
        14,
        26,
        43,
        56,
        69,
        84,
        98,
        109,
        119,
        130,
        143,
        158,
        170,
        185,
        199
      ],
      "page_421": [
        15,
        30,
        41,
        53,
        65,
        78,
        89,
        99,
        115,
        128,
        140,
        153,
        164,
        175,
        185
      ],
      "page_422": [
        15,
        28,
        43,
        58,
        71,
        85,
        97,
        107,
        116,
        124,
        134,
        142,
        150,
        158,
        168
      ],
      "page_423": [
        17,
        34,
        49,
        64,
        79,
        94,
        108,
        123,
        135,
        149,
        162,
        174,
        186,
        197,
        209
      ],
      "page_424": [
        14,
        27,
        42,
        52,
        65,
        78,
        93,
        104,
        120,
        136,
        151,
        165,
        177,
        191,
        200
      ],
      "page_425": [
        15,
        30,
        45,
        58,
        73,
        85,
        96,
        109,
        123,
        134,
        149,
        160,
        175,
        185,
        199
      ],
      "page_426": [
        17,
        33,
        45,
        56,
        67,
        83,
        92,
        103,
        116,
        129,
        141,
        151,
        166,
        178,
        190
      ],
      "page_427": [
        16,
        26,
        39,
        52,
        69,
        81,
        95,
        111,
        123,
        140,
        151,
        170,
        180,
        189,
        198
      ],
      "page_428": [17, 30, 45, 56, 72, 84, 94, 106, 116, 128, 141, 153, 166],
      "page_429": [
        15,
        29,
        43,
        55,
        68,
        83,
        96,
        108,
        125,
        140,
        153,
        165,
        179,
        191,
        203
      ],
      "page_430": [
        14,
        28,
        45,
        56,
        69,
        84,
        97,
        115,
        130,
        145,
        157,
        171,
        184,
        195,
        212
      ],
      "page_431": [
        16,
        31,
        41,
        54,
        67,
        82,
        95,
        106,
        115,
        124,
        137,
        149,
        161,
        171,
        183
      ],
      "page_432": [
        13,
        26,
        38,
        53,
        66,
        79,
        93,
        106,
        120,
        135,
        149,
        161,
        170,
        186,
        200
      ],
      "page_433": [
        15,
        29,
        40,
        57,
        72,
        88,
        104,
        118,
        132,
        148,
        161,
        174,
        186,
        205,
        217
      ],
      "page_434": [14, 34, 49, 64, 76, 89, 104, 115, 129, 144, 159, 173, 186],
      "page_435": [
        16,
        29,
        45,
        56,
        72,
        91,
        106,
        117,
        134,
        148,
        160,
        171,
        184,
        201,
        215
      ],
      "page_436": [
        12,
        22,
        36,
        46,
        56,
        68,
        77,
        92,
        105,
        116,
        126,
        141,
        156,
        168,
        181
      ],
      "page_437": [
        12,
        24,
        37,
        49,
        64,
        77,
        90,
        102,
        115,
        125,
        136,
        147,
        161,
        174,
        186
      ],
      "page_438": [
        14,
        28,
        44,
        56,
        63,
        77,
        93,
        105,
        121,
        135,
        144,
        157,
        172,
        183,
        193
      ],
      "page_439": [
        17,
        30,
        43,
        58,
        73,
        82,
        99,
        116,
        129,
        140,
        154,
        169,
        182,
        200,
        211
      ],
      "page_440": [14, 25, 36, 46, 54, 68, 83, 95, 110, 125, 138, 151, 163],
      "page_441": [
        11,
        29,
        42,
        54,
        69,
        86,
        103,
        114,
        122,
        136,
        149,
        162,
        176,
        190,
        203
      ],
      "page_442": [
        16,
        28,
        42,
        53,
        67,
        82,
        94,
        108,
        120,
        132,
        146,
        157,
        168,
        179,
        190
      ],
      "page_443": [
        16,
        33,
        47,
        63,
        78,
        93,
        108,
        121,
        131,
        141,
        154,
        169,
        177,
        189,
        199
      ],
      "page_444": [
        11,
        21,
        34,
        45,
        57,
        69,
        79,
        91,
        105,
        119,
        133,
        144,
        156,
        174,
        184
      ],
      "page_445": [
        20,
        36,
        51,
        60,
        74,
        89,
        103,
        115,
        129,
        140,
        151,
        163,
        176,
        189
      ],
      "page_446": [
        10,
        24,
        36,
        47,
        59,
        73,
        89,
        99,
        116,
        131,
        146,
        158,
        170,
        183
      ],
      "page_504": [
        16,
        32,
        44,
        61,
        75,
        88,
        97,
        113,
        128,
        138,
        153,
        169,
        182,
        196,
        210
      ],
      "page_505": [
        14,
        32,
        48,
        62,
        76,
        89,
        103,
        118,
        132,
        149,
        162,
        177,
        191,
        202,
        214
      ],
      "page_506": [
        13,
        25,
        38,
        51,
        65,
        79,
        94,
        106,
        121,
        134,
        150,
        162,
        176,
        186
      ],
      "page_507": [
        12,
        27,
        43,
        57,
        72,
        89,
        106,
        122,
        138,
        151,
        167,
        180,
        195,
        209
      ],
      "page_508": [
        11,
        24,
        39,
        56,
        73,
        88,
        103,
        122,
        137,
        151,
        164,
        177,
        194,
        209,
        222
      ],
      "page_509": [
        11,
        23,
        36,
        48,
        62,
        73,
        85,
        96,
        109,
        121,
        133,
        142,
        153,
        163,
        174
      ],
      "page_510": [
        20,
        33,
        44,
        57,
        69,
        82,
        94,
        110,
        125,
        139,
        152,
        161,
        174,
        189,
        199
      ],
      "page_511": [18, 32, 44, 56, 68, 81, 92, 100, 113, 128, 141, 153, 165],
      "page_512": [
        13,
        31,
        43,
        57,
        73,
        90,
        101,
        115,
        132,
        144,
        156,
        164,
        175,
        187,
        199
      ],
      "page_513": [
        12,
        24,
        38,
        51,
        66,
        78,
        90,
        102,
        113,
        125,
        138,
        150,
        163,
        174,
        187
      ],
      "page_514": [17, 31, 41, 53, 68, 82, 91, 102, 113, 128, 140, 150, 162],
      "page_515": [13, 25, 39, 53, 66, 76, 92, 105, 119, 131, 141, 153, 162],
      "page_516": [
        17,
        31,
        43,
        60,
        77,
        85,
        97,
        109,
        123,
        135,
        147,
        160,
        175,
        189,
        200
      ],
      "page_517": [
        13,
        27,
        42,
        60,
        74,
        85,
        99,
        113,
        126,
        139,
        149,
        163,
        177,
        191,
        202
      ],
      "page_518": [12, 27, 41, 54, 70, 87, 102, 116, 126, 140, 155, 168, 182],
      "page_519": [
        19,
        31,
        43,
        57,
        70,
        87,
        101,
        112,
        127,
        141,
        157,
        170,
        182,
        194,
        209
      ],
      "page_520": [16, 28, 42, 56, 69, 81, 92, 102, 113, 126, 140, 149, 162],
      "page_521": [
        14,
        22,
        32,
        45,
        59,
        70,
        83,
        98,
        115,
        123,
        137,
        153,
        167,
        181,
        192
      ],
      "page_522": [
        14,
        26,
        41,
        56,
        69,
        87,
        105,
        118,
        134,
        146,
        159,
        174,
        187,
        202,
        217
      ],
      "page_523": [16, 32, 43, 56, 68, 82, 93, 103, 111, 124, 134, 143, 153],
      "page_524": [
        13,
        26,
        39,
        54,
        65,
        81,
        100,
        113,
        128,
        141,
        155,
        168,
        182,
        196,
        207
      ],
      "page_525": [
        15,
        29,
        41,
        51,
        66,
        79,
        94,
        104,
        119,
        130,
        144,
        158,
        176,
        191
      ],
      "page_526": [
        14,
        25,
        38,
        51,
        68,
        77,
        91,
        105,
        118,
        132,
        145,
        162,
        173,
        187
      ],
      "page_527": [
        11,
        29,
        44,
        59,
        75,
        91,
        101,
        115,
        130,
        143,
        158,
        169,
        182,
        194,
        208
      ],
      "page_528": [14, 30, 42, 57, 70, 81, 92, 106, 116, 128, 139, 149, 159],
      "page_529": [
        10,
        19,
        36,
        51,
        63,
        80,
        95,
        111,
        127,
        138,
        153,
        168,
        186,
        198,
        211
      ],
      "page_530": [
        16,
        33,
        47,
        62,
        77,
        92,
        111,
        123,
        142,
        160,
        173,
        183,
        195,
        205,
        221
      ],
      "page_531": [15, 27, 37, 47, 52, 62, 73, 85, 96, 107, 117, 125, 136],
      "page_532": [
        12,
        24,
        36,
        49,
        63,
        77,
        92,
        105,
        117,
        130,
        143,
        157,
        167,
        182,
        193
      ],
      "page_533": [
        14,
        25,
        39,
        54,
        66,
        79,
        90,
        104,
        115,
        128,
        139,
        149,
        161,
        171,
        180
      ],
      "page_534": [14, 26, 36, 52, 62, 74, 84, 92, 103, 112, 118, 128, 135],
      "page_535": [
        13,
        25,
        37,
        51,
        61,
        71,
        81,
        95,
        103,
        113,
        124,
        138,
        153,
        167,
        176
      ],
      "page_536": [
        12,
        25,
        38,
        51,
        63,
        78,
        91,
        104,
        116,
        130,
        142,
        156,
        167,
        177,
        188
      ],
      "page_537": [12, 22, 33, 44, 59, 71, 84, 97, 106, 119, 134, 146, 160],
      "page_538": [
        11,
        27,
        46,
        58,
        72,
        87,
        103,
        122,
        135,
        149,
        167,
        179,
        193,
        206,
        221
      ],
      "page_539": [
        15,
        28,
        38,
        55,
        75,
        90,
        105,
        121,
        133,
        146,
        160,
        174,
        189,
        198,
        209
      ],
      "page_540": [
        14,
        31,
        42,
        56,
        70,
        81,
        92,
        106,
        120,
        132,
        144,
        156,
        170,
        179,
        191
      ],
      "page_541": [
        14,
        27,
        43,
        57,
        70,
        81,
        96,
        110,
        125,
        140,
        154,
        170,
        185,
        196,
        209
      ],
      "page_542": [14, 25, 39, 53, 65, 79, 94, 106, 119, 133, 149, 161, 175],
      "page_543": [
        15,
        29,
        48,
        65,
        81,
        98,
        116,
        129,
        145,
        160,
        173,
        188,
        202,
        218,
        232
      ],
      "page_544": [
        17,
        34,
        50,
        67,
        84,
        100,
        115,
        130,
        144,
        155,
        173,
        185,
        195,
        205,
        217
      ],
      "page_545": [11, 25, 36, 49, 63, 74, 88, 100, 116, 131, 144, 157, 170],
      "page_546": [
        18,
        29,
        44,
        60,
        74,
        90,
        104,
        119,
        132,
        144,
        157,
        169,
        181,
        196,
        206
      ],
      "page_547": [
        13,
        28,
        43,
        55,
        69,
        85,
        101,
        112,
        126,
        135,
        147,
        159,
        175,
        187,
        199
      ],
      "page_548": [
        14,
        26,
        40,
        55,
        63,
        72,
        82,
        93,
        104,
        114,
        120,
        126,
        135,
        147
      ],
      "page_549": [
        14,
        30,
        49,
        65,
        81,
        96,
        111,
        123,
        140,
        159,
        173,
        191,
        211,
        227
      ],
      "page_550": [
        17,
        30,
        47,
        62,
        76,
        90,
        108,
        119,
        133,
        153,
        169,
        185,
        200,
        213,
        226
      ],
      "page_551": [14, 31, 45, 59, 71, 82, 96, 108, 118, 128, 141, 154, 166],
      "page_552": [
        16,
        36,
        51,
        65,
        81,
        95,
        112,
        127,
        144,
        160,
        172,
        188,
        202,
        213,
        229
      ],
      "page_553": [13, 23, 40, 55, 68, 78, 89, 101, 116, 131, 144, 156, 169],
      "page_554": [13, 30, 40, 54, 70, 83, 98, 110, 127, 142, 154, 167, 180],
      "page_555": [
        14,
        24,
        38,
        46,
        58,
        67,
        77,
        93,
        104,
        116,
        127,
        140,
        151,
        164
      ],
      "page_556": [
        17,
        31,
        43,
        58,
        73,
        86,
        103,
        119,
        135,
        153,
        168,
        183,
        197,
        205
      ],
      "page_557": [
        10,
        20,
        37,
        47,
        60,
        72,
        82,
        94,
        106,
        119,
        131,
        141,
        155,
        162
      ],
      "page_558": [
        16,
        28,
        40,
        54,
        67,
        80,
        92,
        108,
        123,
        136,
        149,
        162,
        178,
        194
      ],
      "page_559": [
        15,
        30,
        48,
        63,
        82,
        96,
        114,
        127,
        141,
        154,
        165,
        180,
        194,
        208,
        222
      ],
      "page_560": [18, 32, 45, 63, 79, 93, 106, 119, 128, 142, 153, 166, 178],
      "page_561": [
        13,
        24,
        36,
        51,
        66,
        78,
        88,
        98,
        111,
        120,
        130,
        145,
        157,
        170,
        183
      ],
      "page_562": [14, 28, 39, 51, 65, 81, 95, 110, 126, 146, 164, 176, 189],
      "page_563": [
        18,
        30,
        48,
        62,
        74,
        89,
        105,
        119,
        133,
        148,
        163,
        176,
        188,
        202,
        215
      ],
      "page_564": [15, 32, 44, 62, 78, 92, 107, 120, 135, 146, 156, 167, 176],
      "page_565": [
        19,
        35,
        47,
        62,
        79,
        97,
        113,
        129,
        149,
        163,
        175,
        193,
        209,
        227,
        238
      ],
      "page_566": [16, 31, 47, 59, 75, 94, 111, 128, 139, 153, 165, 177, 189],
      "page_567": [
        15,
        32,
        48,
        60,
        71,
        85,
        96,
        114,
        124,
        139,
        159,
        172,
        190,
        206,
        218
      ],
      "page_568": [17, 29, 44, 58, 74, 91, 108, 122, 134, 144, 155, 169, 179],
      "page_569": [
        12,
        28,
        40,
        52,
        64,
        74,
        85,
        98,
        111,
        127,
        142,
        156,
        169,
        181,
        194
      ],
      "page_570": [18, 34, 45, 57, 74, 88, 106, 120, 138, 154, 169, 186, 200],
      "page_571": [
        14,
        30,
        43,
        54,
        69,
        81,
        98,
        113,
        131,
        144,
        161,
        173,
        187,
        202,
        214
      ],
      "page_572": [17, 33, 50, 65, 80, 99, 113, 129, 144, 161, 178, 193, 210],
      "page_573": [
        15,
        26,
        42,
        57,
        73,
        90,
        107,
        122,
        140,
        153,
        164,
        177,
        190,
        206,
        220
      ],
      "page_574": [15, 30, 44, 57, 71, 84, 96, 108, 121, 134, 148, 158, 169],
      "page_575": [19, 36, 52, 63, 81, 98, 113, 130, 144, 156, 169, 180, 194],
      "page_576": [
        15,
        29,
        43,
        57,
        73,
        89,
        106,
        122,
        140,
        154,
        168,
        179,
        191,
        202,
        214
      ],
      "page_577": [13, 22, 34, 44, 57, 70, 84, 98, 109, 121, 136, 153, 171],
      "page_578": [10, 24, 39, 53, 67, 81, 99, 112, 123, 137, 148, 159, 167],
      "page_579": [
        14,
        26,
        44,
        58,
        75,
        89,
        106,
        118,
        132,
        147,
        162,
        178,
        191,
        207,
        220
      ],
      "page_580": [13, 23, 40, 52, 65, 79, 88, 99, 110, 122, 134, 144, 153],
      "page_581": [
        16,
        27,
        41,
        52,
        67,
        80,
        90,
        103,
        116,
        130,
        144,
        157,
        170,
        182,
        192
      ],
      "page_582": [11, 23, 37, 50, 62, 75, 85, 96, 106, 119, 129, 142, 155],
      "page_583": [12, 26, 38, 49, 63, 77, 92, 101, 110, 119, 132, 144, 155],
      "page_584": [
        15,
        34,
        45,
        61,
        77,
        91,
        105,
        120,
        129,
        143,
        157,
        169,
        183,
        199
      ],
      "page_585": [
        15,
        28,
        46,
        61,
        70,
        86,
        102,
        119,
        134,
        148,
        162,
        182,
        192,
        204
      ],
      "page_586": [10, 19, 29, 39, 50, 60, 70, 83, 99, 113, 128, 138],
      "page_587": [10, 19, 33, 48, 60, 71, 86, 100, 113, 122, 136, 146],
      "page_588": [
        14,
        25,
        42,
        55,
        70,
        84,
        95,
        105,
        113,
        125,
        134,
        145,
        154,
        168,
        176
      ],
      "page_589": [9, 23, 40, 55, 67, 82, 94, 111, 122, 136, 145, 157, 168],
      "page_590": [11, 21, 33, 46, 57, 72, 82, 93, 107, 119, 130, 140],
      "page_591": [14, 29, 43, 59, 75, 86, 100, 112, 129, 140, 151, 167],
      "page_592": [10, 19, 28, 37, 51, 62, 75, 84, 96, 106, 116, 128, 140],
      "page_593": [13, 29, 39, 51, 64, 78, 97, 115, 125, 131, 141, 154, 165],
      "page_594": [17, 28, 42, 58, 72, 85, 99, 110, 121, 132, 143, 154],
      "page_595": [15, 32, 47, 59, 72, 87, 102, 116, 131, 147, 165, 181],
      "page_596": [13, 26, 38, 52, 67, 80, 94, 108, 123, 139, 154],
      "page_597": [11, 25, 39, 52, 67, 79, 94, 108, 127, 141, 152],
      "page_598": [15, 25, 39, 49, 59, 71, 84, 97, 106, 117, 126],
      "page_599": [13, 31, 41, 52, 64, 74, 84, 93, 107, 124, 136],
      "page_600": [14, 23, 29, 37, 46, 56, 64, 73, 81, 90, 98],
      "page_601": [10, 21, 32, 43, 54, 64, 79, 89, 99],
      "page_602": [9, 19, 26, 36, 44, 54, 60, 73, 78],
      "page_603": [8, 21, 35, 45, 56, 63, 77, 86, 94],
      "page_604": [8, 18, 29, 38, 45, 53, 59, 63, 67]
    };
    String jsonString = json.encode(jsonData);
    _index = BreakIndex.fromJson(json.decode(jsonString));
    if (page < 100) {
      if (page == 1) {
        breakIndex = _index?.page1 ?? <int>[];
      } else if (page == 2) {
        breakIndex = _index?.page2 ?? <int>[];
      } else if (page == 3) {
        breakIndex = _index?.page3 ?? <int>[];
      } else if (page == 4) {
        breakIndex = _index?.page4 ?? <int>[];
      } else if (page == 5) {
        breakIndex = _index?.page5 ?? <int>[];
      } else if (page == 6) {
        breakIndex = _index?.page6 ?? <int>[];
      } else if (page == 7) {
        breakIndex = _index?.page7 ?? <int>[];
      } else if (page == 8) {
        breakIndex = _index?.page8 ?? <int>[];
      } else if (page == 9) {
        breakIndex = _index?.page9 ?? <int>[];
      } else if (page == 10) {
        breakIndex = _index?.page10 ?? <int>[];
      } else if (page == 11) {
        breakIndex = _index?.page11 ?? <int>[];
      } else if (page == 12) {
        breakIndex = _index?.page12 ?? <int>[];
      } else if (page == 13) {
        breakIndex = _index?.page13 ?? <int>[];
      } else if (page == 14) {
        breakIndex = _index?.page14 ?? <int>[];
      } else if (page == 15) {
        breakIndex = _index?.page15 ?? <int>[];
      } else if (page == 16) {
        breakIndex = _index?.page16 ?? <int>[];
      } else if (page == 17) {
        breakIndex = _index?.page17 ?? <int>[];
      } else if (page == 18) {
        breakIndex = _index?.page18 ?? <int>[];
      } else if (page == 19) {
        breakIndex = _index?.page19 ?? <int>[];
      } else if (page == 20) {
        breakIndex = _index?.page20 ?? <int>[];
      } else if (page == 21) {
        breakIndex = _index?.page21 ?? <int>[];
      } else if (page == 22) {
        breakIndex = _index?.page22 ?? <int>[];
      } else if (page == 23) {
        breakIndex = _index?.page23 ?? <int>[];
      } else if (page == 24) {
        breakIndex = _index?.page24 ?? <int>[];
      } else if (page == 25) {
        breakIndex = _index?.page25 ?? <int>[];
      } else if (page == 26) {
        breakIndex = _index?.page26 ?? <int>[];
      } else if (page == 27) {
        breakIndex = _index?.page27 ?? <int>[];
      } else if (page == 28) {
        breakIndex = _index?.page28 ?? <int>[];
      } else if (page == 29) {
        breakIndex = _index?.page29 ?? <int>[];
      } else if (page == 30) {
        breakIndex = _index?.page30 ?? <int>[];
      } else if (page == 31) {
        breakIndex = _index?.page31 ?? <int>[];
      } else if (page == 32) {
        breakIndex = _index?.page32 ?? <int>[];
      } else if (page == 33) {
        breakIndex = _index?.page33 ?? <int>[];
      } else if (page == 34) {
        breakIndex = _index?.page34 ?? <int>[];
      } else if (page == 35) {
        breakIndex = _index?.page35 ?? <int>[];
      } else if (page == 36) {
        breakIndex = _index?.page36 ?? <int>[];
      } else if (page == 37) {
        breakIndex = _index?.page37 ?? <int>[];
      } else if (page == 38) {
        breakIndex = _index?.page38 ?? <int>[];
      } else if (page == 39) {
        breakIndex = _index?.page39 ?? <int>[];
      } else if (page == 40) {
        breakIndex = _index?.page40 ?? <int>[];
      } else if (page == 41) {
        breakIndex = _index?.page41 ?? <int>[];
      } else if (page == 42) {
        breakIndex = _index?.page42 ?? <int>[];
      } else if (page == 43) {
        breakIndex = _index?.page43 ?? <int>[];
      } else if (page == 44) {
        breakIndex = _index?.page44 ?? <int>[];
      } else if (page == 45) {
        breakIndex = _index?.page45 ?? <int>[];
      } else if (page == 46) {
        breakIndex = _index?.page46 ?? <int>[];
      } else if (page == 47) {
        breakIndex = _index?.page47 ?? <int>[];
      } else if (page == 48) {
        breakIndex = _index?.page48 ?? <int>[];
      } else if (page == 49) {
        breakIndex = _index?.page49 ?? <int>[];
      } else if (page == 50) {
        breakIndex = _index?.page50 ?? <int>[];
      } else if (page == 51) {
        breakIndex = _index?.page51 ?? <int>[];
      } else if (page == 52) {
        breakIndex = _index?.page52 ?? <int>[];
      } else if (page == 53) {
        breakIndex = _index?.page53 ?? <int>[];
      } else if (page == 54) {
        breakIndex = _index?.page54 ?? <int>[];
      } else if (page == 55) {
        breakIndex = _index?.page55 ?? <int>[];
      } else if (page == 56) {
        breakIndex = _index?.page56 ?? <int>[];
      } else if (page == 57) {
        breakIndex = _index?.page57 ?? <int>[];
      } else if (page == 58) {
        breakIndex = _index?.page58 ?? <int>[];
      } else if (page == 59) {
        breakIndex = _index?.page59 ?? <int>[];
      } else if (page == 60) {
        breakIndex = _index?.page60 ?? <int>[];
      } else if (page == 61) {
        breakIndex = _index?.page61 ?? <int>[];
      } else if (page == 62) {
        breakIndex = _index?.page62 ?? <int>[];
      } else if (page == 63) {
        breakIndex = _index?.page63 ?? <int>[];
      } else if (page == 64) {
        breakIndex = _index?.page64 ?? <int>[];
      } else if (page == 65) {
        breakIndex = _index?.page65 ?? <int>[];
      } else if (page == 66) {
        breakIndex = _index?.page66 ?? <int>[];
      } else if (page == 67) {
        breakIndex = _index?.page67 ?? <int>[];
      } else if (page == 68) {
        breakIndex = _index?.page68 ?? <int>[];
      } else if (page == 69) {
        breakIndex = _index?.page69 ?? <int>[];
      } else if (page == 70) {
        breakIndex = _index?.page70 ?? <int>[];
      } else if (page == 71) {
        breakIndex = _index?.page71 ?? <int>[];
      } else if (page == 72) {
        breakIndex = _index?.page72 ?? <int>[];
      } else if (page == 73) {
        breakIndex = _index?.page73 ?? <int>[];
      } else if (page == 74) {
        breakIndex = _index?.page74 ?? <int>[];
      } else if (page == 75) {
        breakIndex = _index?.page75 ?? <int>[];
      } else if (page == 76) {
        breakIndex = _index?.page76 ?? <int>[];
      } else if (page == 77) {
        breakIndex = _index?.page77 ?? <int>[];
      } else if (page == 78) {
        breakIndex = _index?.page78 ?? <int>[];
      } else if (page == 79) {
        breakIndex = _index?.page79 ?? <int>[];
      } else if (page == 80) {
        breakIndex = _index?.page80 ?? <int>[];
      } else if (page == 81) {
        breakIndex = _index?.page81 ?? <int>[];
      } else if (page == 82) {
        breakIndex = _index?.page82 ?? <int>[];
      } else if (page == 83) {
        breakIndex = _index?.page83 ?? <int>[];
      } else if (page == 84) {
        breakIndex = _index?.page84 ?? <int>[];
      } else if (page == 85) {
        breakIndex = _index?.page85 ?? <int>[];
      } else if (page == 86) {
        breakIndex = _index?.page86 ?? <int>[];
      } else if (page == 87) {
        breakIndex = _index?.page87 ?? <int>[];
      } else if (page == 88) {
        breakIndex = _index?.page88 ?? <int>[];
      } else if (page == 89) {
        breakIndex = _index?.page89 ?? <int>[];
      } else if (page == 90) {
        breakIndex = _index?.page90 ?? <int>[];
      } else if (page == 91) {
        breakIndex = _index?.page91 ?? <int>[];
      } else if (page == 92) {
        breakIndex = _index?.page92 ?? <int>[];
      } else if (page == 93) {
        breakIndex = _index?.page93 ?? <int>[];
      } else if (page == 94) {
        breakIndex = _index?.page94 ?? <int>[];
      } else if (page == 95) {
        breakIndex = _index?.page95 ?? <int>[];
      } else if (page == 96) {
        breakIndex = _index?.page96 ?? <int>[];
      } else if (page == 97) {
        breakIndex = _index?.page97 ?? <int>[];
      } else if (page == 98) {
        breakIndex = _index?.page98 ?? <int>[];
      } else if (page == 99) {
        breakIndex = _index?.page99 ?? <int>[];
      }
    } else if (page < 200) {
      if (page == 100) {
        breakIndex = _index?.page100 ?? <int>[];
      } else if (page == 101) {
        breakIndex = _index?.page101 ?? <int>[];
      } else if (page == 102) {
        breakIndex = _index?.page102 ?? <int>[];
      } else if (page == 103) {
        breakIndex = _index?.page103 ?? <int>[];
      } else if (page == 104) {
        breakIndex = _index?.page104 ?? <int>[];
      } else if (page == 105) {
        breakIndex = _index?.page105 ?? <int>[];
      } else if (page == 106) {
        breakIndex = _index?.page106 ?? <int>[];
      } else if (page == 107) {
        breakIndex = _index?.page107 ?? <int>[];
      } else if (page == 108) {
        breakIndex = _index?.page108 ?? <int>[];
      } else if (page == 109) {
        breakIndex = _index?.page109 ?? <int>[];
      } else if (page == 110) {
        breakIndex = _index?.page110 ?? <int>[];
      } else if (page == 111) {
        breakIndex = _index?.page111 ?? <int>[];
      } else if (page == 112) {
        breakIndex = _index?.page112 ?? <int>[];
      } else if (page == 113) {
        breakIndex = _index?.page113 ?? <int>[];
      } else if (page == 114) {
        breakIndex = _index?.page114 ?? <int>[];
      } else if (page == 115) {
        breakIndex = _index?.page115 ?? <int>[];
      } else if (page == 116) {
        breakIndex = _index?.page116 ?? <int>[];
      } else if (page == 117) {
        breakIndex = _index?.page117 ?? <int>[];
      } else if (page == 118) {
        breakIndex = _index?.page118 ?? <int>[];
      } else if (page == 119) {
        breakIndex = _index?.page119 ?? <int>[];
      } else if (page == 120) {
        breakIndex = _index?.page120 ?? <int>[];
      } else if (page == 121) {
        breakIndex = _index?.page121 ?? <int>[];
      } else if (page == 122) {
        breakIndex = _index?.page122 ?? <int>[];
      } else if (page == 123) {
        breakIndex = _index?.page123 ?? <int>[];
      } else if (page == 124) {
        breakIndex = _index?.page124 ?? <int>[];
      } else if (page == 125) {
        breakIndex = _index?.page125 ?? <int>[];
      } else if (page == 126) {
        breakIndex = _index?.page126 ?? <int>[];
      } else if (page == 127) {
        breakIndex = _index?.page127 ?? <int>[];
      } else if (page == 128) {
        breakIndex = _index?.page128 ?? <int>[];
      } else if (page == 129) {
        breakIndex = _index?.page129 ?? <int>[];
      } else if (page == 130) {
        breakIndex = _index?.page130 ?? <int>[];
      } else if (page == 131) {
        breakIndex = _index?.page131 ?? <int>[];
      } else if (page == 132) {
        breakIndex = _index?.page132 ?? <int>[];
      } else if (page == 133) {
        breakIndex = _index?.page133 ?? <int>[];
      } else if (page == 134) {
        breakIndex = _index?.page134 ?? <int>[];
      } else if (page == 135) {
        breakIndex = _index?.page135 ?? <int>[];
      } else if (page == 136) {
        breakIndex = _index?.page136 ?? <int>[];
      } else if (page == 137) {
        breakIndex = _index?.page137 ?? <int>[];
      } else if (page == 138) {
        breakIndex = _index?.page138 ?? <int>[];
      } else if (page == 139) {
        breakIndex = _index?.page139 ?? <int>[];
      } else if (page == 140) {
        breakIndex = _index?.page140 ?? <int>[];
      } else if (page == 141) {
        breakIndex = _index?.page141 ?? <int>[];
      } else if (page == 142) {
        breakIndex = _index?.page142 ?? <int>[];
      } else if (page == 143) {
        breakIndex = _index?.page143 ?? <int>[];
      } else if (page == 144) {
        breakIndex = _index?.page144 ?? <int>[];
      } else if (page == 145) {
        breakIndex = _index?.page145 ?? <int>[];
      } else if (page == 146) {
        breakIndex = _index?.page146 ?? <int>[];
      } else if (page == 147) {
        breakIndex = _index?.page147 ?? <int>[];
      } else if (page == 148) {
        breakIndex = _index?.page148 ?? <int>[];
      } else if (page == 149) {
        breakIndex = _index?.page149 ?? <int>[];
      } else if (page == 150) {
        breakIndex = _index?.page150 ?? <int>[];
      } else if (page == 151) {
        breakIndex = _index?.page151 ?? <int>[];
      } else if (page == 152) {
        breakIndex = _index?.page152 ?? <int>[];
      } else if (page == 153) {
        breakIndex = _index?.page153 ?? <int>[];
      } else if (page == 154) {
        breakIndex = _index?.page154 ?? <int>[];
      } else if (page == 155) {
        breakIndex = _index?.page155 ?? <int>[];
      } else if (page == 156) {
        breakIndex = _index?.page156 ?? <int>[];
      } else if (page == 157) {
        breakIndex = _index?.page157 ?? <int>[];
      } else if (page == 158) {
        breakIndex = _index?.page158 ?? <int>[];
      } else if (page == 159) {
        breakIndex = _index?.page159 ?? <int>[];
      } else if (page == 160) {
        breakIndex = _index?.page160 ?? <int>[];
      } else if (page == 161) {
        breakIndex = _index?.page161 ?? <int>[];
      } else if (page == 162) {
        breakIndex = _index?.page162 ?? <int>[];
      } else if (page == 163) {
        breakIndex = _index?.page163 ?? <int>[];
      } else if (page == 164) {
        breakIndex = _index?.page164 ?? <int>[];
      } else if (page == 165) {
        breakIndex = _index?.page165 ?? <int>[];
      } else if (page == 166) {
        breakIndex = _index?.page166 ?? <int>[];
      } else if (page == 167) {
        breakIndex = _index?.page167 ?? <int>[];
      } else if (page == 168) {
        breakIndex = _index?.page168 ?? <int>[];
      } else if (page == 169) {
        breakIndex = _index?.page169 ?? <int>[];
      } else if (page == 170) {
        breakIndex = _index?.page170 ?? <int>[];
      } else if (page == 171) {
        breakIndex = _index?.page171 ?? <int>[];
      } else if (page == 172) {
        breakIndex = _index?.page172 ?? <int>[];
      } else if (page == 173) {
        breakIndex = _index?.page173 ?? <int>[];
      } else if (page == 174) {
        breakIndex = _index?.page174 ?? <int>[];
      } else if (page == 175) {
        breakIndex = _index?.page175 ?? <int>[];
      } else if (page == 176) {
        breakIndex = _index?.page176 ?? <int>[];
      } else if (page == 177) {
        breakIndex = _index?.page177 ?? <int>[];
      } else if (page == 178) {
        breakIndex = _index?.page178 ?? <int>[];
      } else if (page == 179) {
        breakIndex = _index?.page179 ?? <int>[];
      } else if (page == 180) {
        breakIndex = _index?.page180 ?? <int>[];
      } else if (page == 181) {
        breakIndex = _index?.page181 ?? <int>[];
      } else if (page == 182) {
        breakIndex = _index?.page182 ?? <int>[];
      } else if (page == 183) {
        breakIndex = _index?.page183 ?? <int>[];
      } else if (page == 184) {
        breakIndex = _index?.page184 ?? <int>[];
      } else if (page == 185) {
        breakIndex = _index?.page185 ?? <int>[];
      } else if (page == 186) {
        breakIndex = _index?.page186 ?? <int>[];
      } else if (page == 187) {
        breakIndex = _index?.page187 ?? <int>[];
      } else if (page == 188) {
        breakIndex = _index?.page188 ?? <int>[];
      } else if (page == 189) {
        breakIndex = _index?.page189 ?? <int>[];
      } else if (page == 190) {
        breakIndex = _index?.page190 ?? <int>[];
      } else if (page == 191) {
        breakIndex = _index?.page191 ?? <int>[];
      } else if (page == 192) {
        breakIndex = _index?.page192 ?? <int>[];
      } else if (page == 193) {
        breakIndex = _index?.page193 ?? <int>[];
      } else if (page == 194) {
        breakIndex = _index?.page194 ?? <int>[];
      } else if (page == 195) {
        breakIndex = _index?.page195 ?? <int>[];
      } else if (page == 196) {
        breakIndex = _index?.page196 ?? <int>[];
      } else if (page == 197) {
        breakIndex = _index?.page197 ?? <int>[];
      } else if (page == 198) {
        breakIndex = _index?.page198 ?? <int>[];
      } else if (page == 199) {
        breakIndex = _index?.page199 ?? <int>[];
      }
    } else if (page < 300) {
      if (page == 200) {
        breakIndex = _index?.page200 ?? <int>[];
      } else if (page == 201) {
        breakIndex = _index?.page201 ?? <int>[];
      } else if (page == 202) {
        breakIndex = _index?.page202 ?? <int>[];
      } else if (page == 203) {
        breakIndex = _index?.page203 ?? <int>[];
      } else if (page == 204) {
        breakIndex = _index?.page204 ?? <int>[];
      } else if (page == 205) {
        breakIndex = _index?.page205 ?? <int>[];
      } else if (page == 206) {
        breakIndex = _index?.page206 ?? <int>[];
      } else if (page == 207) {
        breakIndex = _index?.page207 ?? <int>[];
      } else if (page == 208) {
        breakIndex = _index?.page208 ?? <int>[];
      } else if (page == 209) {
        breakIndex = _index?.page209 ?? <int>[];
      } else if (page == 210) {
        breakIndex = _index?.page210 ?? <int>[];
      } else if (page == 211) {
        breakIndex = _index?.page211 ?? <int>[];
      } else if (page == 212) {
        breakIndex = _index?.page212 ?? <int>[];
      } else if (page == 213) {
        breakIndex = _index?.page213 ?? <int>[];
      } else if (page == 214) {
        breakIndex = _index?.page214 ?? <int>[];
      } else if (page == 215) {
        breakIndex = _index?.page215 ?? <int>[];
      } else if (page == 216) {
        breakIndex = _index?.page216 ?? <int>[];
      } else if (page == 217) {
        breakIndex = _index?.page217 ?? <int>[];
      } else if (page == 218) {
        breakIndex = _index?.page218 ?? <int>[];
      } else if (page == 219) {
        breakIndex = _index?.page219 ?? <int>[];
      } else if (page == 220) {
        breakIndex = _index?.page220 ?? <int>[];
      } else if (page == 221) {
        breakIndex = _index?.page221 ?? <int>[];
      } else if (page == 222) {
        breakIndex = _index?.page222 ?? <int>[];
      } else if (page == 223) {
        breakIndex = _index?.page223 ?? <int>[];
      } else if (page == 224) {
        breakIndex = _index?.page224 ?? <int>[];
      } else if (page == 225) {
        breakIndex = _index?.page225 ?? <int>[];
      } else if (page == 226) {
        breakIndex = _index?.page226 ?? <int>[];
      } else if (page == 227) {
        breakIndex = _index?.page227 ?? <int>[];
      } else if (page == 228) {
        breakIndex = _index?.page228 ?? <int>[];
      } else if (page == 229) {
        breakIndex = _index?.page229 ?? <int>[];
      } else if (page == 230) {
        breakIndex = _index?.page230 ?? <int>[];
      } else if (page == 231) {
        breakIndex = _index?.page231 ?? <int>[];
      } else if (page == 232) {
        breakIndex = _index?.page232 ?? <int>[];
      } else if (page == 233) {
        breakIndex = _index?.page233 ?? <int>[];
      } else if (page == 234) {
        breakIndex = _index?.page234 ?? <int>[];
      } else if (page == 235) {
        breakIndex = _index?.page235 ?? <int>[];
      } else if (page == 236) {
        breakIndex = _index?.page236 ?? <int>[];
      } else if (page == 237) {
        breakIndex = _index?.page237 ?? <int>[];
      } else if (page == 238) {
        breakIndex = _index?.page238 ?? <int>[];
      } else if (page == 239) {
        breakIndex = _index?.page239 ?? <int>[];
      } else if (page == 240) {
        breakIndex = _index?.page240 ?? <int>[];
      } else if (page == 241) {
        breakIndex = _index?.page241 ?? <int>[];
      } else if (page == 242) {
        breakIndex = _index?.page242 ?? <int>[];
      } else if (page == 243) {
        breakIndex = _index?.page243 ?? <int>[];
      } else if (page == 244) {
        breakIndex = _index?.page244 ?? <int>[];
      } else if (page == 245) {
        breakIndex = _index?.page245 ?? <int>[];
      } else if (page == 246) {
        breakIndex = _index?.page246 ?? <int>[];
      } else if (page == 247) {
        breakIndex = _index?.page247 ?? <int>[];
      } else if (page == 248) {
        breakIndex = _index?.page248 ?? <int>[];
      } else if (page == 249) {
        breakIndex = _index?.page249 ?? <int>[];
      } else if (page == 250) {
        breakIndex = _index?.page250 ?? <int>[];
      } else if (page == 251) {
        breakIndex = _index?.page251 ?? <int>[];
      } else if (page == 252) {
        breakIndex = _index?.page252 ?? <int>[];
      } else if (page == 253) {
        breakIndex = _index?.page253 ?? <int>[];
      } else if (page == 254) {
        breakIndex = _index?.page254 ?? <int>[];
      } else if (page == 255) {
        breakIndex = _index?.page255 ?? <int>[];
      } else if (page == 256) {
        breakIndex = _index?.page256 ?? <int>[];
      } else if (page == 257) {
        breakIndex = _index?.page257 ?? <int>[];
      } else if (page == 258) {
        breakIndex = _index?.page258 ?? <int>[];
      } else if (page == 259) {
        breakIndex = _index?.page259 ?? <int>[];
      } else if (page == 260) {
        breakIndex = _index?.page260 ?? <int>[];
      } else if (page == 261) {
        breakIndex = _index?.page261 ?? <int>[];
      } else if (page == 262) {
        breakIndex = _index?.page262 ?? <int>[];
      } else if (page == 263) {
        breakIndex = _index?.page263 ?? <int>[];
      } else if (page == 264) {
        breakIndex = _index?.page264 ?? <int>[];
      } else if (page == 265) {
        breakIndex = _index?.page265 ?? <int>[];
      } else if (page == 266) {
        breakIndex = _index?.page266 ?? <int>[];
      } else if (page == 267) {
        breakIndex = _index?.page267 ?? <int>[];
      } else if (page == 268) {
        breakIndex = _index?.page268 ?? <int>[];
      } else if (page == 269) {
        breakIndex = _index?.page269 ?? <int>[];
      } else if (page == 270) {
        breakIndex = _index?.page270 ?? <int>[];
      } else if (page == 271) {
        breakIndex = _index?.page271 ?? <int>[];
      } else if (page == 272) {
        breakIndex = _index?.page272 ?? <int>[];
      } else if (page == 273) {
        breakIndex = _index?.page273 ?? <int>[];
      } else if (page == 274) {
        breakIndex = _index?.page274 ?? <int>[];
      } else if (page == 275) {
        breakIndex = _index?.page275 ?? <int>[];
      } else if (page == 276) {
        breakIndex = _index?.page276 ?? <int>[];
      } else if (page == 277) {
        breakIndex = _index?.page277 ?? <int>[];
      } else if (page == 278) {
        breakIndex = _index?.page278 ?? <int>[];
      } else if (page == 279) {
        breakIndex = _index?.page279 ?? <int>[];
      } else if (page == 280) {
        breakIndex = _index?.page280 ?? <int>[];
      } else if (page == 281) {
        breakIndex = _index?.page281 ?? <int>[];
      } else if (page == 282) {
        breakIndex = _index?.page282 ?? <int>[];
      } else if (page == 283) {
        breakIndex = _index?.page283 ?? <int>[];
      } else if (page == 284) {
        breakIndex = _index?.page284 ?? <int>[];
      } else if (page == 285) {
        breakIndex = _index?.page285 ?? <int>[];
      } else if (page == 286) {
        breakIndex = _index?.page286 ?? <int>[];
      } else if (page == 287) {
        breakIndex = _index?.page287 ?? <int>[];
      } else if (page == 288) {
        breakIndex = _index?.page288 ?? <int>[];
      } else if (page == 289) {
        breakIndex = _index?.page289 ?? <int>[];
      } else if (page == 290) {
        breakIndex = _index?.page290 ?? <int>[];
      } else if (page == 291) {
        breakIndex = _index?.page291 ?? <int>[];
      } else if (page == 292) {
        breakIndex = _index?.page292 ?? <int>[];
      } else if (page == 293) {
        breakIndex = _index?.page293 ?? <int>[];
      } else if (page == 294) {
        breakIndex = _index?.page294 ?? <int>[];
      } else if (page == 295) {
        breakIndex = _index?.page295 ?? <int>[];
      } else if (page == 296) {
        breakIndex = _index?.page296 ?? <int>[];
      } else if (page == 297) {
        breakIndex = _index?.page297 ?? <int>[];
      } else if (page == 298) {
        breakIndex = _index?.page298 ?? <int>[];
      } else if (page == 299) {
        breakIndex = _index?.page299 ?? <int>[];
      }
    } else if (page < 400) {
      if (page == 300) {
        breakIndex = _index?.page300 ?? <int>[];
      } else if (page == 301) {
        breakIndex = _index?.page301 ?? <int>[];
      } else if (page == 302) {
        breakIndex = _index?.page302 ?? <int>[];
      } else if (page == 303) {
        breakIndex = _index?.page303 ?? <int>[];
      } else if (page == 304) {
        breakIndex = _index?.page304 ?? <int>[];
      } else if (page == 305) {
        breakIndex = _index?.page305 ?? <int>[];
      } else if (page == 306) {
        breakIndex = _index?.page306 ?? <int>[];
      } else if (page == 307) {
        breakIndex = _index?.page307 ?? <int>[];
      } else if (page == 308) {
        breakIndex = _index?.page308 ?? <int>[];
      } else if (page == 309) {
        breakIndex = _index?.page309 ?? <int>[];
      } else if (page == 310) {
        breakIndex = _index?.page310 ?? <int>[];
      } else if (page == 311) {
        breakIndex = _index?.page311 ?? <int>[];
      } else if (page == 312) {
        breakIndex = _index?.page312 ?? <int>[];
      } else if (page == 313) {
        breakIndex = _index?.page313 ?? <int>[];
      } else if (page == 314) {
        breakIndex = _index?.page314 ?? <int>[];
      } else if (page == 315) {
        breakIndex = _index?.page315 ?? <int>[];
      } else if (page == 316) {
        breakIndex = _index?.page316 ?? <int>[];
      } else if (page == 317) {
        breakIndex = _index?.page317 ?? <int>[];
      } else if (page == 318) {
        breakIndex = _index?.page318 ?? <int>[];
      } else if (page == 319) {
        breakIndex = _index?.page319 ?? <int>[];
      } else if (page == 320) {
        breakIndex = _index?.page320 ?? <int>[];
      } else if (page == 321) {
        breakIndex = _index?.page321 ?? <int>[];
      } else if (page == 322) {
        breakIndex = _index?.page322 ?? <int>[];
      } else if (page == 323) {
        breakIndex = _index?.page323 ?? <int>[];
      } else if (page == 324) {
        breakIndex = _index?.page324 ?? <int>[];
      } else if (page == 325) {
        breakIndex = _index?.page325 ?? <int>[];
      } else if (page == 326) {
        breakIndex = _index?.page326 ?? <int>[];
      } else if (page == 327) {
        breakIndex = _index?.page327 ?? <int>[];
      } else if (page == 328) {
        breakIndex = _index?.page328 ?? <int>[];
      } else if (page == 329) {
        breakIndex = _index?.page329 ?? <int>[];
      } else if (page == 330) {
        breakIndex = _index?.page330 ?? <int>[];
      } else if (page == 331) {
        breakIndex = _index?.page331 ?? <int>[];
      } else if (page == 332) {
        breakIndex = _index?.page332 ?? <int>[];
      } else if (page == 333) {
        breakIndex = _index?.page333 ?? <int>[];
      } else if (page == 334) {
        breakIndex = _index?.page334 ?? <int>[];
      } else if (page == 335) {
        breakIndex = _index?.page335 ?? <int>[];
      } else if (page == 336) {
        breakIndex = _index?.page336 ?? <int>[];
      } else if (page == 337) {
        breakIndex = _index?.page337 ?? <int>[];
      } else if (page == 338) {
        breakIndex = _index?.page338 ?? <int>[];
      } else if (page == 339) {
        breakIndex = _index?.page339 ?? <int>[];
      } else if (page == 340) {
        breakIndex = _index?.page340 ?? <int>[];
      } else if (page == 341) {
        breakIndex = _index?.page341 ?? <int>[];
      } else if (page == 342) {
        breakIndex = _index?.page342 ?? <int>[];
      } else if (page == 343) {
        breakIndex = _index?.page343 ?? <int>[];
      } else if (page == 344) {
        breakIndex = _index?.page344 ?? <int>[];
      } else if (page == 345) {
        breakIndex = _index?.page345 ?? <int>[];
      } else if (page == 346) {
        breakIndex = _index?.page346 ?? <int>[];
      } else if (page == 347) {
        breakIndex = _index?.page347 ?? <int>[];
      } else if (page == 348) {
        breakIndex = _index?.page348 ?? <int>[];
      } else if (page == 349) {
        breakIndex = _index?.page349 ?? <int>[];
      } else if (page == 350) {
        breakIndex = _index?.page350 ?? <int>[];
      } else if (page == 351) {
        breakIndex = _index?.page351 ?? <int>[];
      } else if (page == 352) {
        breakIndex = _index?.page352 ?? <int>[];
      } else if (page == 353) {
        breakIndex = _index?.page353 ?? <int>[];
      } else if (page == 354) {
        breakIndex = _index?.page354 ?? <int>[];
      } else if (page == 355) {
        breakIndex = _index?.page355 ?? <int>[];
      } else if (page == 356) {
        breakIndex = _index?.page356 ?? <int>[];
      } else if (page == 357) {
        breakIndex = _index?.page357 ?? <int>[];
      } else if (page == 358) {
        breakIndex = _index?.page358 ?? <int>[];
      } else if (page == 359) {
        breakIndex = _index?.page359 ?? <int>[];
      } else if (page == 360) {
        breakIndex = _index?.page360 ?? <int>[];
      } else if (page == 361) {
        breakIndex = _index?.page361 ?? <int>[];
      } else if (page == 362) {
        breakIndex = _index?.page362 ?? <int>[];
      } else if (page == 363) {
        breakIndex = _index?.page363 ?? <int>[];
      } else if (page == 364) {
        breakIndex = _index?.page364 ?? <int>[];
      } else if (page == 365) {
        breakIndex = _index?.page365 ?? <int>[];
      } else if (page == 366) {
        breakIndex = _index?.page366 ?? <int>[];
      } else if (page == 367) {
        breakIndex = _index?.page367 ?? <int>[];
      } else if (page == 368) {
        breakIndex = _index?.page368 ?? <int>[];
      } else if (page == 369) {
        breakIndex = _index?.page369 ?? <int>[];
      } else if (page == 370) {
        breakIndex = _index?.page370 ?? <int>[];
      } else if (page == 371) {
        breakIndex = _index?.page371 ?? <int>[];
      } else if (page == 372) {
        breakIndex = _index?.page372 ?? <int>[];
      } else if (page == 373) {
        breakIndex = _index?.page373 ?? <int>[];
      } else if (page == 374) {
        breakIndex = _index?.page374 ?? <int>[];
      } else if (page == 375) {
        breakIndex = _index?.page375 ?? <int>[];
      } else if (page == 376) {
        breakIndex = _index?.page376 ?? <int>[];
      } else if (page == 377) {
        breakIndex = _index?.page377 ?? <int>[];
      } else if (page == 378) {
        breakIndex = _index?.page378 ?? <int>[];
      } else if (page == 379) {
        breakIndex = _index?.page379 ?? <int>[];
      } else if (page == 380) {
        breakIndex = _index?.page380 ?? <int>[];
      } else if (page == 381) {
        breakIndex = _index?.page381 ?? <int>[];
      } else if (page == 382) {
        breakIndex = _index?.page382 ?? <int>[];
      } else if (page == 383) {
        breakIndex = _index?.page383 ?? <int>[];
      } else if (page == 384) {
        breakIndex = _index?.page384 ?? <int>[];
      } else if (page == 385) {
        breakIndex = _index?.page385 ?? <int>[];
      } else if (page == 386) {
        breakIndex = _index?.page386 ?? <int>[];
      } else if (page == 387) {
        breakIndex = _index?.page387 ?? <int>[];
      } else if (page == 388) {
        breakIndex = _index?.page388 ?? <int>[];
      } else if (page == 389) {
        breakIndex = _index?.page389 ?? <int>[];
      } else if (page == 390) {
        breakIndex = _index?.page390 ?? <int>[];
      } else if (page == 391) {
        breakIndex = _index?.page391 ?? <int>[];
      } else if (page == 392) {
        breakIndex = _index?.page392 ?? <int>[];
      } else if (page == 393) {
        breakIndex = _index?.page393 ?? <int>[];
      } else if (page == 394) {
        breakIndex = _index?.page394 ?? <int>[];
      } else if (page == 395) {
        breakIndex = _index?.page395 ?? <int>[];
      } else if (page == 396) {
        breakIndex = _index?.page396 ?? <int>[];
      } else if (page == 397) {
        breakIndex = _index?.page397 ?? <int>[];
      } else if (page == 398) {
        breakIndex = _index?.page398 ?? <int>[];
      } else if (page == 399) {
        breakIndex = _index?.page399 ?? <int>[];
      }
    } else if (page < 500) {
      if (page == 400) {
        breakIndex = _index?.page400 ?? <int>[];
      } else if (page == 401) {
        breakIndex = _index?.page401 ?? <int>[];
      } else if (page == 402) {
        breakIndex = _index?.page402 ?? <int>[];
      } else if (page == 403) {
        breakIndex = _index?.page403 ?? <int>[];
      } else if (page == 404) {
        breakIndex = _index?.page404 ?? <int>[];
      } else if (page == 405) {
        breakIndex = _index?.page405 ?? <int>[];
      } else if (page == 406) {
        breakIndex = _index?.page406 ?? <int>[];
      } else if (page == 407) {
        breakIndex = _index?.page407 ?? <int>[];
      } else if (page == 408) {
        breakIndex = _index?.page408 ?? <int>[];
      } else if (page == 409) {
        breakIndex = _index?.page409 ?? <int>[];
      } else if (page == 410) {
        breakIndex = _index?.page410 ?? <int>[];
      } else if (page == 411) {
        breakIndex = _index?.page411 ?? <int>[];
      } else if (page == 412) {
        breakIndex = _index?.page412 ?? <int>[];
      } else if (page == 413) {
        breakIndex = _index?.page413 ?? <int>[];
      } else if (page == 414) {
        breakIndex = _index?.page414 ?? <int>[];
      } else if (page == 415) {
        breakIndex = _index?.page415 ?? <int>[];
      } else if (page == 416) {
        breakIndex = _index?.page416 ?? <int>[];
      } else if (page == 417) {
        breakIndex = _index?.page417 ?? <int>[];
      } else if (page == 418) {
        breakIndex = _index?.page418 ?? <int>[];
      } else if (page == 419) {
        breakIndex = _index?.page419 ?? <int>[];
      } else if (page == 420) {
        breakIndex = _index?.page420 ?? <int>[];
      } else if (page == 421) {
        breakIndex = _index?.page421 ?? <int>[];
      } else if (page == 422) {
        breakIndex = _index?.page422 ?? <int>[];
      } else if (page == 423) {
        breakIndex = _index?.page423 ?? <int>[];
      } else if (page == 424) {
        breakIndex = _index?.page424 ?? <int>[];
      } else if (page == 425) {
        breakIndex = _index?.page425 ?? <int>[];
      } else if (page == 426) {
        breakIndex = _index?.page426 ?? <int>[];
      } else if (page == 427) {
        breakIndex = _index?.page427 ?? <int>[];
      } else if (page == 428) {
        breakIndex = _index?.page428 ?? <int>[];
      } else if (page == 429) {
        breakIndex = _index?.page429 ?? <int>[];
      } else if (page == 430) {
        breakIndex = _index?.page430 ?? <int>[];
      } else if (page == 431) {
        breakIndex = _index?.page431 ?? <int>[];
      } else if (page == 432) {
        breakIndex = _index?.page432 ?? <int>[];
      } else if (page == 433) {
        breakIndex = _index?.page433 ?? <int>[];
      } else if (page == 434) {
        breakIndex = _index?.page434 ?? <int>[];
      } else if (page == 435) {
        breakIndex = _index?.page435 ?? <int>[];
      } else if (page == 436) {
        breakIndex = _index?.page436 ?? <int>[];
      } else if (page == 437) {
        breakIndex = _index?.page437 ?? <int>[];
      } else if (page == 438) {
        breakIndex = _index?.page438 ?? <int>[];
      } else if (page == 439) {
        breakIndex = _index?.page439 ?? <int>[];
      } else if (page == 440) {
        breakIndex = _index?.page440 ?? <int>[];
      } else if (page == 441) {
        breakIndex = _index?.page441 ?? <int>[];
      } else if (page == 442) {
        breakIndex = _index?.page442 ?? <int>[];
      } else if (page == 443) {
        breakIndex = _index?.page443 ?? <int>[];
      } else if (page == 444) {
        breakIndex = _index?.page444 ?? <int>[];
      } else if (page == 445) {
        breakIndex = _index?.page445 ?? <int>[];
      } else if (page == 446) {
        breakIndex = _index?.page446 ?? <int>[];
      }
    } else if (page <= 604) {
      if (page == 504) {
        breakIndex = _index?.page504 ?? <int>[];
      } else if (page == 505) {
        breakIndex = _index?.page505 ?? <int>[];
      } else if (page == 506) {
        breakIndex = _index?.page506 ?? <int>[];
      } else if (page == 507) {
        breakIndex = _index?.page507 ?? <int>[];
      } else if (page == 508) {
        breakIndex = _index?.page508 ?? <int>[];
      } else if (page == 509) {
        breakIndex = _index?.page509 ?? <int>[];
      } else if (page == 510) {
        breakIndex = _index?.page510 ?? <int>[];
      } else if (page == 511) {
        breakIndex = _index?.page511 ?? <int>[];
      } else if (page == 512) {
        breakIndex = _index?.page512 ?? <int>[];
      } else if (page == 513) {
        breakIndex = _index?.page513 ?? <int>[];
      } else if (page == 514) {
        breakIndex = _index?.page514 ?? <int>[];
      } else if (page == 515) {
        breakIndex = _index?.page515 ?? <int>[];
      } else if (page == 516) {
        breakIndex = _index?.page516 ?? <int>[];
      } else if (page == 517) {
        breakIndex = _index?.page517 ?? <int>[];
      } else if (page == 518) {
        breakIndex = _index?.page518 ?? <int>[];
      } else if (page == 519) {
        breakIndex = _index?.page519 ?? <int>[];
      } else if (page == 520) {
        breakIndex = _index?.page520 ?? <int>[];
      } else if (page == 521) {
        breakIndex = _index?.page521 ?? <int>[];
      } else if (page == 522) {
        breakIndex = _index?.page522 ?? <int>[];
      } else if (page == 523) {
        breakIndex = _index?.page523 ?? <int>[];
      } else if (page == 524) {
        breakIndex = _index?.page524 ?? <int>[];
      } else if (page == 525) {
        breakIndex = _index?.page525 ?? <int>[];
      } else if (page == 526) {
        breakIndex = _index?.page526 ?? <int>[];
      } else if (page == 527) {
        breakIndex = _index?.page527 ?? <int>[];
      } else if (page == 528) {
        breakIndex = _index?.page528 ?? <int>[];
      } else if (page == 529) {
        breakIndex = _index?.page529 ?? <int>[];
      } else if (page == 530) {
        breakIndex = _index?.page530 ?? <int>[];
      } else if (page == 531) {
        breakIndex = _index?.page531 ?? <int>[];
      } else if (page == 532) {
        breakIndex = _index?.page532 ?? <int>[];
      } else if (page == 533) {
        breakIndex = _index?.page533 ?? <int>[];
      } else if (page == 534) {
        breakIndex = _index?.page534 ?? <int>[];
      } else if (page == 535) {
        breakIndex = _index?.page535 ?? <int>[];
      } else if (page == 536) {
        breakIndex = _index?.page536 ?? <int>[];
      } else if (page == 537) {
        breakIndex = _index?.page537 ?? <int>[];
      } else if (page == 538) {
        breakIndex = _index?.page538 ?? <int>[];
      } else if (page == 539) {
        breakIndex = _index?.page539 ?? <int>[];
      } else if (page == 540) {
        breakIndex = _index?.page540 ?? <int>[];
      } else if (page == 541) {
        breakIndex = _index?.page541 ?? <int>[];
      } else if (page == 542) {
        breakIndex = _index?.page542 ?? <int>[];
      } else if (page == 543) {
        breakIndex = _index?.page543 ?? <int>[];
      } else if (page == 544) {
        breakIndex = _index?.page544 ?? <int>[];
      } else if (page == 545) {
        breakIndex = _index?.page545 ?? <int>[];
      } else if (page == 546) {
        breakIndex = _index?.page546 ?? <int>[];
      } else if (page == 547) {
        breakIndex = _index?.page547 ?? <int>[];
      } else if (page == 548) {
        breakIndex = _index?.page548 ?? <int>[];
      } else if (page == 549) {
        breakIndex = _index?.page549 ?? <int>[];
      } else if (page == 550) {
        breakIndex = _index?.page550 ?? <int>[];
      } else if (page == 551) {
        breakIndex = _index?.page551 ?? <int>[];
      } else if (page == 552) {
        breakIndex = _index?.page552 ?? <int>[];
      } else if (page == 553) {
        breakIndex = _index?.page553 ?? <int>[];
      } else if (page == 554) {
        breakIndex = _index?.page554 ?? <int>[];
      } else if (page == 555) {
        breakIndex = _index?.page555 ?? <int>[];
      } else if (page == 556) {
        breakIndex = _index?.page556 ?? <int>[];
      } else if (page == 557) {
        breakIndex = _index?.page557 ?? <int>[];
      } else if (page == 558) {
        breakIndex = _index?.page558 ?? <int>[];
      } else if (page == 559) {
        breakIndex = _index?.page559 ?? <int>[];
      } else if (page == 560) {
        breakIndex = _index?.page560 ?? <int>[];
      } else if (page == 561) {
        breakIndex = _index?.page561 ?? <int>[];
      } else if (page == 562) {
        breakIndex = _index?.page562 ?? <int>[];
      } else if (page == 563) {
        breakIndex = _index?.page563 ?? <int>[];
      } else if (page == 564) {
        breakIndex = _index?.page564 ?? <int>[];
      } else if (page == 565) {
        breakIndex = _index?.page565 ?? <int>[];
      } else if (page == 566) {
        breakIndex = _index?.page566 ?? <int>[];
      } else if (page == 567) {
        breakIndex = _index?.page567 ?? <int>[];
      } else if (page == 568) {
        breakIndex = _index?.page568 ?? <int>[];
      } else if (page == 569) {
        breakIndex = _index?.page569 ?? <int>[];
      } else if (page == 570) {
        breakIndex = _index?.page570 ?? <int>[];
      } else if (page == 571) {
        breakIndex = _index?.page571 ?? <int>[];
      } else if (page == 572) {
        breakIndex = _index?.page572 ?? <int>[];
      } else if (page == 573) {
        breakIndex = _index?.page573 ?? <int>[];
      } else if (page == 574) {
        breakIndex = _index?.page574 ?? <int>[];
      } else if (page == 575) {
        breakIndex = _index?.page575 ?? <int>[];
      } else if (page == 576) {
        breakIndex = _index?.page576 ?? <int>[];
      } else if (page == 577) {
        breakIndex = _index?.page577 ?? <int>[];
      } else if (page == 578) {
        breakIndex = _index?.page578 ?? <int>[];
      } else if (page == 579) {
        breakIndex = _index?.page579 ?? <int>[];
      } else if (page == 580) {
        breakIndex = _index?.page580 ?? <int>[];
      } else if (page == 581) {
        breakIndex = _index?.page581 ?? <int>[];
      } else if (page == 582) {
        breakIndex = _index?.page582 ?? <int>[];
      } else if (page == 583) {
        breakIndex = _index?.page583 ?? <int>[];
      } else if (page == 584) {
        breakIndex = _index?.page584 ?? <int>[];
      } else if (page == 585) {
        breakIndex = _index?.page585 ?? <int>[];
      } else if (page == 586) {
        breakIndex = _index?.page586 ?? <int>[];
      } else if (page == 587) {
        breakIndex = _index?.page587 ?? <int>[];
      } else if (page == 588) {
        breakIndex = _index?.page588 ?? <int>[];
      } else if (page == 589) {
        breakIndex = _index?.page589 ?? <int>[];
      } else if (page == 590) {
        breakIndex = _index?.page590 ?? <int>[];
      } else if (page == 591) {
        breakIndex = _index?.page591 ?? <int>[];
      } else if (page == 592) {
        breakIndex = _index?.page592 ?? <int>[];
      } else if (page == 593) {
        breakIndex = _index?.page593 ?? <int>[];
      } else if (page == 594) {
        breakIndex = _index?.page594 ?? <int>[];
      } else if (page == 595) {
        breakIndex = _index?.page595 ?? <int>[];
      } else if (page == 596) {
        breakIndex = _index?.page596 ?? <int>[];
      } else if (page == 597) {
        breakIndex = _index?.page597 ?? <int>[];
      } else if (page == 598) {
        breakIndex = _index?.page598 ?? <int>[];
      } else if (page == 599) {
        breakIndex = _index?.page599 ?? <int>[];
      } else if (page == 600) {
        breakIndex = _index?.page600 ?? <int>[];
      } else if (page == 601) {
        breakIndex = _index?.page601 ?? <int>[];
      } else if (page == 602) {
        breakIndex = _index?.page602 ?? <int>[];
      } else if (page == 603) {
        breakIndex = _index?.page603 ?? <int>[];
      } else if (page == 604) {
        breakIndex = _index?.page604 ?? <int>[];
      }
    } else {
      breakIndex = <int>[];
      notifyListeners();
    }
  }

  void updateLoad() {
    loadingCategory = true;
  }

  void defaultSelect() {
    if (select.contains(true)) {
      select.clear();
      for (int i = 0; i < list!.join().split('').length; i++) {
        select.add(false);
      }
      notifyListeners();
      print('[set to default]');
    }
  }

  checkSurahStart(int page) {
    if (pageFix.contains(page)) {
      return start;
    } else {
      return 0;
    }
  }

  checkSurahEnd(int page) {
    if (pageFix.contains(page)) {
      return end;
    } else if (breakIndex!.isNotEmpty) {
      return breakIndex!.length;
    }
  }

  getStart(int id, int currentPage) async {
    sura_id = id;
    var jsonData = {
      "split_sura": [
        {"page": 106, "sura_id": 4, "start": 0, "end": 5, "numStart": 0},
        {"page": 106, "sura_id": 5, "start": 5, "end": 13, "numStart": 1},
        {"page": 221, "sura_id": 10, "start": 0, "end": 6, "numStart": 0},
        {"page": 221, "sura_id": 11, "start": 6, "end": 13, "numStart": 3},
        {"page": 235, "sura_id": 11, "start": 0, "end": 8, "numStart": 0},
        {"page": 235, "sura_id": 12, "start": 8, "end": 13, "numStart": 6},
        {"page": 255, "sura_id": 13, "start": 0, "end": 2, "numStart": 0},
        {"page": 255, "sura_id": 14, "start": 2, "end": 13, "numStart": 1},
        {"page": 267, "sura_id": 15, "start": 0, "end": 6, "numStart": 0},
        {"page": 267, "sura_id": 16, "start": 6, "end": 13, "numStart": 9},
        {"page": 293, "sura_id": 17, "start": 0, "end": 9, "numStart": 0},
        {"page": 293, "sura_id": 18, "start": 9, "end": 13, "numStart": 7},
        {"page": 312, "sura_id": 19, "start": 0, "end": 4, "numStart": 0},
        {"page": 312, "sura_id": 20, "start": 4, "end": 13, "numStart": 3},
        {"page": 359, "sura_id": 24, "start": 0, "end": 10, "numStart": 0},
        {"page": 359, "sura_id": 25, "start": 10, "end": 13, "numStart": 3},
        {"page": 385, "sura_id": 27, "start": 0, "end": 7, "numStart": 0},
        {"page": 385, "sura_id": 28, "start": 7, "end": 13, "numStart": 5},
        {"page": 396, "sura_id": 28, "start": 0, "end": 7, "numStart": 0},
        {"page": 396, "sura_id": 29, "start": 7, "end": 13, "numStart": 4},
        {"page": 404, "sura_id": 29, "start": 0, "end": 9, "numStart": 0},
        {"page": 404, "sura_id": 30, "start": 9, "end": 13, "numStart": 6},
        {"page": 434, "sura_id": 34, "start": 0, "end": 7, "numStart": 0},
        {"page": 434, "sura_id": 35, "start": 7, "end": 13, "numStart": 6},
        {"page": 440, "sura_id": 35, "start": 0, "end": 3, "numStart": 0},
        {"page": 440, "sura_id": 36, "start": 3, "end": 13, "numStart": 1},
        {"page": 564, "sura_id": 67, "start": 0, "end": 5, "numStart": 0},
        {"page": 564, "sura_id": 68, "start": 5, "end": 13, "numStart": 4},
        {"page": 566, "sura_id": 68, "start": 0, "end": 8, "numStart": 0},
        {"page": 566, "sura_id": 69, "start": 8, "end": 13, "numStart": 10},
        {"page": 568, "sura_id": 69, "start": 0, "end": 8, "numStart": 0},
        {"page": 568, "sura_id": 70, "start": 8, "end": 13, "numStart": 18},
        {"page": 570, "sura_id": 70, "start": 0, "end": 4, "numStart": 0},
        {"page": 570, "sura_id": 71, "start": 4, "end": 13, "numStart": 5},
        {"page": 575, "sura_id": 73, "start": 0, "end": 7, "numStart": 0},
        {"page": 575, "sura_id": 74, "start": 7, "end": 13, "numStart": 1},
        {"page": 577, "sura_id": 74, "start": 0, "end": 5, "numStart": 0},
        {"page": 577, "sura_id": 75, "start": 5, "end": 13, "numStart": 9},
        {"page": 578, "sura_id": 75, "start": 0, "end": 8, "numStart": 0},
        {"page": 578, "sura_id": 76, "start": 8, "end": 13, "numStart": 21},
        {"page": 580, "sura_id": 76, "start": 0, "end": 6, "numStart": 0},
        {"page": 580, "sura_id": 77, "start": 6, "end": 13, "numStart": 6},
        {"page": 583, "sura_id": 78, "start": 0, "end": 7, "numStart": 0},
        {"page": 583, "sura_id": 79, "start": 7, "end": 13, "numStart": 10},
        {"page": 587, "sura_id": 82, "start": 0, "end": 9, "numStart": 0},
        {"page": 587, "sura_id": 83, "start": 9, "end": 12, "numStart": 19},
        {"page": 589, "sura_id": 83, "start": 0, "end": 1, "numStart": 0},
        {"page": 589, "sura_id": 84, "start": 1, "end": 13, "numStart": 2},
        {"page": 591, "sura_id": 86, "start": 0, "end": 6, "numStart": 0},
        {"page": 591, "sura_id": 87, "start": 6, "end": 12, "numStart": 17},
        {"page": 592, "sura_id": 87, "start": 0, "end": 2, "numStart": 0},
        {"page": 592, "sura_id": 88, "start": 2, "end": 13, "numStart": 4},
        {"page": 594, "sura_id": 89, "start": 0, "end": 3, "numStart": 0},
        {"page": 594, "sura_id": 90, "start": 3, "end": 12, "numStart": 7},
        {"page": 595, "sura_id": 91, "start": 0, "end": 7, "numStart": 0},
        {"page": 595, "sura_id": 92, "start": 7, "end": 12, "numStart": 15},
        {"page": 596, "sura_id": 92, "start": 0, "end": 3, "numStart": 0},
        {"page": 596, "sura_id": 93, "start": 3, "end": 8, "numStart": 7},
        {"page": 596, "sura_id": 94, "start": 8, "end": 11, "numStart": 18},
        {"page": 597, "sura_id": 95, "start": 0, "end": 4, "numStart": 0},
        {"page": 597, "sura_id": 96, "start": 4, "end": 11, "numStart": 8},
        {"page": 598, "sura_id": 97, "start": 0, "end": 3, "numStart": 0},
        {"page": 598, "sura_id": 98, "start": 3, "end": 11, "numStart": 5},
        {"page": 599, "sura_id": 98, "start": 0, "end": 2, "numStart": 0},
        {"page": 599, "sura_id": 99, "start": 2, "end": 7, "numStart": 1},
        {"page": 599, "sura_id": 100, "start": 7, "end": 11, "numStart": 9},
        {"page": 600, "sura_id": 100, "start": 0, "end": 1, "numStart": 0},
        {"page": 600, "sura_id": 101, "start": 1, "end": 7, "numStart": 2},
        {"page": 600, "sura_id": 102, "start": 7, "end": 11, "numStart": 13},
        {"page": 601, "sura_id": 103, "start": 0, "end": 2, "numStart": 0},
        {"page": 601, "sura_id": 104, "start": 2, "end": 6, "numStart": 3},
        {"page": 601, "sura_id": 105, "start": 6, "end": 9, "numStart": 12},
        {"page": 602, "sura_id": 106, "start": 0, "end": 3, "numStart": 0},
        {"page": 602, "sura_id": 107, "start": 3, "end": 7, "numStart": 4},
        {"page": 602, "sura_id": 108, "start": 7, "end": 9, "numStart": 11},
        {"page": 603, "sura_id": 109, "start": 0, "end": 3, "numStart": 0},
        {"page": 603, "sura_id": 110, "start": 3, "end": 6, "numStart": 6},
        {"page": 603, "sura_id": 111, "start": 6, "end": 9, "numStart": 9},
        {"page": 604, "sura_id": 112, "start": 0, "end": 2, "numStart": 0},
        {"page": 604, "sura_id": 113, "start": 2, "end": 5, "numStart": 4},
        {"page": 604, "sura_id": 114, "start": 5, "end": 9, "numStart": 9}
      ]
    };
    String jsonString = json.encode(jsonData);
    final surahSplitList = surahSplitFromJson(jsonString);
    for (var element in surahSplitList.splitSura) {
      if (!pageFix.contains(element.page)) {
        pageFix.add(element.page);
      }

      if (element.suraId == id && element.page == currentPage) {
        start = element.start;
        end = element.end;
        numStart = element.numStart;
      }
    }
  }

  getNoData() {
    if (wordDetail.isEmpty || wordName.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void removeDetail(int index) {
    wordName.removeAt(index);
    notifyListeners();
  }

  void addDetail(WordDetail detail) {
    wordName.add(detail);
    notifyListeners();
  }

  Future<void> replace(WordDetail data, int? id) async {
    var index = wordDetail.indexWhere((element) => element.id == id);
    wordDetail.replaceRange(index, index + 1, [
      WordDetail(
          childType: data.childType,
          isparent: data.parent!.split("/").length == 1 || data.parent == ''
              ? true
              : false,
          hasChild: data.parent!.split("/").length > 1 || data.parent == ''
              ? true
              : false,
          parent: data.parent,
          id: id,
          type: data.type,
          categoryId: data.categoryId,
          name: data.name)
    ]);

    ///todo:update changes
    await update("$id", data.categoryId!);
    notifyListeners();
  }

  Future<String> getType(int id) async {
    var obj = await wordCategory.where('id', isEqualTo: "$id").get();
    var data = '';
    obj.docs.forEach((element) {
      data = element['word_type'] ?? '';
    });
    return data;
  }

  Future<void> update(String id, int wordId) async {
    await wordRelationship.doc(id).set({
      "updated_at": DateTime.now().toString(),
      "word_category_id": '$wordId'
    }, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> updateCategory(
    String engName,
    String malayName,
    String arabName,
    String childType,
    String type,
    String categoryID,
  ) async {
    addTranslation(engName, malayName, arabName);
    await wordCategory.doc(categoryID).set({
      "tname": engName,
      "child_type": childType,
      "word_type": type,
      "updated_at": DateTime.now().toString(),
    }, SetOptions(merge: true));
    notifyListeners();
  }

  checkMainColor(int? id) {
    if (id == 3 || id == 329) {
      return Color(0xffFF6106);
    }
    if (id == 68 || id == 384) {
      return Color(0xffFF29DD);
    }
    return Colors.black;
  }

  Future<String> getLabelName(String id) async {
    String name = '';
    return await wordCategoryTranslation
        .where('id', isEqualTo: id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['language_id'] == '1') {
          name = doc['name'];
          notifyListeners();
        }
      }
      return name;
    });
  }

  List<WordDetail> getSubList(int childID, String parentID) {
    String temp = '';
    if (parentID == '') {
      temp = '$childID';
    } else {
      temp = '$parentID/$childID';
    }
    List<WordDetail> _list = [];
    wordDetail.forEach((element) {
      if (element.parent == temp) {
        _list.add(element);
      }
    });
    return _list;
  }

  List<WordDetail> getParent() {
    wordDetail.forEach((element) {
      if (element.isparent!) {
        if (!parent.contains(element)) {
          if (parent.isNotEmpty) {
            parent.clear();
            parent.add(element);
          } else {
            parent.add(element);
          }
        }
      }
    });
    return parent;
  }

  Future<WordDetail> getFirst(String id, String langID) async {
    var obj;
    if (id != '') {
      obj = await wordCategory
          .where('id', isEqualTo: id)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        var data;
        for (var doc in querySnapshot.docs) {
          var name = await getCategoryNameTranslation(id, langID);

          String parent = doc["ancestry"] ?? '';
          data = WordDetail(
              childType: doc["child_type"] ?? '',
              isparent: true,
              hasChild: true,
              parent: parent,
              categoryId: int.parse(doc["id"].trim()),
              name: name != '' ? name : doc["name"],
              type: doc["word_type"] ?? 'None');
        }
        return data;
      });
    }
    print(obj);
    return obj;
  }

  Future<List<WordDetail>> getList(String parentID, String langID) async {
    labelCategory.clear();
    await wordCategory
        .where('ancestry', isEqualTo: parentID)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        var name = await getCategoryNameTranslation(doc['id'], langID);
        print(name);
        labelCategory.add(WordDetail(
            childType: doc["child_type"],
            parent: doc["ancestry"] ?? '',
            name: name != '' ? name : doc["name"],
            type: doc['word_type'] ?? 'None',
            categoryId: int.parse(doc['id'])));
      }
    });
    notifyListeners();
    return labelCategory;
  }

  void getFontSize(BuildContext context) {
    if (maxScreen < 400) {
      value = 11;
    } else if (maxScreen < 600) {
      value = 13;
    } else if (maxScreen < 800) {
      value = 22;
    } else if (maxScreen < 1000) {
      value = 23;
    } else if (maxScreen < 1200) {
      value = 25;
    } else if (maxScreen < 1400) {
      value = 25;
    } else {
      value = 25;
    }
  }

  void getScreenSize(BuildContext context) {
    maxScreen = MediaQuery.of(context).size.width;
  }

  void increment() {
    if (value < 68) {
      value = value + 1;
      notifyListeners();
    }
  }

  Future<String> getLastRelationshipId() async {
    var id;
    id = await wordRelationship
        .orderBy('created_at', descending: true)
        .limit(1)
        .get()
        .then((value) => value.docs.first["id"]);
    print(id);
    return id;
  }

  Future<String> getLastCategoryId() async {
    var id;
    id = await wordCategory
        .orderBy('created_at', descending: true)
        .limit(1)
        .get()
        .then((value) => value.docs.first["id"]);
    print(id);
    return id;
  }

  Future<void> addNewRelationship(
      {required int relationshipID,
      required int wordID,
      required int categoryID,
      required bool newCat}) async {
    if (newCat) categoryID = categoryID + 1;
    await wordRelationship.doc('${relationshipID + 1}').set({
      "active": "f",
      "created_at": DateTime.now().toString(),
      "id": "${relationshipID + 1}",
      "updated_at": DateTime.now().toString(),
      "word_category_id": "$categoryID",
      "word_id": "$wordID",
    });
  }

  addNewCategory(
      {required int categoryID,
      required String wordType,
      required String engName,
      required String malayName,
      required String arabName,
      required String childType,
      required String parent}) async {
    addTranslation(engName, malayName, arabName);
    await wordCategory.doc('${categoryID + 1}').set({
      "active": "t",
      "ancestry": parent,
      "child_type": childType,
      "created_at": DateTime.now().toString(),
      "id": "${categoryID + 1}",
      "tname": engName,
      "updated_at": DateTime.now().toString(),
      "word_type": wordType,
    });
  }

  getLangID(context) {
    if (Localizations.localeOf(context).toString() == "en_") {
      return "2";
    } else if (Localizations.localeOf(context).toString() == "ms_MY") {
      return "3";
    } else if (Localizations.localeOf(context).toString() == "ar_") {
      return "1";
    }
  }

  void addTranslation(String engName, String malayName, String arabName) {}
}
