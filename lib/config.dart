import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'model/directions_details.dart';

 final TextEditingController phoneNumber = TextEditingController();
 final TextEditingController email = TextEditingController();
 final  TextEditingController firstname = TextEditingController();
 final TextEditingController lastname = TextEditingController();

String mapKey = "AIzaSyAKMapANMFqO7-hXUfsjfQHtQG6JlSnuAo";
String serverToken =
    "key=AAAADxQpVvI:APA91bH34mheWrclzBAQyPxkT7LEKrmnFbhEXROlAH8blsBi3iqya6fQ7Soq1GEzaAZ77vPIF2tKp2cTPQ1NUkWoj1cqI_PSOLxaaPABc0d5jFxfCFAvbnbbGo8wFCENKN6E9ywT_4-k";

Tools tools = Tools();
DataBaseSrv srv = DataBaseSrv();
DirectionDetails? tripDirectionDetails;
List<LatLng> polylineCoordinates = [];
Set<Polyline> polylineSet = {};
Set<Marker> markersSet = {};
Set<Circle> circlesSet = {};
GoogleMapController? newGoogleMapController;
StreamSubscription<Position>? tripScreenStreamSubscription;
String fNameIcon = "";
String lNameIcon = "";
String driverImage = "";
int rideRequestTimeOut = 25;
int after2MinTimeOut = 100;
String statusRide = "";
String newstatusRide = "";
String carDriverInfo = "";
LatLng driverNewLocation = const LatLng(0.0, 0.0);
String driverName = "";
String driverPhone = "";
String carDriverType = "";
String timeTrip = "";
String driverId = "";
String titleRate = "";
double rating = 0.0;
double ratDriverRead = 0.0;
String carRideType = "";
String tourismCityName = "";
String tourismCityPrice = "";
String newValueDrop = "";



