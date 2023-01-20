//this class for google map methods

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gd_passenger/repo/api_srv_dir.dart';
import 'package:gd_passenger/repo/api_srv_geo.dart';
import 'package:gd_passenger/tools/geoFire_methods_tools.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:gd_passenger/tools/math_methods.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/widget/custom_widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'config.dart';
import 'model/address.dart';
import 'model/directions_details.dart';
import 'model/nearest _driver_ available.dart';
import 'model/place_predictions.dart';
import 'my_provider/app_data.dart';
import 'my_provider/google_set_provider.dart';
import 'my_provider/placeDetails_drop_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'my_provider/position_v_chnge.dart';

var uuid = const Uuid();

class LogicGoogleMap {
  final GetUrl _getUrl = GetUrl();
  final ApiSrvGeo _apiMethods = ApiSrvGeo();

  final Completer<GoogleMapController> controllerGoogleMap =
      Completer<GoogleMapController>();

// set location
  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(41.084253576036936, 28.89201922194848),
    zoom: 14.4746,
  );
// requestLocationPermission if disabled
  Future<void> requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
      Tools().toastMsg(AppLocalizations.of(context)!.noGps, Colors.red);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        Tools().toastMsg(AppLocalizations.of(context)!.noGps, Colors.red);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Tools().toastMsg(AppLocalizations.of(context)!.noGps, Colors.red);
    }
  }

// got current location after that geolocation api will called for readable address
  Future<void> locationPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
      Tools().toastMsg(AppLocalizations.of(context)!.noGps, Colors.red);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        Tools().toastMsg(AppLocalizations.of(context)!.noGps, Colors.red);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Tools().toastMsg(AppLocalizations.of(context)!.noGps, Colors.red);
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 14.151926040649414,
      tilt: 59.440717697143555,
      bearing: 192.8334901395799,
    );
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await _apiMethods.searchCoordinatesAddress(position, context);
  }

  // this method for display nearest driver available from rider in list by using geoFire
  Future<void> geoFireInitialize(BuildContext context) async {
    await Geofire.initialize("availableDrivers");
    final currentPositionPro =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    try {
      Geofire.queryAtLocation(currentPositionPro.latitude ?? 0.0,
              currentPositionPro.longitude ?? 0.0, geoFireRadios)
          ?.listen((map) async {
        if (map != null) {
          var callBack = map['callBack'];
          switch (callBack) {
            case Geofire.onKeyEntered:
              NearestDriverAvailable nearestDriverAvailable =
                  NearestDriverAvailable("", 0.0, 0.0);
              nearestDriverAvailable.key = map['key'];
              nearestDriverAvailable.latitude = map['latitude'];
              nearestDriverAvailable.longitude = map['longitude'];
              GeoFireMethods.listOfNearestDriverAvailable
                  .add(nearestDriverAvailable);
              if (kDebugMode) {
                print(
                    "hhh${GeoFireMethods.listOfNearestDriverAvailable.length}");
              }
              break;
            case Geofire.onKeyExited:
              GeoFireMethods.removeDriverFromList(map["key"]);
              break;

            case Geofire.onKeyMoved:
              NearestDriverAvailable nearestDriverAvailable =
                  NearestDriverAvailable("", 0.0, 0.0);
              nearestDriverAvailable.key = map['key'];
              nearestDriverAvailable.latitude = map['latitude'];
              nearestDriverAvailable.longitude = map['longitude'];
              GeoFireMethods.updateDriverNearLocation(nearestDriverAvailable);
              updateAvailableDriverOnMap(context);
              break;
            case Geofire.onGeoQueryReady:
              updateAvailableDriverOnMap(context);
              break;
          }
        }
        // setState(() {});
      }).onError((er) {
        if (kDebugMode) {
          print(er.toString());
        }
      });
    } on PlatformException {
      if (kDebugMode) {
        print('PlatformException geo fire');
      }
    }
    // if (!mounted) return;
  }

  void updateAvailableDriverOnMap(BuildContext context) async {
    var icon = Provider.of<GoogleMapSet>(context, listen: false);
    if (updateDriverOnMap == true) {
      if (kDebugMode) {
        print('update drivers on Map');
      }
      late String driverPhoneOneOnMap;
      late String phone;
      for (NearestDriverAvailable driver
          in GeoFireMethods.listOfNearestDriverAvailable) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child("driver").child(driver.key);
        await ref.once().then((value) {
          final snap = value.snapshot.value;
          if (snap == null) {
            return;
          }
          Map<String, dynamic> map = Map<String, dynamic>.from(snap as Map);
          if (map["firstName"] != null) {
            fNameIcon = map["firstName"].toString();
          }
          if (map["lastName"] != null) {
            lNameIcon = map["lastName"].toString();
          }
          if (map["rating"] != null) {
            ratDriverRead = double.parse(map["rating"].toString());
          }
          if (map["carInfo"]["carType"] != null) {
            carTypeOnUpdateGeo = map["carInfo"]["carType"].toString();
          }
          if (map["phoneNumber"] != null) {
            driverPhoneOneOnMap = map["phoneNumber"].toString();
          }
        });
        LatLng driverAvailablePosititon =
            LatLng(driver.latitude, driver.longitude);
        Marker marker = Marker(
          markerId: MarkerId("driver${driver.key}"),
          position: driverAvailablePosititon,
          icon: carTypeOnUpdateGeo == "Taxi-4 seats"
              ? icon.driversNearIcon
              : icon.driversNearIcon1,
          // ? driversNearIcon
          // : driversNearIcon1,
          infoWindow: InfoWindow(
              onTap: () async {
                await ref.child('phoneNumber').once().then((value) {
                  if (value.snapshot.value != null) {
                    phone = value.snapshot.value.toString();
                  }
                });
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        CustomWidgets().callDriverOnMap(context, phone));
              },
              title: " $fNameIcon $lNameIcon",
              snippet:
                  ' ${AppLocalizations.of(context)!.callDriver} : $driverPhoneOneOnMap'),
          rotation: MathMethods.createRandomNumber(180),
          anchor: const Offset(1.0, 0.50),
        );
        Provider.of<GoogleMapSet>(context, listen: false)
            .updateMarkerOnMap(marker);
        // setState(() {
        //   markersSet.add(marker);
        // });
      }
    } else {
      if (kDebugMode) {
        print('No update drivers on Map');
      }
      return;
    }
  }

