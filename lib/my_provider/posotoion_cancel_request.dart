//this class for listing to change value position cancel container

import 'package:flutter/cupertino.dart';

class PositionCancelReq extends ChangeNotifier {
  double value = -400.0;

  void updateValue(double val) {
    value = val;
    notifyListeners();
  }
}
