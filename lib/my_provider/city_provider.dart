// this class for city provider in advance screen for preBooking

import 'package:flutter/cupertino.dart';
class CityProvider extends ChangeNotifier {
  String city = "";
  void updateState(String state) {
    city = state;
    notifyListeners();
  }
}
