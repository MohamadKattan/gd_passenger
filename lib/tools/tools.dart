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
import '../my_provider/timeTrip_statusRide.dart';
import '../my_provider/true_false.dart';
import '../repo/api_srv_dir.dart';

class Tools {
  void toastMsg(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> lunchUrl(BuildContext context, String url) async {
    Uri _url = Uri.parse(url);
    await canLaunchUrl(_url)
        ? launchUrl(_url, mode: LaunchMode.externalApplication)
        : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
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

// this method for display currencyType
  String currencyTypeCheck(BuildContext context) {
    var _currencyType =
        Provider.of<TimeTripStatusRide>(context, listen: false).currencyType;
    return _currencyType;
  }

  // this methods if dir Details != null amount or carType
  String amountOrCarTypeTaxi(BuildContext context) {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;

    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Taxi-4 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.taxi;
          break;
      }
    }

    return result ?? AppLocalizations.of(context)!.taxi;
  }

  String amountOrCarTypeVeto(BuildContext context) {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;
    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Medium commercial-6-10 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.mediumCommercial;
          break;
      }
    }
    return result ?? AppLocalizations.of(context)!.mediumCommercial;
  }

  String amountOrCarTypeVan(BuildContext context) {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;
    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Big commercial-11-19 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.bigCommercial;
          break;
      }
    }
    return result ?? AppLocalizations.of(context)!.bigCommercial;
  }

  // this method if dir Details != null amount with discount or or number of seats
  String amountOrCarTypeTaxiDiscount(BuildContext context) {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;

    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Taxi-4 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context) + (ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro, context) * 0.10).floor()} ${currencyTypeCheck(context)}";
          break;
        default:
          result = "4";
          break;
      }
    }

    return result ?? "4";
  }

  String amountOrCarTypeVetoDiscount(BuildContext context) {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;
    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Medium commercial-6-10 seats":
          result = result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context) + (ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro, context) * 0.10).floor()} ${currencyTypeCheck(context)}";
          break;
        default:
          result = "6-10";
          break;
      }
    }
    return result ?? "6-10";
  }

  String amountOrCarTypeVanDiscount(BuildContext context) {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;
    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Big commercial-11-19 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context) + (ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro, context) * 0.10).floor()} ${currencyTypeCheck(context)}";
          break;
        default:
          result = "11-19";
          break;
      }
    }
    return result ?? "11-19";
  }

  // this method for change all provider state when click taxiBox
  void changeAllProClickTaxiBox(BuildContext context) async {
    carOrderType = "Taxi-4 seats";
    Provider.of<TrueFalse>(context, listen: false).taxiDiscount(true);
    Provider.of<TrueFalse>(context, listen: false).vetoDiscount(false);
    Provider.of<TrueFalse>(context, listen: false).vanDiscount(false);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Taxi-4 seats");
    if (tripDirectionDetails != null) {
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowTaxi(true);
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowVeto(false);
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowVan(false);
    }
  }

  // this method will change all provider state when click on van box
  void changeAllProClickVetoBox(BuildContext context) async {
    carOrderType = "Medium commercial-6-10 seats";
    Provider.of<TrueFalse>(context, listen: false).taxiDiscount(false);
    Provider.of<TrueFalse>(context, listen: false).vetoDiscount(true);
    Provider.of<TrueFalse>(context, listen: false).vanDiscount(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(true);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Medium commercial-6-10 seats");
    if (tripDirectionDetails != null) {
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowTaxi(false);
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowVeto(true);
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowVan(false);
    }
  }

  // this method will change all provider state when click on Veto box
  void changeAllProClickVanBox(BuildContext context) async {
    carOrderType = "Big commercial-11-19 seats";
    Provider.of<TrueFalse>(context, listen: false).taxiDiscount(false);
    Provider.of<TrueFalse>(context, listen: false).vetoDiscount(false);
    Provider.of<TrueFalse>(context, listen: false).vanDiscount(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Big commercial-11-19 seats");
    if (tripDirectionDetails != null) {
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowTaxi(false);
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowVeto(false);
      Provider.of<TrueFalse>(context, listen: false)
          .updateColorTextInRowVan(true);
    }
  }
}
