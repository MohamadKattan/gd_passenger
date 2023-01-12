// this class for listing to bowling

import 'package:flutter/material.dart';

class TrueFalse extends ChangeNotifier {
  bool isTrue = false;
  bool showLineDiscountTaxi = false;
  bool showLineDiscountVeto = false;
  bool showLineDiscountVan = false;
  bool showRiderCancelRequest = false;
  bool showDriverInfoContainer = false;
  bool colorTaxiInRow = false;
  bool colorVetoInRow = false;
  bool colorVanInRow = false;
  // for circle inductor
  changeStateBooling(bool state) {
    isTrue = state;
    notifyListeners();
  }
  // for show line above price no discount taxi
  taxiDiscount(bool state) {
    showLineDiscountTaxi = state;
    notifyListeners();
  }
  // for show line above price no discount veto
  vetoDiscount(bool state) {
    showLineDiscountVeto = state;
    notifyListeners();
  }
  // for show line above price no discount van
  vanDiscount(bool state) {
    showLineDiscountVan = state;
    notifyListeners();
  }
  // for display content in CancelBord
  updateShowCancelBord(bool state) {
    showRiderCancelRequest = state;
    notifyListeners();
  }
  // for display content in DriveInfo
  updateShowDriverIfo(bool state) {
    showDriverInfoContainer = state;
    notifyListeners();
  }
  updateColorTextInRowTaxi(bool state) {
    colorTaxiInRow = state;
    notifyListeners();
  }
  updateColorTextInRowVeto(bool state) {
    colorVetoInRow = state;
    notifyListeners();
  }
  updateColorTextInRowVan(bool state) {
    colorVanInRow = state;
    notifyListeners();
  }
}
