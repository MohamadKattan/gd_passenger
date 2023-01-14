// this class api GeoCoding  for make address  read able

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/address.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'auth_srv.dart';

class ApiSrvGeo {
  final userId = AuthSev().auth.currentUser?.uid;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("users");
  // this method for got geocoding api for current position address readable

  Future<void> searchCoordinatesAddress(
      Position position, BuildContext context) async {
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await GetUrl().getUrlMethod(url);
    if (response != "failed") {
      String placeAddress = response["results"][0]["formatted_address"];
      Address userPickUpAddress = Address();
      userPickUpAddress.placeFormattedAddress = "";
      userPickUpAddress.placeName = placeAddress;
      userPickUpAddress.placeId = "";
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
  }

  /// this method will work lazy no another way api list is dynamic no other way to check
  Future<void> getCountry() async {
    String? city, country, type1, type2, type3, type4;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    var response = await GetUrl().getUrlMethod(url);
    if (response != "failed") {
      if (response["results"][1]["address_components"][3]["types"][0] != null) {
        type1 = response["results"][1]["address_components"][3]["types"][0];
        if (type1 == 'administrative_area_level_1') {
          city = response["results"][1]["address_components"][3]["long_name"];
          country =
              response["results"][1]["address_components"][4]["long_name"];
        } else if (response["results"][1]["address_components"][4]["types"]
                [0] !=
            null) {
          type2 = response["results"][1]["address_components"][4]["types"][0];
          if (type2 == 'administrative_area_level_1') {
            city = response["results"][1]["address_components"][4]["long_name"];
            country =
                response["results"][1]["address_components"][5]["long_name"];
          } else if (response["results"][1]["address_components"][5]["types"]
                  [0] !=
              null) {
            type3 = response["results"][1]["address_components"][5]["types"][0];
            if (type3 == 'administrative_area_level_1') {
              city =
                  response["results"][1]["address_components"][5]["long_name"];
              country =
                  response["results"][1]["address_components"][6]["long_name"];
            } else if (response["results"][1]["address_components"][6]["types"]
                    [0] !=
                null) {
              type4 =
                  response["results"][1]["address_components"][6]["types"][0];
              if (type4 == 'administrative_area_level_1') {
                city = response["results"][1]["address_components"][6]
                    ["long_name"];
                country = response["results"][1]["address_components"][7]
                    ["long_name"];
              }
            }
          }
        }
      }
      ref.child(userId!).update(
          {"country": city ?? 'globule', "country0": country ?? 'globule'});
    }
  }
}
