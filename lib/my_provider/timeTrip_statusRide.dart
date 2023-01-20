import 'package:flutter/cupertino.dart';

class TimeTripStatusRide extends ChangeNotifier {
  String statusRude = '';
  String timeTrip = '';
  String currencyType = '';
// update updateStatusRide
  void updateStatusRide(String status) {
    statusRude = status;
    notifyListeners();
  }

// update time trip
  void updateTimeTrip(String status) {
    timeTrip = status;
    notifyListeners();
  }

  // this method for display CurrencyType after calc fare and check country
  void updateCurrencyType(String status) {
    currencyType = status;
    // notifyListeners();
  }
}
