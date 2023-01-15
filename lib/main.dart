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
import 'package:wakelock/wakelock.dart';
import 'my_provider/carTypeBook_provider.dart';
import 'my_provider/city_provider.dart';
import 'my_provider/close_botton_driverInfo.dart';
import 'my_provider/country_provider.dart';
import 'my_provider/indector_netWeekPro.dart';
import 'my_provider/indector_profile_screen.dart';
import 'my_provider/nearsert_driver_provider.dart';
import 'my_provider/positon_driver_info_provide.dart';
import 'my_provider/profile_sheet.dart';
import 'my_provider/rider_id.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'my_provider/sheet_cardsc.dart';
import 'my_provider/timeTrip_statusRide.dart';
import 'my_provider/userinfo_sheet_provider.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Wakelock.enable();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  runApp(const MyApp());
}
// last update 16-1-2023
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
        ChangeNotifierProvider(
            create: (context) => PositionDriverInfoProvider()),
        ChangeNotifierProvider(create: (context) => NearestDriverProvider()),
        ChangeNotifierProvider(create: (context) => CloseButtonProvider()),
        ChangeNotifierProvider(create: (context) => RiderId()),
        ChangeNotifierProvider(create: (context) => UserInfoSheet()),
        ChangeNotifierProvider(create: (context) => ProfileSheet()),
        ChangeNotifierProvider(create: (context) => SheetCarDesc()),
        ChangeNotifierProvider(create: (context) => CountryProvider()),
        ChangeNotifierProvider(create: (context) => CityProvider()),
        ChangeNotifierProvider(create: (context) => CarTypeBook()),
        ChangeNotifierProvider(create: (context) => IndectorNetWeek()),
        ChangeNotifierProvider(create: (context) => TimeTripStatusRide()),
      ],
      builder: (context, _) {
        return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GD Passenger',
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''), // English, no country code
              Locale('ar', ''), // Arabic, no country code
              Locale('tr', ''), // Turkish, no country code
            ],
            home: SplashScreen());
      },
    );
  }
}
