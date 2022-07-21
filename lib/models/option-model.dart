class Option {
  late String id;
  late String text;
  late bool isCorrect;
  late bool isSelected;

  Option(
      {required this.id,
      required this.text,
      this.isCorrect = false,
      this.isSelected = false});
}
