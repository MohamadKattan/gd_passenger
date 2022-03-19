//this class for database methods

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'auth_srv.dart';

class DataBaseSrv {
  final Tools _tools = Tools();

  firebase_storage.Reference refStorage =
      firebase_storage.FirebaseStorage.instance.ref();

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
    // try {
    //   User? firebaseUser = FirebaseAuth.instance.currentUser;
    //   String userId = firebaseUser!.uid;
    //   DatabaseReference ref =
    //       FirebaseDatabase.instance.ref().child("users").child(userId);
    //   TransactionResult result = await ref.runTransaction((Object? user) {
    //     Map<String, dynamic> _user = Map<String, dynamic>.from(user as Map);
    //     if (_user.values.isNotEmpty) {
    //       Users infoUser = Users.fromMap(_user);
    //       print("lllllllllll" + infoUser.firstName);
    //       Provider.of<UserAllInfoDatabase>(context, listen: false)
    //           .updateUser(infoUser);
    //     }
    //     return Transaction.success(_user);
    //   });
    // } catch (ex) {
    //   Tools().toastMsg("Welcome");
    // }
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
      Tools().toastMsg(ex.toString());
    }
  }

// this method will set all info when rider order a taxi in Ride Request collection
  void saveRiderRequest(BuildContext context) async {
    /// from api geo
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
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
  void cancelRiderRequest(UserIdProvider userIdProvider) {
    print("id is::::" + userIdProvider.getUser.uid);
    DatabaseReference RefRideRequest = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(userIdProvider.getUser.uid);
    RefRideRequest.remove();
  }
}
