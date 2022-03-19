// this class will include geoFire method list for add available drivers/delete from list and etc...

import '../model/nearest _driver_ available.dart';

class GeoFireMethods {
  // this method for add mew driver available that display to rider when do order
  static List<NearestDriverAvailable> listOfNearestDriverAvailable = [];

// this method for removeDriverFromList if driver off line
  static void removeDriverFromList(String key) {
    int index = listOfNearestDriverAvailable
        .indexWhere((element) => element.key == key);
    listOfNearestDriverAvailable.removeAt(index);
  }

  // this method fpr update live driver location  for rider got the best result
  static void updateDriverNearLocation(NearestDriverAvailable driver) {
    int index = listOfNearestDriverAvailable
        .indexWhere((element) => element.key == driver.key);

    listOfNearestDriverAvailable[index].latitude = driver.latitude;
    listOfNearestDriverAvailable[index].longitude = driver.longitude;
  }

}
