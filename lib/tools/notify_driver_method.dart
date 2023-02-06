import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config.dart';
import '../google_map_methods.dart';
import '../my_provider/app_data.dart';
import '../my_provider/car_tupy_provider.dart';
import '../my_provider/close_botton_driverInfo.dart';
import '../my_provider/google_set_provider.dart';
import '../my_provider/info_user_database_provider.dart';
import '../my_provider/placeDetails_drop_provider.dart';
import '../my_provider/position_v_chnge.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/posotoion_cancel_request.dart';
import '../my_provider/rider_id.dart';
import '../my_provider/timeTrip_statusRide.dart';
import '../my_provider/true_false.dart';
import '../my_provider/user_id_provider.dart';
import '../notification.dart';
import '../repo/api_srv_dir.dart';
import '../repo/data_base_srv.dart';
import '../widget/custom_widgets.dart';
import '../widget/rating_widget.dart';
import 'geoFire_methods_tools.dart';

class NotifyDriver {
  // this method for add all key driver in list for pushing to searchMethod
  Future<void> gotKeyOfDriver(
      UserIdProvider userProvider, BuildContext context) async {
    Provider.of<TrueFalse>(context, listen: false).updateShowCancelBord(true);
    // audioCache = AudioCache(fixedPlayer: audioPlayer, prefix: "assets/");
    List<String> keyList = [];
    driverAvailable = GeoFireMethods.listOfNearestDriverAvailable;
    for (var i in driverAvailable) {
      keyList.add(i.key);
    }
    keyDriverAvailable = LinkedHashSet<String>.from(keyList).toSet().toList();
    searchNearestDriver(userProvider, context);
  }

