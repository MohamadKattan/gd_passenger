import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:gd_passenger/user_enter_face/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/user.dart';
import '../my_provider/info_user_database_provider.dart';
import '../user_enter_face/user_info_screen.dart';

// this class for Auth by firebase-phone method

class AuthSev {
  final Tools _tools = Tools();
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference refuser = FirebaseDatabase.instance.ref().child("users");
  late UserCredential userCredential;
  late User? currentUser;
  late final DataSnapshot snapshot;
  final TextEditingController codeText = TextEditingController();
  //this method for got user id
  Future<void> createOrLoginWithEmail(
      String pass, BuildContext context, String email) async {
    Provider.of<TrueFalse>(context, listen: false).changeStateBooling(true);
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      await getCurrentUserId();
      if (userCredential.user!.uid.isNotEmpty) {
        currentUser = userCredential.user!;
        snapshot = await refuser.child(currentUser!.uid).get();
        if (snapshot.exists) {
          Map<String, dynamic> map = Map<String, dynamic>.from(snapshot.value as Map);
          Users _infoUser = Users.fromMap(map);
          Provider.of<UserAllInfoDatabase>(context, listen: false)
              .updateUser(_infoUser);
          Provider.of<TrueFalse>(context, listen: false)
              .changeStateBooling(false);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SplashScreen()));
        }
        else if (!snapshot.exists){
          refuser.child(currentUser!.uid).set({
            "userId": currentUser!.uid,
            "imageProfile": "",
            "firstName": "",
            "lastName": "",
            "email": email,
            "pass":pass,
            "phoneNumber": "",
            "country": "",
            "status": "info",
            "update": false
          }).whenComplete(() async {
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
            await Future.delayed(const Duration(milliseconds: 100));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserInfoScreen()));
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      if(e.code=="wrong-password"){
        _tools.toastMsg(AppLocalizations.of(context)!.passWrong);
        Provider.of<TrueFalse>(context, listen: false)
            .changeStateBooling(false);
      }
     else if (e.code == 'user-not-found') {
        try {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email, password: pass);
          await getCurrentUserId();
          currentUser = userCredential.user!;
          if (currentUser!.uid.isNotEmpty) {
            refuser.child(currentUser!.uid).set({
              "userId": currentUser!.uid,
              "imageProfile": "",
              "firstName": "",
              "lastName": "",
              "email": email,
              "pass":pass,
              "phoneNumber": "",
              "country": "",
              "status": "info",
              "update": false
            }).whenComplete(() async {
              Provider.of<TrueFalse>(context, listen: false)
                  .changeStateBooling(false);
              await Future.delayed(const Duration(milliseconds: 100));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoScreen()));
              Provider.of<TrueFalse>(context, listen: false)
                  .changeStateBooling(false);
            });
          }
        } on FirebaseAuthException catch (e) {
          e.toString();
          _tools.toastMsg(AppLocalizations.of(context)!.wrong);
        } catch (e) {
          _tools.toastMsg(AppLocalizations.of(context)!.wrong);
          Provider.of<TrueFalse>(context, listen: false)
              .changeStateBooling(false);
          e.toString();
        }
      }
    }
  }

  Future<User> getCurrentUserId() async {
    currentUser = auth.currentUser!;
    return currentUser!;
  }

  Future<void> deleteAccount(BuildContext context) async {
    User _user = auth.currentUser!;
   final delUser =  refuser.child(_user.uid);
    delUser.onDisconnect();
    await delUser.remove();
    _tools.toastMsg("deleted don");
    _tools.toastMsg("for finishing delete your account exit from app");
    // await _user.delete();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(_)=>const AuthScreen()), (route) => false);
  }
}
