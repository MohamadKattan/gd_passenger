// this class for listing in internet week screen and show indector

import 'package:flutter/cupertino.dart';

class IndectorNetWeek extends ChangeNotifier{
  bool val = false;
  void updateState(bool state){
    val = state;
    notifyListeners();
  }
}