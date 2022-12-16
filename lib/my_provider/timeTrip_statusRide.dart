import 'package:flutter/cupertino.dart';

class TimeTripStatusRide extends ChangeNotifier{
  String statusRude = '';
  String timeTrip = '';

  void updateStatusRide(String status){
    statusRude = status;
    notifyListeners();
  }
  void updateTimeTrip(String status){
    timeTrip=status;
  }
}