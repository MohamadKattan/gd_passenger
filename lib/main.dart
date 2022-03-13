import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
import 'package:gd_passenger/my_provider/buttom_color_pro.dart';
import 'package:gd_passenger/my_provider/car_tupy_provider.dart';
import 'package:gd_passenger/my_provider/derictionDetails_provide.dart';
import 'package:gd_passenger/my_provider/double_value.dart';
import 'package:gd_passenger/my_provider/dropBottom_value.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/my_provider/lineTaxiProvider.dart';
import 'package:gd_passenger/my_provider/opictyProvider.dart';
import 'package:gd_passenger/my_provider/pick_image_provider.dart';
import 'package:gd_passenger/my_provider/placeDetails_drop_provider.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/posotoion_cancel_request.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gd_passenger/user_enter_face/splash_screen.dart';
import 'package:provider/provider.dart';
import 'my_provider/indector_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
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
        ChangeNotifierProvider(create: (context) => DirectionDetailsPro()),
        ChangeNotifierProvider(create: (context) => DropBottomValue()),
        ChangeNotifierProvider(create: (context) => CarTypeProvider()),
        ChangeNotifierProvider(create: (context) => PositionCancelReq()),
        ChangeNotifierProvider(create: (context) => UserAllInfoDatabase()),
        ChangeNotifierProvider(create: (context) => InductorProfileScreen()),
        ChangeNotifierProvider(create: (context) => ChangeColor()),
      ],
      builder: (context, _) {
        return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GD Passenger',
            home: SplashScreen());
      },
    );
  }
}
//<bitmap android:gravity="center" android:src="@drawable/splash"/>