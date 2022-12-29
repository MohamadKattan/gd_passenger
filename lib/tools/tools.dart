// this class include tools will use many times in our app
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Tools {
  void toastMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget timerAuth(BuildContext context) {
    final CountDownController downController = CountDownController();
    return CircularCountDownTimer(
      duration: 120,
      initialDuration: 0,
      controller: downController,
      width: MediaQuery.of(context).size.width / 9,
      height: MediaQuery.of(context).size.height / 9,
      ringColor: Colors.white,
      fillColor: Colors.black12,
      backgroundColor: const Color(0xFFFFD54F),
      strokeWidth: 8.0,
      strokeCap: StrokeCap.round,
      textStyle: const TextStyle(
          fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.S,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: true,
      onStart: () {},
      onComplete: () {},
    );
  }

  Future<void> lunchUrl(BuildContext context, String url) async {
    await canLaunch(url)
        ? launch(url)
        : Tools().toastMsg(AppLocalizations.of(context)!.wrong);
  }

  Route createRoute(BuildContext context, Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.ease;
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
