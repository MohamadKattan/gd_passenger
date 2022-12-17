import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/repo/auth_srv.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/tools/turn_Gps.dart';
import 'package:gd_passenger/user_enter_face/page_view.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../google_map_methods.dart';
import '../my_provider/indector_netWeekPro.dart';
import '../my_provider/info_user_database_provider.dart';
import '../tools/tools.dart';
import 'home_screen.dart';
import 'inter_net_weak.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool result = false;
  @override
  initState() {
      checkInternet();
      TurnGps().turnGpsIfNot();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds:2000),
        lowerBound: 0.3,
        upperBound: 0.4);
    _animationController.forward();
    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // await checkInternet();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF00A3E0),
      body: SafeArea(
        child: ScaleTransition(
          scale: _animationController,
          child: SizedBox(
            height: _height,
            width: _width,
            child: Container(
                color: const Color(0xFF00A3E0),
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
      await canLaunch(
              "https://apps.apple.com/tr/app/garanti-taxi/id1633389274?l=tr")
          ? launch(
              "https://apps.apple.com/tr/app/garanti-taxi/id1633389274?l=tr")
          : Tools().toastMsg('Could not launch');
    }
  }

  // this method for check internet
  Future<void> checkInternet() async {
    result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      Provider.of<IndectorNetWeek>(context, listen: false).updateState(true);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InterNetWeak(timeNet:8)));
    }
    else{
      if (AuthSev().auth.currentUser?.uid == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const MyPageView()));
      }
      else{
        if (AuthSev().auth.currentUser?.uid != null) {
          await DataBaseSrv().currentOnlineUserInfo(context).whenComplete(() async {
            await Future.delayed(const Duration(seconds: 2)).whenComplete(() async {
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                  }
                });
              }
              else{await DataBaseSrv().checkStateUserInfo(context);}
            });
          });
        }}
    }
  }
}
