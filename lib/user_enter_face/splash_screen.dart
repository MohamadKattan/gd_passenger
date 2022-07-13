import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/repo/auth_srv.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/tools/turn_Gps.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:gd_passenger/user_enter_face/user_info_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../my_provider/info_user_database_provider.dart';
import '../tools/tools.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  initState() {
    TurnGps().turnGpsIfNot();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        lowerBound: 0.5,
        upperBound: 0.6);
    _animationController.forward();
    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if (AuthSev().auth.currentUser?.uid == null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AuthScreen()));
        } else if (AuthSev().auth.currentUser?.uid != null) {
          await DataBaseSrv().currentOnlineUserInfo(context);
          final infoUser =
              Provider.of<UserAllInfoDatabase>(context, listen: false).users;
          if (infoUser.update == true) {
            await goToPlayStore().whenComplete(() async {
              DatabaseReference refuser = FirebaseDatabase.instance
                  .ref()
                  .child("users")
                  .child(infoUser.userId);
              await refuser.child("update").set(false);
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            });
          } else if (infoUser.status == "") {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AuthScreen()));
          } else if (infoUser.status == "info") {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const UserInfoScreen()));
          } else if (infoUser.status == "ok") {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFDD44F),
      body: SafeArea(
        child: ScaleTransition(
          scale: _animationController,
          child: SizedBox(
            height: _height,
            width: _width,
            child: Container(
                color: const Color(0xFFFFD54F),
                child: Image.asset("assets/splash.png")),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  // this method for go to play Store
  Future<void> goToPlayStore() async {
    if (Platform.isAndroid) {
      await canLaunch(
              "https://play.google.com/store/apps/details?id=com.garantidriver.garantitaxi")
          ? launch(
              "https://play.google.com/store/apps/details?id=com.garantidriver.garantitaxi")
          : Tools().toastMsg('Could not launch');
    } else {
      await canLaunch("https://apps.apple.com/tr/app/garanti-taxi/id1633389274?l=tr")
          ? launch("https://apps.apple.com/tr/app/garanti-taxi/id1633389274?l=tr")
          : Tools().toastMsg('Could not launch');
    }
  }
}
