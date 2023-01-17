import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../my_provider/buttom_color_pro.dart';
import '../my_provider/double_value.dart';
import '../tools/carousel_slider.dart';
import '../user_enter_face/advance_reservation.dart';
import '../user_enter_face/book_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../user_enter_face/support_screen.dart';
import 'custom_widgets.dart';

Widget customDrawer(BuildContext context) {
  double rightVal = MediaQuery.of(context).size.width * 25 / 100;
  return Stack(
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF00A3E0),
            Color(0xFF00A3E0),
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      ),
      DrawerHeader(
        child: Padding(
          padding: EdgeInsets.only(
              left: AppLocalizations.of(context)!.hi == "مرحبا" ? 0.0 : 80.0,
              right: AppLocalizations.of(context)!.hi == "مرحبا" ? 120.0 : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showImage(context),
              const SizedBox(
                height: 8.0,
              ),
              showUserName(context),
              showUserPhone(context),
            ],
          ),
        ),
      ),
      Positioned(
        top: 150,
        left: 0.0,
        right: 0.0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 4.0,
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: AppLocalizations.of(context)!.hi == "مرحبا"
                          ? rightVal
                          : 8.0,
                      left: 8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        Tools().createRoute(context, const BookingScreen())),
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.history,
                          color: Colors.black45,
                          size: 35,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!.book,
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ))
                    ]),
                  ),
                ),
              ),
              CustomWidgets().customDivider(),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: AppLocalizations.of(context)!.hi == "مرحبا"
                          ? rightVal
                          : 8.0,
                      left: 8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(Tools()
                        .createRoute(context, const AdvanceReservation())),
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.timer,
                          color: Colors.black45,
                          size: 35,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!.advanceReservation,
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ))
                    ]),
                  ),
                ),
              ),
              CustomWidgets().customDivider(),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0,
                      right: AppLocalizations.of(context)!.hi == "مرحبا"
                          ? rightVal
                          : 8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        Tools().createRoute(context, const ProfileScreen())),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person,
                              color: Colors.black45, size: 35),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!.profile,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomWidgets().customDivider(),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0,
                      right: AppLocalizations.of(context)!.hi == "مرحبا"
                          ? rightVal
                          : 8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        Tools().createRoute(context, const SupportScreen())),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.support,
                            color: Colors.black45,
                            size: 35.0,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!.support,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomWidgets().customDivider(),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0,
                      right: AppLocalizations.of(context)!.hi == "مرحبا"
                          ? rightVal
                          : 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      toPlayStore(context);
                    },
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.car_crash,
                            color: Colors.black45,
                            size: 35.0,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!.beDriver,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomWidgets().customDivider(),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.0,
                      right: AppLocalizations.of(context)!.hi == "مرحبا"
                          ? rightVal
                          : 8.0),
                  child: GestureDetector(
                    onTap: () {
                      singOut(context);
                    },
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.black45,
                            size: 35.0,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!.exit,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomWidgets().customDivider(),
              Expanded(flex: 0, child: ImageSliderDemo(context)),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                      bottom: 8.0,
                      right: AppLocalizations.of(context)!.hi == "مرحبا"
                          ? 120.0
                          : 50.0),
                  child: const Center(
                    child: Text(
                      "Garanti taxi v1.0.0",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}

// this method for go to driver app
Future<void> toPlayStore(BuildContext context) async {
  if (Platform.isAndroid) {
    String _url =
        'https://play.google.com/store/apps/details?id=com.garanti.garantitaxidriver&hl=tr';
    await Tools().lunchUrl(context, _url);
  } else {
    String _url =
        'https://apps.apple.com/tr/app/garantitaxi-driver/id1635534414';
    await Tools().lunchUrl(context, _url);
  }
}

// this method for exit from app without sing out
void singOut(BuildContext context) {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else {
    Provider.of<DoubleValue>(context, listen: false).value0Or1(0);
    Provider.of<ChangeColor>(context, listen: false).updateState(false);
  }
}

// image user
Widget showImage(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return Expanded(
    child: CachedNetworkImage(
      imageBuilder: (context, imageProvider) => Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      imageUrl: userInfoRealTime.imageProfile,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25,
          child: Icon(
            Icons.person,
            color: Colors.grey,
          )),
    ),
  );
}

//name user
Widget showUserName(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime.firstName.isNotEmpty
      ? Text(
          AppLocalizations.of(context)!.hi + " ${userInfoRealTime.firstName}")
      : Expanded(child: Text(AppLocalizations.of(context)!.welcomeBack));
}

//phone user
Widget showUserPhone(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime.phoneNumber.isNotEmpty
      ? Text(userInfoRealTime.phoneNumber)
      : const Text("");
}
