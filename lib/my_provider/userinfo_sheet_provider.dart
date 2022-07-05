// this class for bottom sheet  user info
import 'package:flutter/material.dart';

class UserInfoSheet extends ChangeNotifier{
  double valSheet = -400;
  updateState(double state){
    valSheet = state;
    notifyListeners();
  }
}