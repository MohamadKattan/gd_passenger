// this class for changer stata line container + opacity under type car in main screen

import 'package:flutter/cupertino.dart';

class LineTaxi extends ChangeNotifier {
  bool islineTaxi = true;
  bool islineVan = false;
  bool islineVeto = false;

  changelineTaxi(bool change) {
    islineTaxi = change;
    notifyListeners();
  }

  changelineVan(bool change) {
    islineVan = change;
    notifyListeners();
  }

  changelineVeto(bool change) {
    islineVeto = change;
    notifyListeners();
  }
}
