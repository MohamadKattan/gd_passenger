// this class include tools will use many times in our app
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config.dart';
import '../google_map_methods.dart';
import '../my_provider/car_tupy_provider.dart';
import '../my_provider/google_set_provider.dart';
import '../my_provider/lineTaxiProvider.dart';
import '../my_provider/opictyProvider.dart';
import '../my_provider/timeTrip_statusRide.dart';
import '../my_provider/true_false.dart';
import '../repo/api_srv_dir.dart';
import 'geoFire_methods_tools.dart';

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
    var carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    var tripDirection =
        Provider.of<GoogleMapSet>(context, listen: false).tripDirectionDetail;
    String? result;

    if (tripDirection != null) {
      switch (carTypePro) {
        case "Taxi-4 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirection, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.taxi;
          break;
      }
    }

    return result ?? AppLocalizations.of(context)!.taxi;
  }

  String amountOrCarTypeVeto(BuildContext context) {
    var carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    var tripDirection =
        Provider.of<GoogleMapSet>(context, listen: false).tripDirectionDetail;
    String? result;
    if (tripDirection != null) {
      switch (carTypePro) {
        case "Medium commercial-6-10 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirection, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.mediumCommercial;
          break;
      }
    }
    return result ?? AppLocalizations.of(context)!.mediumCommercial;
  }

  String amountOrCarTypeVan(BuildContext context) {
    var carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    var tripDirection =
        Provider.of<GoogleMapSet>(context, listen: false).tripDirectionDetail;
    String? result;
    if (tripDirection != null) {
      switch (carTypePro) {
        case "Big commercial-11-19 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirection, carTypePro!, context)} ${currencyTypeCheck(context)}";
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
    var carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    var tripDirection =
        Provider.of<GoogleMapSet>(context, listen: false).tripDirectionDetail;
    String? result;

    if (tripDirection != null) {
      switch (carTypePro) {
        case "Taxi-4 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirection, carTypePro!, context) + (ApiSrvDir.calculateFares1(tripDirection, carTypePro, context) * 0.10).floor()} ${currencyTypeCheck(context)}";
          break;
        default:
          result = "4";
          break;
      }
    }

    return result ?? "4";
  }

  String amountOrCarTypeVetoDiscount(BuildContext context) {
    var carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    var tripDirection =
        Provider.of<GoogleMapSet>(context, listen: false).tripDirectionDetail;
    String? result;
    if (tripDirection != null) {
      switch (carTypePro) {
        case "Medium commercial-6-10 seats":
          result = result =
              "${ApiSrvDir.calculateFares1(tripDirection, carTypePro!, context) + (ApiSrvDir.calculateFares1(tripDirection, carTypePro, context) * 0.10).floor()} ${currencyTypeCheck(context)}";
          break;
        default:
          result = "6-10";
          break;
      }
    }
    return result ?? "6-10";
  }

  String amountOrCarTypeVanDiscount(BuildContext context) {
    var carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    var tripDirection =
        Provider.of<GoogleMapSet>(context, listen: false).tripDirectionDetail;
    String? result;
    if (tripDirection != null) {
      switch (carTypePro) {
        case "Big commercial-11-19 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirection, carTypePro!, context) + (ApiSrvDir.calculateFares1(tripDirection, carTypePro, context) * 0.10).floor()} ${currencyTypeCheck(context)}";
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
    var trueFalseState = Provider.of<TrueFalse>(context, listen: false);
    var lineTaxiState = Provider.of<LineTaxi>(context, listen: false);
    var opacityChangState = Provider.of<OpacityChang>(context, listen: false);
    var tripDirection = Provider.of<GoogleMapSet>(context, listen: false);
    carOrderType = "Taxi-4 seats";
    autoChangeColor = 0;
    lineTaxiState.changelineTaxi(true);
    lineTaxiState.changelineVan(false);
    lineTaxiState.changelineVeto(false);
    opacityChangState.changOpacityTaxi(true);
    opacityChangState.changOpacityVan(false);
    opacityChangState.changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Taxi-4 seats");
    if (tripDirection.tripDirectionDetail != null) {
      trueFalseState.taxiDiscount(true);
      trueFalseState.vetoDiscount(false);
      trueFalseState.vanDiscount(false);
      trueFalseState.updateColorTextInRowTaxi(true);
      trueFalseState.updateColorTextInRowVeto(false);
      trueFalseState.updateColorTextInRowVan(false);
    }
  }

  // this method will change all provider state when click on van box
  void changeAllProClickVetoBox(BuildContext context) async {
    var trueFalseState = Provider.of<TrueFalse>(context, listen: false);
    var lineTaxiState = Provider.of<LineTaxi>(context, listen: false);
    var opacityChangState = Provider.of<OpacityChang>(context, listen: false);
    var tripDirection = Provider.of<GoogleMapSet>(context, listen: false);
    carOrderType = "Medium commercial-6-10 seats";
    autoChangeColor = 1;
    lineTaxiState.changelineVan(true);
    lineTaxiState.changelineTaxi(false);
    lineTaxiState.changelineVeto(false);
    opacityChangState.changOpacityVan(true);
    opacityChangState.changOpacityTaxi(false);
    opacityChangState.changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Medium commercial-6-10 seats");
    if (tripDirection.tripDirectionDetail != null) {
      trueFalseState.taxiDiscount(false);
      trueFalseState.vetoDiscount(true);
      trueFalseState.vanDiscount(false);
      trueFalseState.updateColorTextInRowTaxi(false);
      trueFalseState.updateColorTextInRowVeto(true);
      trueFalseState.updateColorTextInRowVan(false);
    }
  }

  // this method will change all provider state when click on Veto box
  void changeAllProClickVanBox(BuildContext context) async {
    var trueFalseState = Provider.of<TrueFalse>(context, listen: false);
    var lineTaxiState = Provider.of<LineTaxi>(context, listen: false);
    var opacityChangState = Provider.of<OpacityChang>(context, listen: false);
    var tripDirection = Provider.of<GoogleMapSet>(context, listen: false);
    carOrderType = "Big commercial-11-19 seats";
    autoChangeColor = 2;
    lineTaxiState.changelineVeto(true);
    lineTaxiState.changelineVan(false);
    lineTaxiState.changelineTaxi(false);
    opacityChangState.changOpacityVeto(true);
    opacityChangState.changOpacityVan(false);
    opacityChangState.changOpacityTaxi(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Big commercial-11-19 seats");
    if (tripDirection.tripDirectionDetail != null) {
      trueFalseState.taxiDiscount(false);
      trueFalseState.vetoDiscount(false);
      trueFalseState.vanDiscount(true);
      trueFalseState.updateColorTextInRowTaxi(false);
      trueFalseState.updateColorTextInRowVeto(false);
      trueFalseState.updateColorTextInRowVan(true);
    }
  }

  // this method for change color price auto if user didn't click an type of color and dirDetails not null
  void changeAutoPriceColor(BuildContext context) {
    switch (autoChangeColor) {
      case 0:
        Provider.of<TrueFalse>(context, listen: false).taxiDiscount(true);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowTaxi(true);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVeto(false);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVan(false);
        break;
      case 1:
        Provider.of<TrueFalse>(context, listen: false).vetoDiscount(true);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowTaxi(false);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVeto(true);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVan(false);
        break;
      case 2:
        Provider.of<TrueFalse>(context, listen: false).vanDiscount(true);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowTaxi(false);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVeto(false);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVan(true);
        break;
      default:
        Provider.of<TrueFalse>(context, listen: false).taxiDiscount(true);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowTaxi(true);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVeto(false);
        Provider.of<TrueFalse>(context, listen: false)
            .updateColorTextInRowVan(false);
        break;
    }
  }

  // this method for clean req after cancel
  Future<void> restApp(BuildContext context) async {
    await Geofire.stopListener();
    var trueFalseState = Provider.of<TrueFalse>(context, listen: false);
    var lineTaxiState = Provider.of<LineTaxi>(context, listen: false);
    var opacityChangState = Provider.of<OpacityChang>(context, listen: false);
    var googleMapState = Provider.of<GoogleMapSet>(context, listen: false);

    if (rideStreamSubscription != null) {
      rideStreamSubscription?.cancel();
      rideStreamSubscription = null;
    }
    driverAvailable.clear();
    GeoFireMethods.listOfNearestDriverAvailable.clear();
    updateDriverOnMap = true;
    openCollectMoney = false;
    sound1 = false;
    sound2 = false;
    sound3 = false;
    driverCanceledAfterAccepted = false;
    noChangeToTaxi = false;
    trueFalseState.taxiDiscount(false);
    trueFalseState.vetoDiscount(false);
    trueFalseState.vanDiscount(false);
    trueFalseState.updateShowCancelBord(false);
    trueFalseState.updateShowDriverIfo(false);
    trueFalseState.updateColorTextInRowTaxi(false);
    trueFalseState.updateColorTextInRowVeto(false);
    trueFalseState.updateColorTextInRowVan(false);
    lineTaxiState.changelineTaxi(true);
    lineTaxiState.changelineVan(false);
    lineTaxiState.changelineVeto(false);
    opacityChangState.changOpacityTaxi(true);
    opacityChangState.changOpacityVan(false);
    opacityChangState.changOpacityVeto(false);
    googleMapState.updateTripDirectionDetail(null);
    googleMapState.polylineSet.clear();
    googleMapState.markersSet.clear();
    googleMapState.circlesSet.clear();
    googleMapState.polylineCoordinate.clear();
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Taxi-4 seats");
    after2MinTimeOut = 200;
    rideRequestTimeOut = 30;
    fNameIcon = "";
    lNameIcon = "";
    waitDriver = "wait";
    state = "normal";
    geoFireRadios = 2;
    statusRide = "";
    newstatusRide = "";
    carDriverInfo = "";
    driverName = "";
    driverImage = "";
    driverPhone = "";
    timeTrip = "";
    driverId = "";
    titleRate = "";
    rating = 0.0;
    headDriverInTrip = 0.0;
    carRideType = "";
    carOrderType = "Taxi-4 seats";
    tourismCityName = "";
    tourismCityPrice = "";
    driverNewLocation = const LatLng(0.0, 0.0);
    await LogicGoogleMap().locationPosition(context);
    await LogicGoogleMap().geoFireInitialize(context);
  }
}
