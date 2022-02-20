//this class for google map methods
 import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//instant current location on map before any request on map
 Completer<GoogleMapController> controllerGoogleMap = Completer();

// when driver arrived we need to change location to trip location on map
 GoogleMapController? newGoogleMapController;

// set location
 final CameraPosition kGooglePlex = CameraPosition(
 target: LatLng(37.42796133580664, -122.085749655962),
 zoom: 14.4746,
);
