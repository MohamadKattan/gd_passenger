import 'package:flutter/material.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

TextEditingController firstname = TextEditingController();
TextEditingController lastname = TextEditingController();
TextEditingController email = TextEditingController();
Tools tools = Tools();
DataBaseSrv srv = DataBaseSrv();
String mapKey = "AIzaSyBt7etvZRY_OrzFcCsawNb22jqSzE2mRDg";
String serverToken ="key=AAAAZnprfL0:APA91bH3MKr_k15dqmiFxe6Z8p_YFJnTurnTLtxrZrv4dnMq1wJnn1ta8Htg6FSyWcPqNxMgCCTSc0cYjmu-U6gClk0YBzyHWrzKVsxJ-80Fum2hXlVyfY4tG-qclsL8-EJk1XmEZp0M";
GoogleMapController? newGoogleMapController;
int rideRequestTimeOut = 40;
String statusRide = "";
String carDriverInfo = "";
String driverName = "";
String driverPhone = "";
String timeTrip = "";