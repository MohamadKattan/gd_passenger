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


class DataBaseSrv {
  Tools _tools = Tools();

  firebase_storage.Reference refStorage = firebase_storage.FirebaseStorage.instance.ref();

// set image to storage befor set user info to database
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
    DatabaseReference refuser = FirebaseDatabase.instance.ref().child("users").child(uid);
    try {
      await refuser.set({
        "user_id": uid.toString(),
        "image_profile": url.toString(),
        "first_name": firstname.text,
        "last_name": lastname.text,
        "email": email.text.trim(),
        "phone_number": phoneNumber.toString()
      }).whenComplete(() {
        Provider.of<TrueFalse>(context, listen: false)
            .changeStateBooling(false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } catch (ex) {
      Provider.of<TrueFalse>(context, listen: false).changeStateBooling(false);
      _tools.toastMsg(ex.toString());
    }
  }

  // this method for got user id/phone/image/name from user collection in database real time and send to saveRiderRequest method
  Future<void>  currentOnlineUserInfo(BuildContext context) async {
    try {
      User? firebaseUser = await FirebaseAuth.instance.currentUser;
      String userId = firebaseUser!.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("users").child(userId);
      TransactionResult result = await ref.runTransaction((Object? user) {
        Map<String, dynamic> _user = Map<String, dynamic>.from(user as Map);
        if(_user.values.isNotEmpty){
          Users  infoUser = Users.fromMap(_user);
          print("lllllllllll" + infoUser.first_name);
          Provider.of<UserAllInfoDatabase>(context, listen: false).updateUser(infoUser);
        }
        return Transaction.success(_user);
      });
    } catch (ex) {
      Tools().toastMsg("Welcome");
    }
  }

// this method will set all info when rider order a taxi in Ride Request collection
 void saveRiderRequest(BuildContext context)async {
    /// from api geo
    final pickUpLoc = Provider.of<AppData>(context, listen: false).pickUpLocation;
    print("pickUpLoc:::::: "+ pickUpLoc.placeName);
    ///from api srv place
    final dropOffLoc = Provider.of<PlaceDetailsDropProvider>(context, listen: false).dropOfLocation;
    print("pickUpLoc:::::: "+ dropOffLoc.placeName);
    ///from user model
    final currentUserInfoOnline=Provider.of<UserAllInfoDatabase>(context,listen: false).users;
    print("currentUserInfoOnline:::::: "+ currentUserInfoOnline!.first_name);

    final carTypePro = Provider.of<CarTypeProvider>(context,listen: false).carType;
    print("carTypePro:::::: "+ carTypePro!);
    final paymentMethod=Provider.of<DropBottomValue>(context,listen: false).valueDropBottom;
    try {
      Map pickUpLocMAP = {
        "latitude":pickUpLoc.latitude.toString(),
        "longitude":pickUpLoc.longitude.toString(),
      };
      print("pickUpLocMAP:::::: "+ pickUpLocMAP.toString());
      Map dropOffLocMap = {
        "latitude":dropOffLoc.latitude.toString(),
        "longitude":dropOffLoc.longitude.toString(),
      };
      print("dropOffLocMap:::::: "+ dropOffLocMap.toString());

      Map rideInfoMap = {
        "driver_id":"waiting",
        "payment_method":paymentMethod,
        "pickup":pickUpLocMAP,
        "dropoff":dropOffLocMap,
        "create_at":DateTime.now().toString(),
        "rider_name":"${currentUserInfoOnline.first_name} ${currentUserInfoOnline.last_name}",
        "rider_phone":currentUserInfoOnline.phone_number,
        "pickup_address":pickUpLoc.placeName,
        "dropoff_address":dropOffLoc.placeName,
        "vehicle_type_id":carTypePro,
        "user_Id":currentUserInfoOnline.user_id,
      };
      print("rideInfoMap::::::$rideInfoMap");
      DatabaseReference RefRideRequest = FirebaseDatabase.instance.ref().child("Ride Request").child(currentUserInfoOnline.user_id);
    await  RefRideRequest.set(rideInfoMap);
    } catch (ex) {
      _tools.toastMsg(ex.toString());
    }
  }

  // this method for cancel rider Request
 void cancelRiderRequest(UserIdProvider userIdProvider){
    print("id is::::" + userIdProvider.getUser.uid);
   DatabaseReference RefRideRequest = FirebaseDatabase.instance.ref().child("Ride Request").child(userIdProvider.getUser.uid);
   RefRideRequest.remove();
 }
}
