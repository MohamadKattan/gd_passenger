//this class for google map methods
import 'dart:async';
import 'package:gd_passenger/repo/api_srv_geo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import 'config.dart';



class LogicGoogleMap {
  final ApiSrvGeo _apiMethods = ApiSrvGeo();

  //instant current location on map before any request on map
  Completer<GoogleMapController> controllerGoogleMap = Completer();

// set location
  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(41.084253576036936, 28.89201922194848),
    zoom: 14.4746,
  );

  Future<dynamic> locationPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition, zoom: 17.0, tilt: 0.0, bearing: 0.0);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    await _apiMethods.searchCoordinatesAddress(position, context);
  }
}
