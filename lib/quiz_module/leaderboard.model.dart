class Quiz {
  final String userID;
  final int score;

  Quiz({required this.userID, required this.score});

  Quiz.fromJson(Map<String, Object?> json)
      : this(
          userID: json['user-id']! as String,
          score: json['score']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'user-id': userID,
      'score': score,
    };
  }
}
