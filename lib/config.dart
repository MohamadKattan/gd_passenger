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
GoogleMapController? newGoogleMapController;
