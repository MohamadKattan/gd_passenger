// this class for listing to nearest driver list

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/model/nearest%20_driver_%20available.dart';

class NearestDriverProvider extends ChangeNotifier {
  NearestDriverAvailable driverNerProvider =
      NearestDriverAvailable("", 0.0, 0.0);
  void updateState(NearestDriverAvailable driverAvailable) {
    driverNerProvider = driverAvailable;
    notifyListeners();
  }
}
