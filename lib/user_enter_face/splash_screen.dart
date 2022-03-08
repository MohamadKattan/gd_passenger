import 'package:flutter/material.dart';
import 'package:gd_passenger/repo/auth_srv.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
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
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
        lowerBound: 0.8,
        upperBound: 0.9);
    _animationController.forward();
    _animationController.addStatusListener((status) async{
      if (status == AnimationStatus.completed) {
        Navigator.push(
          context,
       await   MaterialPageRoute(builder: (context) {
            if (AuthSev().auth.currentUser?.uid != null) {
              DataBaseSrv().currentOnlineUserInfo(context);
              return HomeScreen();
            } else {
              return AuthScreen();
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
      backgroundColor: Color(0xFFFFD54F),
      body: SafeArea(
        child: ScaleTransition(
          scale: _animationController,
          child: SizedBox(
            height: _height,
            width: _width,
            child: Container(
                color: Color(0xFFFFD54F),
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
