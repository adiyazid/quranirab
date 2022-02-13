
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizModel {

  late String userId;
  late String level;
  late int mushaf_page;
  late String quiz_type_id;
  late double score;
  late int number_of_questions;
  late double progress;
  late var remainingWords = [];
  late String date_taken;

  Map<String, dynamic> toMap()
  {
    return {
      'userId': userId,
      'level': level,
      'mushaf_page': mushaf_page,
      'quiz_type_id': quiz_type_id,
      'score': score,
      'progress': progress,
      'date_taken': date_taken,
      'remainingWords': remainingWords,
      'number_of_questions': number_of_questions
    };
  }

  factory QuizModel.fromMap(map)
  {
    return QuizModel(
      userId: map['userId'],
      level: map['level'],
      mushaf_page: map['mushaf_page'],
      quiz_type_id: map['quiz_type_id'],
      score: map['score'],
      progress: map['progress'],
      date_taken: map['date_taken'],
      remainingWords: map['remainingWords'],
      number_of_questions: map['number_of_questions']

    );
  }




  QuizModel({
    required this.userId,
    required this.level,
    required this.mushaf_page,
    required this.quiz_type_id,
    required this.score,
    required this.progress,
    required this.remainingWords,
    required this.date_taken,
    required this.number_of_questions
  });


}
//