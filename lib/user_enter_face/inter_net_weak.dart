import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gd_passenger/user_enter_face/page_view.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../my_provider/indector_netWeekPro.dart';
import '../repo/auth_srv.dart';
import '../repo/data_base_srv.dart';
import '../widget/custom_widgets.dart';

class InterNetWeak extends StatefulWidget {
  final int timeNet;
  const InterNetWeak({Key? key, required this.timeNet}) : super(key: key);

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
            ],
          ),
          valIndector == true
              ? CustomWidgets().circularInductorCostem(context)
              : const SizedBox(),
        ],
      ),
    ));
  }

  Future<void> checkNet() async {
    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) async {
        switch (status) {
          case InternetConnectionStatus.connected:
            await Future.delayed(Duration(seconds: widget.timeNet));
            if (AuthSev().auth.currentUser?.uid != null) {
              listener.cancel();
              await DataBaseSrv().currentOnlineUserInfoInNet(context);
              Provider.of<IndectorNetWeek>(context, listen: false)
                  .updateState(false);
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
