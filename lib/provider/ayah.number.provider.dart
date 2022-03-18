import 'package:flutter/material.dart';

class AyaNumber extends ChangeNotifier {
  var data = 'Word Category will display here..';

  currentValue() {
    notifyListeners();
    return data;
  }

  void updateValue(String s) {
    data = s;
    notifyListeners();
  }
}
