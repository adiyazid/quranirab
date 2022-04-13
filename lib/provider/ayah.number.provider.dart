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
  List _sPos = [];
  List ayaPosition = [];
  List ayaNumber = [];
  List<int>? breakIndex;
  List<SlicingDatum>? slice = <SlicingDatum>[];
  List<bool> select = [];
  List<bool> old = [];
  List isim = [];
  List haraf = [];
  List fail = [];
  final List<WordDetail> wordTypeDetail = [];
  final List<WordDetail> wordName = [];

  CollectionReference wordRelationship =
      FirebaseFirestore.instance.collection('word_relationships');

  CollectionReference wordCategory =
      FirebaseFirestore.instance.collection('word_categories');
  CollectionReference wordCategoryTranslation =
      FirebaseFirestore.instance.collection('category_translations');
  final CollectionReference _sliceData =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');

  List? list = [];

  String? words;

  get value => _value;

  get sliceData => _sliceData;
  bool visible = false;

  void increment() {
    if (_value != 35) {
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
    _sPos.clear();
    if (visible == true) visible = !visible;
    notifyListeners();
  }

  Future<void> readAya() async {
    clearPrevAya();
    notifyListeners();
    var prev = 0;
    num total = 0;
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
        total = total + doc["text"].split('').length;
        notifyListeners();
      }
      for (int i = 0; i < list!.join().split('').length; i++) {
        select.add(false);
      }
      for (int i = 0; i < list!.join().split('').length; i++) {
        if (list!.join().split('')[i] == 'ﲿ') {
          _sPos.add(i);
        }
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
    } else if (page == 100) {
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
    } else if (page == 200) {
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
    if (wordTypeDetail.isNotEmpty) {
      return wordTypeDetail;
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

  void clear() {
    isim.clear();
    haraf.clear();
    fail.clear();
    notifyListeners();
  }

  void setWords(word) {
    words = word;
  }

  Future<void> getCategoryName(wordId, langId) async {
    await wordRelationship
        .where('word_id', isEqualTo: wordId.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
      wordTypeDetail.clear();
      wordName.clear();
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
    }
  }

  void checkRebuilt(no) {
    if (no != 0) nums = 0;
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
          wordTypeDetail.add(WordDetail(
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
          wordTypeDetail.add(WordDetail(
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
          wordName.add(WordDetail(
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
    ayaPosition.clear();
    ayaNumber.clear();
    notifyListeners();
  }

  checkAya(index) {
    var total = list!.length - 1;
    var lengthAya1 = list![0].split(' ').length;
    var d = _sPos.contains(index - 2);
    var a = ayaPosition.contains(index != 0 ? index - 1 : index);
    var b = ayaPosition.contains(index);
    var c = ayaPosition.contains(index + 1);
    if (d) {
      if (nums < total && nums < lengthAya1) {
        nums = nums + 1;
      }
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
    visible = !visible;
    notifyListeners();
  }

  checkSymbol(int end) {
    if (_sPos.contains(end - 3)) {
      print('t $end');
      return true;
    } else {
      return false;
    }
  }
}