/* this method when user chose tur city from list it will called
 autoFindPlace to got id place after that place details api
 if ok it will pop with parameter data in await if data true it will call
 [getPlaceDirection method] */
  Future<void> tourismCities(
      String tourismCityName, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => CustomWidgets().circularInductorCostem(context));
    final addressModle =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    if (tourismCityName.length > 1) {
      //apiFindPlace
      final autocompleteUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$tourismCityName&key=$mapKey&sessiontoken=${uuid.v4()}&location=${addressModle.latitude ?? 0.0},${addressModle.longitude ?? 0.0}&radius=${50.000}");
      final response = await _getUrl.getUrlMethod(autocompleteUrl);
      if (response == "failed") {
        return;
      } else {
        if (response["status"] == "OK") {
          final predictions = response["predictions"][0];

          String id, mainTile, secondTitle;
          id = predictions["place_id"];
          mainTile = predictions["structured_formatting"]["main_text"];
          secondTitle = predictions["structured_formatting"]["secondary_text"];
          PlacePredictions pre = PlacePredictions("", "", "");
          pre.placeId = id;
          pre.mainText = mainTile;
          pre.secondaryText = secondTitle;

          await Future.delayed(const Duration(milliseconds: 300))
              .whenComplete(() async {
            final placeDetailsUrl = Uri.parse(
                "https://maps.googleapis.com/maps/api/place/details/json?place_id=${pre.placeId}&key=$mapKey");
            final res = await _getUrl.getUrlMethod(placeDetailsUrl);
            if (res == "failed") {
              return;
            }
            if (res["status"] == "OK") {
              Address address = Address();
              address.placeFormattedAddress = "";
              address.placeId = pre.placeId;
              address.placeName = res["result"]["name"];
              address.latitude = res["result"]["geometry"]["location"]["lat"];
              address.longitude = res["result"]["geometry"]["location"]["lng"];
              Provider.of<PlaceDetailsDropProvider>(context, listen: false)
                  .updateDropOfLocation(address);
              Navigator.pop(context);
              Navigator.pop(context, 'data');
            }
          });
        }
      }
    }
  }

  //this them main logic for diretion + marker+ polline conect with class api
  Future<void> getPlaceDirection(BuildContext context) async {
    /// current position
    final initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;

    ///from api srv place drop of position
    final finalPos =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;

    final pickUpLatLng =
        LatLng(initialPos.latitude ?? 0.0, initialPos.longitude ?? 00);
    final dropOfLatLng =
        LatLng(finalPos.latitude ?? 0.0, finalPos.longitude ?? 0.0);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomWidgets().circularInductorCostem(context));

    ///from api dir
    final details = await ApiSrvDir.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOfLatLng, context);
    Provider.of<GoogleMapSet>(context, listen: false)
        .updateTripDirectionDetail(details);
    // setState(() {
    //   tripDirectionDetails = details;
    // });
    final color = Colors.greenAccent.shade700;
    Navigator.pop(context);
    const double valPadding = 50;
    LogicGoogleMap().addPloyLine(
        details!, pickUpLatLng, dropOfLatLng, color, valPadding, context);
    Tools().changeAutoPriceColor(context);
    // audioCache = AudioCache(fixedPlayer: audioPlayer, prefix: "assets/");
    await Future.delayed(const Duration(seconds: 2));
    audioCache.play("gift.mp3");
    Provider.of<PositionChang>(context, listen: false)
        .updateDisCountBoxPosition(80.0);
    await audioPlayer.stop();
    await Future.delayed(const Duration(seconds: 3));
    Provider.of<PositionChang>(context, listen: false)
        .updateDisCountBoxPosition(-600.0);
  }

  /* this method for add polyLine after got pick and drop from
   getPlaceDirection or updateDriverToRidePickUp or updateTorRidePickToDropOff*/
  addPloyLine(
      DirectionDetails details,
      LatLng pickUpLatLng,
      LatLng dropOfLatLng,
      Color colors,
      double valPadding,
      BuildContext context) {
    //current placeName
    var pickUpName =
        Provider.of<AppData>(context, listen: false).pickUpLocation.placeName;

    //from api srv place drop of position
    var dropOffName =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation
            .placeName;
    // this from google set provider for PolylinePoints + maker+circle+polyline
    var googleSets = Provider.of<GoogleMapSet>(context, listen: false);

    /// PolylinePoints method
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylineResult =
        polylinePoints.decodePolyline(details.enCodingPoints);
    googleSets.polylineCoordinate.clear();
    // polylineCoordinates.clear();
    if (decodedPolylineResult.isNotEmpty) {
      for (var pointLatLng in decodedPolylineResult) {
        googleSets.updatePolylineCoordinateMap(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
        // polylineCoordinates
        //     .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    googleSets.polylineSet.clear();
    // polylineSet.clear();

    double nLat, nLon, sLat, sLon;

    if (dropOfLatLng.latitude <= pickUpLatLng.latitude) {
      sLat = dropOfLatLng.latitude;
      nLat = pickUpLatLng.latitude;
    } else {
      sLat = pickUpLatLng.latitude;
      nLat = dropOfLatLng.latitude;
    }
    if (dropOfLatLng.longitude <= pickUpLatLng.longitude) {
      sLon = dropOfLatLng.longitude;
      nLon = pickUpLatLng.longitude;
    } else {
      sLon = pickUpLatLng.longitude;
      nLon = dropOfLatLng.longitude;
    }
    LatLngBounds latLngBounds = LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    );

    newGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, valPadding));

    ///Marker
    Marker markerPickUpLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(
            title: pickUpName,
            snippet: AppLocalizations.of(context)!.myLocation),
        position: LatLng(pickUpLatLng.latitude, pickUpLatLng.longitude),
        markerId: const MarkerId("pickUpId"));

    Marker markerDropOfLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
            title: dropOffName, snippet: AppLocalizations.of(context)!.dropOff),
        position: LatLng(dropOfLatLng.latitude, dropOfLatLng.longitude),
        markerId: const MarkerId("dropOfId"));

    ///Circle
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.white,
        radius: 8.0,
        center: pickUpLatLng,
        strokeWidth: 1,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 8.0,
        center: dropOfLatLng,
        strokeWidth: 1,
        strokeColor: Colors.grey,
        circleId: const CircleId("dropOfId"));

    Polyline polyline = Polyline(
        polylineId: const PolylineId("polylineId"),
        color: colors,
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        points: googleSets.polylineCoordinate);
    googleSets.updateMarkerOnMap(markerPickUpLocation);
    googleSets.updateMarkerOnMap(markerDropOfLocation);
    googleSets.updateCirclesOnMap(pickUpLocCircle);
    googleSets.updateCirclesOnMap(dropOffLocCircle);
    googleSets.updatePolylineOnMap(polyline);
    // polylineSet.add(polyline);
    // circlesSet.add(pickUpLocCircle);
    // circlesSet.add(dropOffLocCircle);
    // markersSet.add(markerPickUpLocation);
    // markersSet.add(markerDropOfLocation);
  }
}
