import 'dart:convert';

class surah {
  String aya;
  String created_at;
  String id;
  String medina_mushaf_page_id;
  String sura_id;
  String text;
  String updated_at;

  surah(this.aya, this.created_at, this.id, this.medina_mushaf_page_id,
      this.sura_id, this.text, this.updated_at);

  factory surah.fromJson(Map<String, dynamic> json) {
    return surah(
      json['aya'],
      json['created_at'],
      json['id'],
      json['medina_mushaf_page_id'],
      json['sura_id'],
      json['text'],
      json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aya'] = this.aya;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['medina_mushaf_page_id'] = this.medina_mushaf_page_id;
    data['sura_id'] = this.sura_id;
    data['text'] = this.text;
    data['updated_at'] = this.updated_at;
    return data;
  }

  @override
  String toString() {
    return 'surah{aya: $aya, created_at: $created_at, id: $id, medina_mushaf_page_id: $medina_mushaf_page_id, sura_id: $sura_id, text: $text, updated_at: $updated_at}';
  }
}

// To parse this JSON data, do
//
//     final sliceModel = sliceModelFromJson(jsonString);

Map<String, SliceModel> sliceModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, SliceModel>(k, SliceModel.fromJson(v)));

String sliceModelToJson(Map<String, SliceModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class SliceModel {
  SliceModel(
    this.active,
    this.createdAt,
    this.finish,
    this.id,
    this.medinaMushafPageId,
    this.quranTextId,
    this.start,
    this.text,
    this.totalWords,
    this.updatedAt,
    this.wordOrder,
  );

  String active;
  DateTime createdAt;
  String finish;
  String id;
  String medinaMushafPageId;
  String quranTextId;
  String start;
  String text;
  String totalWords;
  DateTime updatedAt;
  String wordOrder;

  factory SliceModel.fromJson(Map<String, dynamic> json) => SliceModel(
        json["active"],
        DateTime.parse(json["created_at"]),
        json["finish"],
        json["id"],
        json["medina_mushaf_page_id"],
        json["quran_text_id"],
        json["start"],
        json["text"],
        json["total_words"],
        DateTime.parse(json["updated_at"]),
        json["word_order"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "created_at": createdAt.toIso8601String(),
        "finish": finish,
        "id": id,
        "medina_mushaf_page_id": medinaMushafPageId,
        "quran_text_id": quranTextId,
        "start": start,
        "text": text,
        "total_words": totalWords,
        "updated_at": updatedAt.toIso8601String(),
        "word_order": wordOrder,
      };

  @override
  String toString() {
    return 'SliceModel{"active": $active, "created_at": ${createdAt.toIso8601String()}, "finish": $finish,id: $id, "medina_mushaf_page_id": $medinaMushafPageId, "quran_text_id": $quranTextId,  "start": $start,"text": $text,"total_words": $totalWords,"updated_at": ${updatedAt.toIso8601String()},"word_order": $wordOrder}';
  }
}
