// this class for listing to bowling

import 'package:flutter/material.dart';

class TrueFalse extends ChangeNotifier{
  bool isTrue = false;
  changeStateBooling(bool state){
    isTrue=state;
    notifyListeners();
  }
}