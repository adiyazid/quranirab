// To parse this JSON data, do
//
//     final words = wordsFromMap(jsonString);

//
// Map<String, Words> wordsFromMap(String str) => Map.from(json.decode(str))
//     .map((k, v) => MapEntry<String, Words>(k, Words.fromJson(v)));
//
// String wordsToMap(Map<String, Words> data) => json.encode(
//     Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())));

class Words {
  String? active;
  String? createdAt;
  int? finish;
  String? id;
  String? medinaMushafPageId;
  String? quranTextId;
  int? start;
  String? text;
  String? totalWords;
  String? updatedAt;
  String? wordOrder;


  Words.fromWords({this.id, this.text});

  Words(
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

  factory Words.fromJson(dynamic json) {
    return Words(
      json["active"] as String,
      json["created_at"] as String,
      json["finish"] as int,
      json["id"] as String,
      json["medina_mushaf_page_id"] as String,
      json["quran_text_id"] as String,
      json["start"] as int,
      json["text"] as String,
      json["total_words"] as String,
      json["updated_at"] as String,
      json["word_order"] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        "active": active,
        "created_at": createdAt,
        "finish": finish,
        "id": id,
        "medina_mushaf_page_id": medinaMushafPageId,
        "quran_text_id": quranTextId,
        "start": start,
        "text": text,
        "total_words": totalWords,
        "updated_at": updatedAt,
        "word_order": wordOrder,
      };

  @override
  String toString() {
    return '$start' '$finish';
  }
}
