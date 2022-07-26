class Model1 {
  String? aya;
  String? createdAt;
  String? id;
  String? medinaMushafPageId;
  String? suraId;
  String? text;
  String? updatedAt;

  Model1(this.aya, this.createdAt, this.id, this.medinaMushafPageId,
      this.suraId, this.text, this.updatedAt);

  factory Model1.fromJson(dynamic json) {
    return Model1(
        json['aya'] as String,
        json['created_at'] as String,
        json['id'] as String,
        json['medina_mushaf_page_id'] as String,
        json['sura_id'] as String,
        json['text'] as String,
        json['updated_at'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aya'] = aya;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['medina_mushaf_page_id'] = medinaMushafPageId;
    data['sura_id'] = suraId;
    data['text'] = text;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return '$aya, $text';
  }
}
