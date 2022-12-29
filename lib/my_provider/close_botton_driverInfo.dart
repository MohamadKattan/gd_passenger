// this class for show or hide close button in driver info

import 'package:flutter/cupertino.dart';

class CloseButtonProvider extends ChangeNotifier {
  bool isClose = false;
  void updateState(bool state) {
    isClose = state;
    notifyListeners();
  }
}
