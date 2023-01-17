import 'package:flutter/material.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../tools/tools.dart';

Widget pageViewContent(
    BuildContext context, String image, String title, PageController controller,
    {required bool? firstPage, required double? paddingBottom}) {
  return Stack(
    children: [
      Padding(
        padding: EdgeInsets.only(bottom: paddingBottom??10),
        child: Image.asset(
          image,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
      ),
      firstPage??false
          ?  Positioned(
        right: 5,
        top: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:const  [
              Text(
                "Wow !!",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color:Color(0xFFFBC408),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
              ),
              Text(
                "Up To",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color:Color(0xFFFBC408),
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "10%",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color:Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      )
      :const SizedBox(),
      firstPage??false
          ? Positioned(
              left: 0,
              right: 0,
              bottom: 95,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: Color(0xFF00A3E0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                height: 275,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF00A3E0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SmoothPageIndicator(
              controller: controller,
              count: 4,
              axisDirection: Axis.horizontal,
              effect: const WormEffect(
                activeDotColor: Color(0xFFFBC408),
              ),
            ),
          ),
        ),
      ),
      Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () => Navigator.of(context)
                    .push(Tools().createRoute(context, const AuthScreen())),
                child: Text(AppLocalizations.of(context)!.skip,
                    style: const TextStyle(
                        color: Color(0xFF00A3E0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          )),
    ],
  );
}
