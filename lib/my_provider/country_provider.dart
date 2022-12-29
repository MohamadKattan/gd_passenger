// this class for Country provider in advance screen for preBooking

import 'package:flutter/material.dart';

class CountryProvider extends ChangeNotifier {
  String country = 'Choose Country';
  void updateState(String state) {
    country = state;
    notifyListeners();
  }
}
