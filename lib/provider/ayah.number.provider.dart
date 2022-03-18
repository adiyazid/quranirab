import 'package:flutter/material.dart';

class AyaNumber extends ChangeNotifier {
  var data = 'No data..';

  currentValue() {
    notifyListeners();
    return data;
  }

  void updateValue(String s) {
    data = s;
    notifyListeners();
  }
}
