import 'package:flutter/material.dart';
import 'package:gd_passenger/repo/auth_srv.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/tools/turn_Gps.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:gd_passenger/user_enter_face/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    TurnGps().turnGpsIfNot();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
        lowerBound: 0.4,
        upperBound: 0.6);
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            if (AuthSev().auth.currentUser?.uid != null) {
              DataBaseSrv().currentOnlineUserInfo(context);
              return const HomeScreen();
            } else {
              return const AuthScreen();
            }
          }),
        );
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
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
}
