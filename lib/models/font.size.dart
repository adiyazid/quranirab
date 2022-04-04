class FontSize {
  static final FontSize _fontData = FontSize._internal();
  double size = 30;
  int? index;
  List? allpages;
  String? sura_id;
  String? name;
  String? detail;
  int? no;

  factory FontSize() {
    return _fontData;
  }

  FontSize._internal();
}

final fontData = FontSize();
