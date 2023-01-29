import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'model/driverPreBook.dart';
import 'model/nearest _driver_ available.dart';

final TextEditingController phoneNumber = TextEditingController();
final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();
final TextEditingController firstname = TextEditingController();
final TextEditingController lastname = TextEditingController();

String mapKey = "AIzaSyDh5NNwfDJFU27Y_yMpVcWeeepBQBbewmM";
String serverToken =
    "key=AAAADxQpVvI:APA91bH34mheWrclzBAQyPxkT7LEKrmnFbhEXROlAH8blsBi3iqya6fQ7Soq1GEzaAZ77vPIF2tKp2cTPQ1NUkWoj1cqI_PSOLxaaPABc0d5jFxfCFAvbnbbGo8wFCENKN6E9ywT_4-k";

AudioPlayer audioPlayer = AudioPlayer();
late AudioCache audioCache;
StreamSubscription<DatabaseEvent>? rideStreamSubscription;
GoogleMapController? newGoogleMapController;
String carOrderType = "Taxi-4 seats";
String fNameIcon = "";
String lNameIcon = "";
String driverImage = "";
String statusRide = "";
String newstatusRide = "";
String carDriverInfo = "";
String driverName = "";
String carPlack = "";
String driverPhone = "";
String carTypeOnUpdateGeo = "";
String timeTrip = "";
String driverId = "";
String titleRate = "";
String carRideType = "";
String tourismCityName = "";
String tourismCityPrice = "";
String newValueDrop = "";
String state = "normal";
String waitDriver = "wait";
List<DriverPreBook> driverPreBookList = [];
List<NearestDriverAvailable> driverAvailable = [];
List<String> keyDriverAvailable = [];
LatLng driverNewLocation = const LatLng(0.0, 0.0);
double rating = 0.0;
double ratDriverRead = 0.0;
double geoFireRadios = 2;
int autoChangeColor = 0;
int rideRequestTimeOut = 30;
int after2MinTimeOut = 200;
bool sound1 = false;
bool sound2 = false;
bool sound3 = false;
bool driverCanceledAfterAccepted  = false;
bool openCollectMoney = false;
bool noChangeToTaxi = false;
bool updateDriverOnMap = true;
bool isTimeRequsteTrip = false;

// rm -rf Pods
// rm -rf Podfile.lock
// rm -rf ~/.pub-cache/hosted/pub.dartlang.org
// pod cache clean --all
// flutter clean
// flutter pub get
// pod repo update
// pod install
