// this class for indector in profile screen

import 'package:flutter/cupertino.dart';

class IndectorProfileScreen extends ChangeNotifier{
  bool isTrue = false;
  updateState(bool state){
    isTrue=state;
    notifyListeners();
  }
}