  // this method when rider will do order
  Future<void> searchNearestDriver(
      UserIdProvider userProvider, BuildContext context) async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref().child("driver");
    if (keyDriverAvailable.isEmpty) {
      await Geofire.stopListener();
      geoFireRadios = 2;
      final res = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              CustomWidgets().sorryNoDriverDialog(context, userProvider));
      if (res == 0) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                CustomWidgets().circularInductorCostem(context));
        Provider.of<PositionCancelReq>(context, listen: false)
            .updateValue(-400.0);
        Provider.of<PositionChang>(context, listen: false).changValue(0.0);
       // await LogicGoogleMap().locationPosition(context);
       await LogicGoogleMap().geoFireInitialize(context);
        Navigator.pop(context);
      }
    } else if (keyDriverAvailable.isNotEmpty) {
      String idDriver = keyDriverAvailable[0];
      await _ref
          .child(idDriver)
          .child("carInfo")
          .child("carType")
          .once()
          .then((value) async {
        final snap = value.snapshot.value;
        if (snap != null) {
          carRideType = snap.toString();
          if (carRideType == carOrderType) {
            await _ref
                .child(idDriver)
                .child("newRide")
                .once()
                .then((value) async {
              if (value.snapshot.value != null) {
                final newRideStatus = value.snapshot.value;
                if (newRideStatus == "searching") {
                  notifyDriver(idDriver, context, userProvider);
                  keyDriverAvailable.removeAt(0);
                } else {
                  keyDriverAvailable.removeAt(0);
                  searchNearestDriver(userProvider, context);
                }
              } else {
                keyDriverAvailable.removeAt(0);
                searchNearestDriver(userProvider, context);
              }
            });
          } else {
            keyDriverAvailable.removeAt(0);
            searchNearestDriver(userProvider, context);
          }
        } else {
          keyDriverAvailable.removeAt(0);
          searchNearestDriver(userProvider, context);
        }
      });
    }
  }

  // this method if driver in list of driver for sent notify after take his token
  Future<void> notifyDriver(String driverId, BuildContext context,
      UserIdProvider userProvider) async {
    DatabaseReference _driverRef =
        FirebaseDatabase.instance.ref().child("driver").child(driverId);
    rideRequestTimeOut = 30;
    late Timer _timer;
    await DataBaseSrv().sendRideRequestId(driverId, context);
    _driverRef.child("token").once().then((value) async {
      if (value.snapshot.value != null) {
        final snapshot = value.snapshot.value;
        String token = snapshot.toString();
        SendNotification().sendNotificationToDriver(context, token);
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      rideRequestTimeOut = rideRequestTimeOut - 1;
      // if rider cancel his order
      if (state != "requesting") {
        rideRequestTimeOut = 30;
        after2MinTimeOut = 200;
        _driverRef.child("newRide").set("canceled");
        _driverRef.child("newRide").onDisconnect();
        _timer.cancel();
        timer.cancel();
        // if time out of waiting driver
      } else if (rideRequestTimeOut <= 0) {
        _timer.cancel();
        timer.cancel();
        rideRequestTimeOut = 30;
        _driverRef.child("newRide").set("timeOut");
        _driverRef.child("newRide").onDisconnect();
        searchNearestDriver(userProvider, context);
      }
    });
    _driverRef.child("newRide").onValue.listen((event) async {
      if (event.snapshot.value.toString() == "accepted") {
        _driverRef.child("newRide").onDisconnect();
        _timer.cancel();
        waitDriver = "";
        rideRequestTimeOut = 30;
        after2MinTimeOut = 200;
        sound1 = true;
        sound2 = true;
        sound3 = true;
        openCollectMoney = true;
        driverCanceledAfterAccepted = true;
        isClicked = true;
        showDialog(
            context: context,
            builder: (context) =>
                CustomWidgets().circularInductorCostem(context));
        gotDriverInfo(context);
        Future.delayed(const Duration(seconds: 1)).whenComplete(() {
          Navigator.pop(context);
        });
      }
      // if driver has didn't accepted  this order
      if (event.snapshot.value.toString() == "canceled") {
        _driverRef.child("newRide").onDisconnect();
        rideRequestTimeOut = 1;
      }
    });
  }

  // this method for got driver info from Ride request collection
  Future<void> gotDriverInfo(BuildContext context) async {
    Provider.of<TrueFalse>(context, listen: false).updateShowDriverIfo(true);
    var id = Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    var carType = Provider.of<CarTypeProvider>(context, listen: false).carType;
    var googleMapState = Provider.of<GoogleMapSet>(context, listen: false);
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("Ride Request").child(id.userId);
    rideStreamSubscription = reference.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        return;
      } else {
        Map<String, dynamic> map =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        if (map["carInfo"] != null) {
          carDriverInfo = map["carInfo"].toString();
        }
        if (map["driverImage"] != null) {
          final newdriverImage = map["driverImage"].toString();
          driverImage = newdriverImage;
        }
        if (map["carPlack"] != null) {
          carPlack = map["carPlack"].toString();
        }
        if (map["driverName"] != null) {
          driverName = map["driverName"].toString();
        }
        if (map["driverPhone"] != null) {
          driverPhone = map["driverPhone"].toString();
        }
        if (map["status"] != null) {
          statusRide = map["status"].toString();
        }
        if (map["heading"] != null) {
          num val = map["heading"];
          headDriverInTrip = val.roundToDouble();
        }
        if (map["driverLocation"] != null) {
          final driverLatitude =
              double.parse(map["driverLocation"]["latitude"].toString());
          final driverLongitude =
              double.parse(map["driverLocation"]["longitude"].toString());
          LatLng driverCurrentLocation =
              LatLng(driverLatitude, driverLongitude);
          driverNewLocation = driverCurrentLocation;
          if (statusRide == "accepted") {
            Provider.of<PositionDriverInfoProvider>(context, listen: false)
                .updateState(0.0);
            Provider.of<PositionCancelReq>(context, listen: false)
                .updateValue(-400.0);
            newstatusRide = AppLocalizations.of(context)!.accepted;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
          } else if (statusRide == "arrived") {
            statusRide = "Driver arrived";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.arrived;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateTimeTrip(timeTrip);
            Provider.of<TrueFalse>(context, listen: false)
                .updateShowCancelBord(false);
            soundArrived(context);
          } else if (statusRide == "onride") {
            if (driverNewLocation.latitude != 0.0) {
              Marker marker = Marker(
                  markerId: MarkerId("myDriver$driverId"),
                  position: driverNewLocation,
                  icon: carType == "Taxi-4 seats"
                      ? googleMapState.driversNearIcon
                      : googleMapState.driversNearIcon1,
                  infoWindow: InfoWindow(
                      title: driverName,
                      snippet: AppLocalizations.of(context)!.onWay),
                  rotation: headDriverInTrip ?? 90.0);
              statusRide = "Trip Started";
              newstatusRide = AppLocalizations.of(context)!.started;
              Provider.of<TimeTripStatusRide>(context, listen: false)
                  .updateStatusRide(newstatusRide);
              updateTorRidePickToDropOff(context);
              googleMapState.updateMarkerOnMap(marker);
              // setState(() => markersSet.add(marker));
              // trickDriverCaronTrpe(driverNewLocation, marker);
            }
            soundTripStart(context);
          } else if (statusRide == "ended") {
            // updateDriverOnMap = true;
            statusRide = "Trip finished";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.finished;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateTimeTrip(timeTrip);
            googleMapState.deleteDriverOnMap("myDriver$driverId");
            // markersSet.removeWhere(
            //     (ele) => ele.markerId.value.contains("myDriver$driverId"));
            if (map["total"] != null) {
              int fare = int.parse(map["total"].toString());
              if (openCollectMoney) {
                openCollectMoney = false;
                var res = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CustomWidgets().collectMoney(context, fare);
                    });
                if (res == "close") {
                  if (map["driverId"] != null) {
                    driverId = map["driverId"].toString();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return RatingWidget(id: driverId);
                        });
                    Provider.of<RiderId>(context, listen: false)
                        .updateStatus(driverId);
                  }
                  if (rideStreamSubscription != null) {
                    rideStreamSubscription?.cancel();
                    rideStreamSubscription = null;
                  }
                }
              }
            }
          } else if (statusRide == "0") {
            statusRide = "0";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.driverCancelTrip;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateTimeTrip(timeTrip);
            if (driverCanceledAfterAccepted) {
              driverCanceledAfterAccepted = false;
              Tools().toastMsg(
                  'Driver : $driverName ${AppLocalizations.of(context)!.driverCancelTrip}',
                  Colors.red.shade400);
              await audioCache.play("Alarm-Windows-10.mp3");
            }
          }
        }
        if (statusRide == "accepted") {
          Provider.of<CloseButtonProvider>(context, listen: false)
              .updateState(false);
          updateDriverOnMap = false;
          await Geofire.stopListener();
          googleMapState.deleteDriverOnMap("driver");
          if (driverNewLocation.latitude != 0.0) {
            Marker marker = Marker(
                markerId: MarkerId("myDriver$driverId"),
                position: driverNewLocation,
                icon: carType == "Taxi-4 seats"
                    ? googleMapState.driversNearIcon
                    : googleMapState.driversNearIcon1,
                infoWindow: InfoWindow(
                    title: " $driverName",
                    snippet: AppLocalizations.of(context)!.onWay),
                flat: true,
                rotation: headDriverInTrip ?? 90.0);
            updateDriverToRidePickUp(driverNewLocation, context);
            googleMapState.updateMarkerOnMap(marker);
          }
          soundAccepted(context);
        }
      }
    });
  }

  Future<void> updateDriverToRidePickUp(
      LatLng driverCurrentLocation, BuildContext context) async {
    var googleMapState = Provider.of<GoogleMapSet>(context, listen: false);
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    LatLng riderLoc =
        LatLng(pickUpLoc.latitude ?? 0.0, pickUpLoc.longitude ?? 0.0);
    if (isTimeRequsteTrip == false) {
      isTimeRequsteTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          driverCurrentLocation, riderLoc, context);
      final color = Colors.blueAccent.shade700;
      const double valPadding = 100.0;
      LogicGoogleMap().addPloyLine(details!, riderLoc, driverCurrentLocation,
          color, valPadding, context);
      googleMapState.deleteDriverOnMap("dropOfId");
      // markersSet.removeWhere((ele) => ele.markerId.value.contains("dropOfId"));
      // setState(() {
      // });
      timeTrip = details.durationText.toString();
      Provider.of<TimeTripStatusRide>(context, listen: false)
          .updateTimeTrip(timeTrip);
      isTimeRequsteTrip = false;
    }
  }

