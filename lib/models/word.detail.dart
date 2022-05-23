class WordDetail {
  String? type;
  String? name;
  int? categoryId;
  int? id;
  String? parent;
  bool? isparent;
  bool? hasChild;
  String? childType;

  WordDetail(
      {required this.name,
      required this.type,
      required this.categoryId,
      this.id,
      this.parent,
      this.isparent,
      this.hasChild,
      this.childType});
}
