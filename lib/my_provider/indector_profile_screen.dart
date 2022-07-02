// this class for inductor in profile screen

import 'package:flutter/cupertino.dart';

class InductorProfileScreen extends ChangeNotifier{
  bool isTrue = false;
  updateState(bool state){
    isTrue=state;
    notifyListeners();
  }
}