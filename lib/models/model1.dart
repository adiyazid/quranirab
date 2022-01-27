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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aya'] = this.aya;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['medina_mushaf_page_id'] = this.medinaMushafPageId;
    data['sura_id'] = this.suraId;
    data['text'] = this.text;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return '$aya, $text' ;
  }
}
