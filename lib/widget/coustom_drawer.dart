import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/user_enter_face/profile_screen.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../tools/carousel_slider.dart';
import '../user_enter_face/book_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget customDrawer(BuildContext context) {
  double rightVal = MediaQuery.of(context).size.width * 25 / 100;
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFFFFD54F),
        Color(0xFFFFD55F),
        Color(0xFFFFD56F),
        Color(0xFFFFD57F),
      ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DrawerHeader(
          child: Padding(
            padding: EdgeInsets.only(
                left: AppLocalizations.of(context)!.hi == "مرحبا" ? 0.0 : 80.0,
                right:
                    AppLocalizations.of(context)!.hi == "مرحبا" ? 120.0 : 0.0),
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
        Column(
          children: [
            const SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: AppLocalizations.of(context)!.hi == "مرحبا"
                      ? rightVal
                      : 8.0,
                  left: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingScreen())),
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
            const SizedBox(
              height: 8.0,
            ),
            CustomWidget().customDivider(),
            Padding(
              padding: EdgeInsets.only(
                  left: 8.0,
                  right: AppLocalizations.of(context)!.hi == "مرحبا"
                      ? rightVal
                      : 8.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen())),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Icon(Icons.person, color: Colors.black45, size: 35),
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
            const SizedBox(
              height: 8.0,
            ),
            CustomWidget().customDivider(),
            Padding(
              padding: EdgeInsets.only(
                  left: 8.0,
                  right: AppLocalizations.of(context)!.hi == "مرحبا"
                      ? rightVal
                      : 8.0),
              child: GestureDetector(
                onTap: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  }
                  exit(0);
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
            CustomWidget().customDivider(),
            ImageSliderDemo(),
            Padding(
              padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  bottom: 8.0,
                  right: AppLocalizations.of(context)!.hi == "مرحبا"
                      ? 120.0
                      : 8.0),
              child: const Text(
                "Garanti taxi v1.0.0",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    ),
  );
}

Widget showImage(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime.imageProfile != null
      ? Expanded(
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
            errorWidget: (context, url, error) => const Icon(Icons.person),
          ),
        )
      : const Expanded(
          flex: 0,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black12,
              size: 35,
            ),
          ),
        );
}

Widget showUserName(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime.firstName != null
      ? Text(
          AppLocalizations.of(context)!.hi + " ${userInfoRealTime.firstName}")
      : Expanded(child: Text(AppLocalizations.of(context)!.welcomeBack));
}

Widget showUserPhone(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime.phoneNumber != null
      ? Text(userInfoRealTime.phoneNumber)
      : const Text("");
}
