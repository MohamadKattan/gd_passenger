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

      ref.child(userId!).child("country").set(st3);

      //for update
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  Future<dynamic>getContry()async{
    String stContry = "";
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      stContry = response["results"][0]["address_components"][5]["long_name"];
      contry=stContry;
      ref.child(userId!).child("country").set(stContry);
    }
    return stContry;
  }
}