// this method for update time from pickUp to dropOff
  Future<void> updateTorRidePickToDropOff(BuildContext context) async {
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    final dropOffLoc =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;
    LatLng riderLocPickUp =
        LatLng(pickUpLoc.latitude ?? 0.0, pickUpLoc.longitude ?? 0.0);
    LatLng riderLocDropOff =
        LatLng(dropOffLoc.latitude ?? 0.0, dropOffLoc.longitude ?? 0.0);
    if (isTimeRequsteTrip == false) {
      isTimeRequsteTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          riderLocPickUp, riderLocDropOff, context);
      final color = Colors.greenAccent.shade700;
      const double valPadding = 50;
      LogicGoogleMap().addPloyLine(details!, riderLocPickUp, riderLocDropOff,
          color, valPadding, context);
      timeTrip = details.durationText.toString();
      Provider.of<TimeTripStatusRide>(context, listen: false)
          .updateTimeTrip(timeTrip);
      // setState(() {});
      isTimeRequsteTrip = false;
    }
  }

  // this methods for change voice connect to language
  Future<void> soundAccepted(BuildContext context) async {
    String val = AppLocalizations.of(context)!.taxi;
    if (sound1 == true) {
      await audioCache.play("Alarm-Windows-10.mp3");
      switch (val) {
        case 'Taksi':
          await audioCache.play("commingtr.mp3");
          break;
        case 'تاكسي':
          await audioCache.play("Alarm-Windows-10.mp3");
          // await audioCache.play("dcomingtoyouar.wav");
          break;
        default:
          await audioCache.play("Alarm-Windows-10.mp3");
          // await audioCache.play("onway.wav");
          break;
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    sound1 = false;
    audioPlayer.stop();
  }

  Future<void> soundArrived(BuildContext context) async {
    String val = AppLocalizations.of(context)!.taxi;
    if (sound2 == true) {
      switch (val) {
        case 'Taksi':
          await audioCache.play("arrivedtr.mp3");
          break;
        case 'تاكسي':
          await audioCache.play("Alarm-Windows-10.mp3");
          // await audioCache.play("darrivedtoyouar.wav");
          break;
        default:
          await audioCache.play("Alarm-Windows-10.mp3");
          // await audioCache.play("waiten.wav");
          break;
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    sound2 = false;
    audioPlayer.stop();
  }

  Future<void> soundTripStart(BuildContext context) async {
    String val = AppLocalizations.of(context)!.taxi;
    if (sound3 == true) {
      switch (val) {
        case 'Taksi':
          await audioCache.play("starttr.mp3");
          break;
        case 'تاكسي':
          await audioCache.play("Alarm-Windows-10.mp3");
          // await audioCache.play("youintripar.wav");
          break;
        default:
          await audioCache.play("Alarm-Windows-10.mp3");
          // await audioCache.play("intripen.wav");
          break;
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    sound3 = false;
    audioPlayer.stop();
  }

// this method for trick driver on trip step by step
// void trickDriverCaronTrpe(LatLng driverNewLocation, Marker marker) {
//   CameraPosition cameraPosition = CameraPosition(
//       target: driverNewLocation, zoom: 14.0, tilt: 0.0, bearing: 0.0);
//   newGoogleMapController
//       ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//   // markersSet.removeWhere((ele) => ele.markerId.value == "myDriver");
//   // markersSet.add(marker);
// }

// Future<void> deleteGeoFireMarker() async {
//   setState(() {
//     markersSet.removeWhere((ele) => ele.markerId.value.contains("driver"));
//   });
// }
}
