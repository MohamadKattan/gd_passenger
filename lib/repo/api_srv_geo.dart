// this class api GeoCoding  for make address  read able


import 'package:flutter/material.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/address.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ApiSrvGeo {
  final GetUrl _getUrl = GetUrl();

  // this method for got geocoding api for current position address readable
  Future<dynamic> searchCoordinatesAddress(
      Position position, BuildContext context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    var url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      st3 = response["results"][0]["address_components"][5]["long_name"];
      st4 = response["results"][0]["address_components"][6]["long_name"];

      placeAddress = st1 + "," + st2 + "," + st3 + "," + st4 ;
      //from module
      Address userPickUpAddress =  Address(
          placeFormattedAddress: "",
          placeName: placeAddress,
          placeId: "",
          latitude: position.latitude,
          longitude: position.longitude);
      //for update
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
      print(":::::::"+placeAddress.toString());
    }
    return placeAddress;
  }

  //this method for disply places when user start search where to go
}
