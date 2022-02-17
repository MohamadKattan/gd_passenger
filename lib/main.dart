import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  FlutterNativeSplash.removeAfter(initialization);
  FirebaseApp defaultApp = await Firebase.initializeApp();
  runApp(const MyApp());
}
// this method for native splash screen
void initialization(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 3));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GD Passenger',
      home: AuthScreen(),
    );
  }
}


