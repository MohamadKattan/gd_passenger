import 'package:flutter/cupertino.dart';

class CarTypeBook extends ChangeNotifier {
  String carType = 'Choose the type of car';

  void updateState(String state) {
    carType = state;
    notifyListeners();
  }
}
