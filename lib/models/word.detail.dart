class WordDetail {
  String? type;
  String? name;
  int? categoryId;
  int? id;

  WordDetail(
      {required this.name,
      required this.type,
      required this.categoryId,
      this.id});
}
