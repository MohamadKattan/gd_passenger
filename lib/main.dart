import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
import 'package:gd_passenger/my_provider/derictionDetails_provide.dart';
import 'package:gd_passenger/my_provider/double_value.dart';
import 'package:gd_passenger/my_provider/lineTaxiProvider.dart';
import 'package:gd_passenger/my_provider/opictyProvider.dart';
import 'package:gd_passenger/my_provider/pick_image_provider.dart';
import 'package:gd_passenger/my_provider/placeDetails_drop_provider.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/repo/auth_srv.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gd_passenger/user_enter_face/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  FlutterNativeSplash.removeAfter(initialization);
  await Firebase.initializeApp();
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
    AuthSev authSev = AuthSev();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TrueFalse()),
        ChangeNotifierProvider(create: (context) => DoubleValue()),
        ChangeNotifierProvider(create: (context) => UserIdProvider()),
        ChangeNotifierProvider(create: (context) => PickImageProvide()),
        ChangeNotifierProvider(create: (context) => LineTaxi()),
        ChangeNotifierProvider(create: (context) => OpacityChang()),
        ChangeNotifierProvider(create: (context) => PositionChang()),
        ChangeNotifierProvider(create: (context) => AppData()),
        ChangeNotifierProvider(create: (context) => PlaceDetailsDropProvider()),
        ChangeNotifierProvider(create: (context) => DerictionDetails()),
      ],
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GD Passenger',
          home: FutureBuilder(
            future: authSev.getCurrentUserId(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return AuthScreen();
              }
            },
          ),
        );
      },
    );
  }
}
