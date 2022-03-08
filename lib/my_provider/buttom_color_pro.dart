// this class for change color buttom in main screen

import 'package:flutter/cupertino.dart';

class ChangeColor extends ChangeNotifier{
  bool isTrue=false;

  updateState(bool state){
    isTrue=state;
    notifyListeners();
  }
}