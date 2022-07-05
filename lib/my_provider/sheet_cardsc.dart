// this class for sheet car descrption

import 'package:flutter/cupertino.dart';

class SheetCarDesc extends ChangeNotifier{
  double sheetValTaxi = -400;
  double sheetValMed= -400;
  double sheetValBig = -400;
  updateStateTaxi(double state){
    sheetValTaxi =state;
    notifyListeners();
  }
  updateStateMed(double state){
    sheetValMed =state;
    notifyListeners();
  }
  updateStateBig(double state){
    sheetValBig =state;
    notifyListeners();
  }
}