import 'package:flutter/material.dart';
class Option {
  late String id;
  late String text;
  late bool correct;

  Option({required this.id, required this.text, this.correct = false});
}