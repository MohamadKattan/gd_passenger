// this class for change color bottom in main screen

import 'package:flutter/cupertino.dart';

class ChangeColor extends ChangeNotifier {
  bool isTrue = false;

  updateState(bool state) {
    isTrue = state;
    notifyListeners();
  }
}
