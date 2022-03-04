//this class for database methods

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gd_passenger/model/user.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DataBaseSrv {
  Tools _tools = Tools();

  firebase_storage.Reference refStorage = firebase_storage.FirebaseStorage.instance.ref();

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

  Future<void> setUserinfoToDataBase(
      String url,
      String uid,
      TextEditingController firstname,
      TextEditingController lastname,
      BuildContext context,
      String phoneNumber,
      TextEditingController email) async {
    DatabaseReference refuser = FirebaseDatabase.instance.ref();
    try {
      await refuser.child("users").child(uid).set({
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

  // this method for got user id/phone/image/name from user collection in database real time
  currentOnlineUserInfo() async {
    User? firebaseUser =  FirebaseAuth.instance.currentUser;
     String userId = firebaseUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("users").child(userId);
    TransactionResult result = await ref.runTransaction((Object? user) {
      Map<String, dynamic> _user = Map<String, dynamic>.from(user as Map);
      Users  infoUser = Users.fromMap(_user);
      print("lllllllllll"+infoUser.user_id);
      return Transaction.success(_user);
    });
    return null;
  }

  // Future<void> saveRiderRequest() async {
  //   try {
  //     await refuser.child("Ride Request").set({});
  //   } catch (ex) {
  //     _tools.toastMsg(ex.toString());
  //   }
  // }
}
