// this class for sheet profile Screen

import 'package:flutter/material.dart';

class ProfileSheet extends  ChangeNotifier{
  double valSheet = -400;

  updateState(double state){
    valSheet = state;
    notifyListeners();
  }
}