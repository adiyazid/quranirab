class CategoryLeaderBoard {
  static final CategoryLeaderBoard _categoryLeaderBoard =
      CategoryLeaderBoard._internal();
  String? category;

  factory CategoryLeaderBoard() {
    return _categoryLeaderBoard;
  }

  CategoryLeaderBoard._internal();
}

final catData = CategoryLeaderBoard();
