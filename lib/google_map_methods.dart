//this class for google map methods
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class LogicGoogleMap {


  //instant current location on map before any request on map
  Completer<GoogleMapController> controllerGoogleMap = Completer();



// set location
  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

}
