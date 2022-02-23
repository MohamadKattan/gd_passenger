//this class for database methods

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DataBaseSrv {
  Tools _tools = Tools();
  DatabaseReference refuser = FirebaseDatabase.instance.ref("users");
  firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref();

  Future<void> setImageToStorage(
      TextEditingController firstname,
      TextEditingController lastname,
      String uid,
      BuildContext context,
      String phoneNumber,
      XFile imageFile) async {
    await ref.child("users").child(uid).putFile(File(imageFile.path)).whenComplete(
        () => downloadURL(firstname, lastname, uid, context, phoneNumber));
  }

  Future<void> downloadURL(
      TextEditingController firstname,
      TextEditingController lastname,
      String uid,
      BuildContext context,
      String phoneNumber) async {
    String url = await ref.child("users").child(uid).getDownloadURL();
    print("urllll${url}");
    setUserinfoToDataBase(url, uid, firstname, lastname, context, phoneNumber);
  }

  Future<void> setUserinfoToDataBase(
      String url,
      String uid,
      TextEditingController firstname,
      TextEditingController lastname,
      BuildContext context,
      String phoneNumber) async {
    try {
      await refuser.child(uid).set({
        "user_id": uid.toString(),
        "image_profile": url.toString(),
        "first_name": firstname.text,
        "last_name": lastname.text,
        "phone_number": phoneNumber.toString()
      }).whenComplete(() {
        Provider.of<TrueFalse>(context, listen: false)
            .changeStateBooling(false);
         Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } catch (ex) {
      Provider.of<TrueFalse>(context, listen: false)
          .changeStateBooling(false);
      _tools.toastMsg(ex.toString());
    }
  }
}
