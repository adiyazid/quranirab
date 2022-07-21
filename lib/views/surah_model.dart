class SurahModel {
  Plist? plist;

  SurahModel({this.plist});

  SurahModel.fromJson(Map<String, dynamic> json) {
    plist = json['plist'] != null ? Plist.fromJson(json['plist']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plist != null) {
      data['plist'] = plist?.toJson();
    }
    return data;
  }
}

class Plist {
  Dictparent? dictparent;

  Plist({this.dictparent});

  Plist.fromJson(Map<String, dynamic> json) {
    dictparent = json['dictparent'] != null
        ? Dictparent.fromJson(json['dictparent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dictparent != null) {
      data['dictparent'] = dictparent?.toJson();
    }
    return data;
  }
}

class Dictparent {
  String? type;
  Arrayparent? arrayparent;

  Dictparent({this.type, this.arrayparent});

  Dictparent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    arrayparent = json['arrayparent'] != null
        ? Arrayparent.fromJson(json['arrayparent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = this.type;
    if (arrayparent != null) {
      data['arrayparent'] = arrayparent?.toJson();
    }
    return data;
  }
}

class Arrayparent {
  Dictchild? dictchild;

  Arrayparent({this.dictchild});

  Arrayparent.fromJson(Map<String, dynamic> json) {
    dictchild = json['dictchild'] != null
        ? Dictchild.fromJson(json['dictchild'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dictchild != null) {
      data['dictchild'] = dictchild?.toJson();
    }
    return data;
  }
}

class Dictchild {
  List<String>? keychild;
  List<String>? ayahName;
  List<AyahArray>? ayahArray;
  Translations? translations;

  Dictchild({this.keychild, this.ayahName, this.ayahArray, this.translations});

  Dictchild.fromJson(Map<String, dynamic> json) {
    keychild = json['keychild'].cast<String>();
    ayahName = json['ayah_name'].cast<String>();
    if (json['ayah_array'] != null) {
      ayahArray = [];
      json['ayah_array'].forEach((v) {
        ayahArray?.add(AyahArray.fromJson(v));
      });
    }
    translations = json['translations'] != null
        ? Translations.fromJson(json['translations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keychild'] = keychild;
    data['ayah_name'] = ayahName;
    if (ayahArray != null) {
      data['ayah_array'] = ayahArray?.map((v) => v.toJson()).toList();
    }
    if (translations != null) {
      data['translations'] = translations?.toJson();
    }
    return data;
  }
}

class AyahArray {
  List<int>? integer;
  List<String>? ayah;

  AyahArray({this.integer, this.ayah});

  AyahArray.fromJson(Map<String, dynamic> json) {
    if (json['integer'] != null) {
      integer = json['integer'].cast<int>();
    }
    if (json['ayah'] != null) {
      ayah = json['ayah'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['integer'] = integer;
    data['ayah'] = ayah;
    return data;
  }
}

class Translations {
  String? language;
  TranslationList? translationList;

  Translations({this.language, this.translationList});

  Translations.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    translationList = json['translation_list'] != null
        ? TranslationList.fromJson(json['translation_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    if (translationList != null) {
      data['translation_list'] = translationList?.toJson();
    }
    return data;
  }
}

class TranslationList {
  List<String>? translation;

  TranslationList({this.translation});

  TranslationList.fromJson(Map<String, dynamic> json) {
    translation = json['translation'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['translation'] = translation;
    return data;
  }
}

