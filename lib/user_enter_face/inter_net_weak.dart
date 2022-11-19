import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gd_passenger/user_enter_face/page_view.dart';
import 'package:gd_passenger/user_enter_face/splash_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../my_provider/indector_netWeekPro.dart';
import '../repo/auth_srv.dart';
import '../repo/data_base_srv.dart';
import '../widget/custom_circuler.dart';

class InterNetWeak extends StatefulWidget {
  const InterNetWeak({Key? key}) : super(key: key);

  @override
  State<InterNetWeak> createState() => _InterNetWeakState();
}

class _InterNetWeakState extends State<InterNetWeak> {
  late StreamSubscription<InternetConnectionStatus> listener;

  @override
  void initState() {
    checkNet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool valIndector = Provider.of<IndectorNetWeek>(context).val;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Column(
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
              // GestureDetector(
              //   onTap: () async {
              //     if (AuthSev().auth.currentUser?.uid != null) {
              //       await DataBaseSrv().currentOnlineUserInfo(context).whenComplete(
              //           () => Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (_) => const SplashScreen())));
              //     } else {
              //       return;
              //     }
              //   },
              //   child: Container(
              //     height: 40,
              //     width: 110,
              //     decoration: BoxDecoration(
              //       color: Colors.red.shade700,
              //       borderRadius: BorderRadius.circular(4.0),
              //     ),
              //     child: Center(
              //       child: Text(
              //         AppLocalizations.of(context)!.try1,
              //         textAlign: TextAlign.center,
              //         style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 16.0,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          valIndector == true
              ? CircularInductorCostem().circularInductorCostem(context)
              : const Text(''),
        ],
      ),
    ));
  }

  Future<void> checkNet() async {
    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) async {
        switch (status) {
          case InternetConnectionStatus.connected:
            if (AuthSev().auth.currentUser?.uid != null) {
              listener.cancel();
              await DataBaseSrv()
                  .currentOnlineUserInfo(context)
                  .whenComplete(() {
                Provider.of<IndectorNetWeek>(context, listen: false)
                    .updateState(false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()));
              });
            } else if (AuthSev().auth.currentUser?.uid == null) {
              listener.cancel();
              Provider.of<IndectorNetWeek>(context, listen: false)
                  .updateState(false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MyPageView()));
            }
            break;
          case InternetConnectionStatus.disconnected:
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }
}
