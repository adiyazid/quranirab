class FontSize {
  static final FontSize _fontData = FontSize._internal();
  double size = 25;
  int? index;

  factory FontSize() {
    return _fontData;
  }

  FontSize._internal();
}

final fontData = FontSize();
