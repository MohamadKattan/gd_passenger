// this class for listing to booling

import 'package:flutter/material.dart';

class TrueFalse extends ChangeNotifier{
  bool isTrue = false;
  changeStateBooling(bool state){
    isTrue=state;
    notifyListeners();
  }
}