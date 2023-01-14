// this class for listing to to drop of location after user got list of result in search screen

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/model/address.dart';

class PlaceDetailsDropProvider extends ChangeNotifier {
  Address dropOfLocation = Address();

  void updateDropOfLocation(Address address1) {
    dropOfLocation = address1;
    notifyListeners();
  }
}
