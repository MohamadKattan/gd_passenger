// this class for chang position from0.0 to -500 container above map

import 'package:flutter/cupertino.dart';

class PositionChang extends ChangeNotifier {
  double val = 0.0;

  changValue(double chang) {
    val = chang;
    notifyListeners();
  }
}
