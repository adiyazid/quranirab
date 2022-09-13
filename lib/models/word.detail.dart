class WordDetail {
  String? word_type;
  String? name;
  int? categoryId;
  int? relationshipId;
  String? ancestry;
  bool? isparent;
  bool? hasChild;
  String? childType;

  WordDetail(
      {required this.name,
      required this.word_type,
      required this.categoryId,
      this.relationshipId,
      this.ancestry,
      this.isparent,
      this.hasChild,
      this.childType});
  // WordDetail.fromJson(Map<String, dynamic> json)
  //     : name = json['tname'],
  //       word_type = json['word_type'],
  //       categoryId = json['id'],parent = json['ancestry'],;
  //
  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'email': email,
  //     };
}
