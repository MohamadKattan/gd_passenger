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
    String st1, st2, st3, st4, type1, type2;
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      type1 = response["results"][0]["address_components"][4]["types"][0];
      type2 = response["results"][0]["address_components"][5]["types"][0];
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      st3 = response["results"][0]["address_components"][5]["long_name"];
      st4 = response["results"][0]["address_components"][6]["long_name"];
      placeAddress = st1 + "," + st2 + "," + st3 + "," + st4;
      //from module
      Address userPickUpAddress = Address(
          placeFormattedAddress: "",
          placeName: placeAddress,
          placeId: "",
          latitude: position.latitude,
          longitude: position.longitude);
      if (type1 == 'administrative_area_level_1') {
        ref.child(userId!).update({"country": st2, "country0": st3});
      } else if (type2 == 'administrative_area_level_1') {
        ref.child(userId!).update({"country": st3, "country0": st4});
      } else {
        ref.child(userId!).update({"country": st2, "country0": st3});
      }

      ///old code
      // if (st3 == 'Turkey') {
      //   ref.child(userId!).update({"country": st3});
      // } else if (st4 == 'Turkey') {
      //   ref.child(userId!).update({"country": st4});
      // } else {
      //   ref.child(userId!).update({"country": st3});
      // }
      //for update
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  Future<void> getCountry() async {
    String stContry0, stContry1, stContry2, type1, type2;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      type1 = response["results"][0]["address_components"][4]["types"][0];
      type2 = response["results"][0]["address_components"][5]["types"][0];
      stContry0 = response["results"][0]["address_components"][4]["long_name"];
      stContry1 = response["results"][0]["address_components"][5]["long_name"];
      stContry2 = response["results"][0]["address_components"][6]["long_name"];
      if (type1 == 'administrative_area_level_1') {
        ref
            .child(userId!)
            .update({"country": stContry0, "country0": stContry1});
        contry = stContry0;
      } else if (type2 == 'administrative_area_level_1') {
        ref
            .child(userId!)
            .update({"country": stContry1, "country0": stContry2});
        contry = stContry1;
      } else {
        ref
            .child(userId!)
            .update({"country": stContry0, "country0": stContry1});
        contry = stContry0;
      }
      ///old code
      // if(stContry=='Turkey'){
      //   contry = stContry;
      //   ref.child(userId!).update({"country": stContry});
      // }
      // else if(stContry1=='Turkey'){
      //   contry = stContry1;
      //   ref.child(userId!).update({"country": stContry1});
      // }
      // else{
      //   contry = stContry;
      //   ref.child(userId!).update({"country": stContry});
      // }
    }
  }
}
