// for chang opacity above car type in home screen

import 'package:flutter/cupertino.dart';

class OpacityChang extends ChangeNotifier {
  bool isOpacityTaxi = true;
  bool isOpacityVan = false;
  bool isOpacityVeto = false;

  changOpacityTaxi(bool chang) {
    isOpacityTaxi = chang;
    notifyListeners();
  }

  changOpacityVan(bool chang) {
    isOpacityVan = chang;
    notifyListeners();
  }

  changOpacityVeto(bool chang) {
    isOpacityVeto = chang;
    notifyListeners();
  }
}
