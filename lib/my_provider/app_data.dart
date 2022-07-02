// this class for listing to current location from geocoding

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/model/address.dart';

class AppData extends ChangeNotifier {
  late Address pickUpLocation = Address(
    placeId: '',
    placeFormattedAddress: '',
    placeName: '',
    longitude: 0.0,
    latitude: 0.0,
  );

  void updatePickUpLocationAddress(Address pickUpLocationAddress) {
    pickUpLocation = pickUpLocationAddress;
    notifyListeners();
  }
}
