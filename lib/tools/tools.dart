// this class include tools will use many times in our app
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config.dart';
import '../my_provider/car_tupy_provider.dart';
import '../my_provider/lineTaxiProvider.dart';
import '../my_provider/opictyProvider.dart';

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

  Future<void> lunchUrl(BuildContext context, String url) async {
    Uri _url = Uri.parse(url);
    await canLaunchUrl(_url)
        ? launchUrl(_url, mode: LaunchMode.externalApplication)
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

  // this method for change all provider state when click taxiBox
  void changeAllProClickTaxiBox(BuildContext context) async {
    // markersSet.clear();
    // GeoFireMethods.listOfNearestDriverAvailable.clear();
    // geoFireInitialize();
    carOrderType = "Taxi-4 seats";
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Taxi-4 seats");
  }

  // this method will change all provider state when click on van box
  void changeAllProClickVanBox(BuildContext context) async {
    carOrderType = "Medium commercial-6-10 seats";
    Provider.of<LineTaxi>(context, listen: false).changelineVan(true);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Medium commercial-6-10 seats");
  }

  // this method will change all provider state when click on Veto box
  void changeAllProClickVetoBox(BuildContext context) async {
    carOrderType = "Big commercial-11-19 seats";
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Big commercial-11-19 seats");
  }
}
