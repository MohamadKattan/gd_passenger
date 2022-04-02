//this class for database methods

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:gd_passenger/model/user.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
import 'package:gd_passenger/my_provider/car_tupy_provider.dart';
import 'package:gd_passenger/my_provider/dropBottom_value.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/my_provider/placeDetails_drop_provider.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/home_screen.dart';
import 'package:gd_passenger/user_enter_face/splash_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../config.dart';
import '../model/nearest _driver_ available.dart';
import '../my_provider/nearsert_driver_provider.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/posotoion_cancel_request.dart';
import '../tools/geoFire_methods_tools.dart';
import 'auth_srv.dart';

class DataBaseSrv {
  final Tools _tools = Tools();

  firebase_storage.Reference refStorage =
      firebase_storage.FirebaseStorage.instance.ref();
  late DataSnapshot snapshot;
// set image to storage before set user info to database
  Future<void> setImageToStorage(
      TextEditingController firstname,
      TextEditingController lastname,
      String uid,
      BuildContext context,
      String phoneNumber,
      XFile imageFile,
      TextEditingController email) async {
    await refStorage
        .child("users")
        .child(uid)
        .putFile(File(imageFile.path))
        .whenComplete(() =>
            downloadURL(firstname, lastname, uid, context, phoneNumber, email));
  }

// got url image to set in database
  Future<void> downloadURL(
      TextEditingController firstname,
      TextEditingController lastname,
      String uid,
      BuildContext context,
      String phoneNumber,
      TextEditingController email) async {
    String url = await refStorage.child("users").child(uid).getDownloadURL();
    print("urllll${url}");
    setUserinfoToDataBase(
        url, uid, firstname, lastname, context, phoneNumber, email);
  }

// for set user auth first time of register name/phone/id/image
  Future<void> setUserinfoToDataBase(
      String url,
      String uid,
      TextEditingController firstname,
      TextEditingController lastname,
      BuildContext context,
      String phoneNumber,
      TextEditingController email) async {
    DatabaseReference refuser =
        FirebaseDatabase.instance.ref().child("users").child(uid);
    try {
      await refuser.set({
        "userId": uid.toString(),
        "imageProfile": url.toString(),
        "firstName": firstname.text,
        "lastName": lastname.text,
        "email": email.text.trim(),
        "phoneNumber": phoneNumber.toString()
      }).whenComplete(() {
        Provider.of<TrueFalse>(context, listen: false)
            .changeStateBooling(false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } catch (ex) {
      Provider.of<TrueFalse>(context, listen: false).changeStateBooling(false);
      _tools.toastMsg(ex.toString());
    }
  }

  // this method for got user id/phone/image/name from user collection in database real time and send to saveRiderRequest method
  void currentOnlineUserInfo(BuildContext context) async {
    final currentUser = AuthSev().auth.currentUser;
    late final DataSnapshot snapshot;
    try {
      final ref = FirebaseDatabase.instance.ref();
      snapshot = await ref.child("users").child(currentUser!.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> map =
            Map<String, dynamic>.from(snapshot.value as Map);
        Users infoUser = Users.fromMap(map);
        print("lllllllllll" + infoUser.firstName);
        Provider.of<UserAllInfoDatabase>(context, listen: false)
            .updateUser(infoUser);
        return;
      } else {
        print('No data available.');
      }
    } catch (ex) {
      Tools().toastMsg("Welcome DATA!!");
    }
  }

// this method will set all info when rider order a taxi in Ride Request collection
  void saveRiderRequest(BuildContext context) async {
    /// from api geo
    final pickUpLoc = Provider.of<AppData>(context, listen: false).pickUpLocation;
    print("pickUpLoc:::::: " + pickUpLoc.placeName);

    ///from api srv place
    final dropOffLoc =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;
    print("pickUpLoc:::::: " + dropOffLoc.placeName);

    ///from user model
    final currentUserInfoOnline =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    print("currentUserInfoOnline:::::: " + currentUserInfoOnline!.firstName);

    final carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    print("carTypePro:::::: " + carTypePro!);
    final paymentMethod =
        Provider.of<DropBottomValue>(context, listen: false).valueDropBottom;
    try {
      Map pickUpLocMAP = {
        "latitude": pickUpLoc.latitude.toString(),
        "longitude": pickUpLoc.longitude.toString(),
      };
      print("pickUpLocMAP:::::: " + pickUpLocMAP.toString());
      Map dropOffLocMap = {
        "latitude": dropOffLoc.latitude.toString(),
        "longitude": dropOffLoc.longitude.toString(),
      };
      print("dropOffLocMap:::::: " + dropOffLocMap.toString());

      Map rideInfoMap = {
        "driverId": "waiting",
        "paymentMethod": paymentMethod,
        "pickup": pickUpLocMAP,
        "dropoff": dropOffLocMap,
        "createAt": DateTime.now().toString(),
        "riderName":
            "${currentUserInfoOnline.firstName} ${currentUserInfoOnline.lastName}",
        "riderPhone": currentUserInfoOnline.phoneNumber,
        "pickupAddress": pickUpLoc.placeName,
        "dropoffAddress": dropOffLoc.placeName,
        "vehicleType_id": carTypePro,
        "userId": currentUserInfoOnline.userId,
      };
      print("rideInfoMap::::::$rideInfoMap");
      DatabaseReference RefRideRequest = FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(currentUserInfoOnline.userId);
      await RefRideRequest.set(rideInfoMap);
    } catch (ex) {
      _tools.toastMsg(ex.toString());
    }
  }

  // this method for cancel rider Request
  Future<void> cancelRiderRequest(UserIdProvider userIdProvider,BuildContext context) async {
    final driverNer = Provider.of<NearestDriverProvider>(context,listen: false).driverNerProvider;
    print("id is::::" + userIdProvider.getUser.uid);
    DatabaseReference refRideRequest = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(userIdProvider.getUser.uid);
    await refRideRequest.remove();
    if(driverNer.key.isEmpty || driverNer.key == ""){
      return;
    }
    else{
        DatabaseReference driverRef = FirebaseDatabase.instance
            .ref()
            .child("driver")
            .child(driverNer.key)
            .child("newRide");
        await driverRef.set("searching");
          NearestDriverAvailable _nearestDriverAvailable = NearestDriverAvailable("",0.0,0.0);
          Provider.of<NearestDriverProvider>(context,listen: false).updateState(_nearestDriverAvailable);
        driverRef.child("newRide").onDisconnect();
    }
  }

  // this method for send ride Request Id to driver collection in newride child for notification
  Future<void> sendRideRequestId(
      NearestDriverAvailable driver, BuildContext context) async {
    final userId =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(driver.key)
        .child("newRide");
    try {
      await driverRef.set(userId?.userId);
    } catch (e) {
      e.toString();
    }
  }


}
