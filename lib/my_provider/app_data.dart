// this class for listing to current location from geocoding

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/model/address.dart';

class AppData extends ChangeNotifier {
   Address pickUpLocation = Address();

  void updatePickUpLocationAddress(Address pickUpLocationAddress) {
    pickUpLocation = pickUpLocationAddress;
    notifyListeners();
  }
}
