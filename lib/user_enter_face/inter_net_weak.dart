import 'package:flutter/material.dart';
import 'package:gd_passenger/user_enter_face/splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../repo/auth_srv.dart';
import '../repo/data_base_srv.dart';

class InterNetWeak extends StatelessWidget {
  const InterNetWeak({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Lottie.asset('assets/12907-no-connection.json',
                  height: 250, width: 250)),
          Center(
            child: Text(
              AppLocalizations.of(context)!.interNetWeak,
              style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () async {
              if (AuthSev().auth.currentUser?.uid != null) {
                await DataBaseSrv().currentOnlineUserInfo(context).whenComplete(
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SplashScreen())));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()));
              }
            },
            child: Container(
              height: 40,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.try1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
