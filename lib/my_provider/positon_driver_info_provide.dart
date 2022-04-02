// this class for listing to position driver info containe

import 'package:flutter/cupertino.dart';

class PositionDriverInfoProvider extends ChangeNotifier {
  double positionDriverInfo = -400.0;

  void updateState(double state){
    positionDriverInfo = state;
    notifyListeners();
  }
}