// this dailog if rider chose a van or veto car it will show dailog price in turkey $100
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as loty;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../config.dart';
import '../model/address.dart';
import '../model/place_predictions.dart';
import '../my_provider/app_data.dart';
import '../my_provider/info_user_database_provider.dart';
import '../my_provider/placeDetails_drop_provider.dart';
import '../repo/api_srv_dir.dart';
import '../repo/data_base_srv.dart';
import '../tools/get_url.dart';
import 'custom_circuler.dart';
import 'divider_box_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var uuid = const Uuid();

class VetoVanPriceTurkeyJust extends StatefulWidget {
  const VetoVanPriceTurkeyJust({Key? key}) : super(key: key);

  @override
  State<VetoVanPriceTurkeyJust> createState() => _VetoVanPriceTurkeyJustState();
}

class _VetoVanPriceTurkeyJustState extends State<VetoVanPriceTurkeyJust> {
  final GetUrl _getUrl = GetUrl();
  List<PlacePredictions> placePredictions = [];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 60 / 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.torzimTrip,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.pricesList,
                  style: TextStyle(
                    color: Colors.greenAccent.shade700,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "istanbul";
                      tourismCityPrice = "100";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.istanbul,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$100",
                                style: TextStyle(
                                    color: Colors.redAccent.shade700,
                                    fontSize: 20.0),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "bursa";
                      tourismCityPrice = "220";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.bursa,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$220",
                                style: TextStyle(
                                    color: Colors.redAccent.shade700,
                                    fontSize: 20.0),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "izmit";
                      tourismCityPrice = "150";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.izmit,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$150",
                                style: TextStyle(
                                    color: Colors.redAccent.shade700,
                                    fontSize: 20.0),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "sapanca";
                      tourismCityPrice = "180";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.sabanjah,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$180",
                                style: TextStyle(
                                    color: Colors.redAccent.shade700,
                                    fontSize: 20.0),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "Bolu abant";
                      tourismCityPrice = "300";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.polo,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "\$300",
                              style: TextStyle(
                                  color: Colors.redAccent.shade700,
                                  fontSize: 20.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "şile";
                      tourismCityPrice = "150";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.sala,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "\$300",
                                style: TextStyle(
                                  color: Colors.redAccent.shade700,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "yalova";
                      tourismCityPrice = "170";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.yalua,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "\$170",
                              style: TextStyle(
                                color: Colors.redAccent.shade700,
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // this method for static cities location for tourism trip
  Future<void> tourismCities(
      String tourismCityName, BuildContext context) async {
    final addressModle =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    if (tourismCityName.length > 1) {
      //apiFindPlace
      final autocompleteUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$tourismCityName&key=$mapKey&sessiontoken=${uuid.v4()}&location=${addressModle.latitude},${addressModle.longitude}&radius=${50.000}");
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

              Address address = Address(
                  placeFormattedAddress: "",
                  placeName: "",
                  placeId: "",
                  latitude: 0.0,
                  longitude: 0.0);
              address.placeId = pre.placeId;
              address.placeName = res["result"]["name"];
              address.latitude = res["result"]["geometry"]["location"]["lat"];
              address.longitude = res["result"]["geometry"]["location"]["lng"];

              Provider.of<PlaceDetailsDropProvider>(context, listen: false)
                  .updateDropOfLocation(address);
              _checkUserInfo(context);
            await  _getPlaceDerction(context);
              Future.delayed(const Duration(microseconds: 200))
                  .whenComplete(() => Navigator.pop(context));
            }
          });
        }
      }
    }
  }

  ///this them main logic for diretion + marker+ polline conect with class api
  Future<void> _getPlaceDerction(BuildContext context) async {
    /// from api geo
    final initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;

    ///from api srv place
    final finalPos =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;

    final pickUpLatling = LatLng(initialPos.latitude, initialPos.longitude);
    final dropOfLatling = LatLng(finalPos.latitude, finalPos.longitude);
    showDialog(
        context: context,
        builder: (context) =>
            CircularInductorCostem().circularInductorCostem(context));

    ///from api dir
    final details = await ApiSrvDir.obtainPlaceDirectionDetails(
        pickUpLatling, dropOfLatling, context);
    setState(() {
      tripDirectionDetails = details;
    });
    Navigator.pop(context);

    /// PolylinePoints method
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylineResult =
        polylinePoints.decodePolyline(details!.enCodingPoints);
    polylineCoordinates.clear();

    if (decodedPolylineResult.isNotEmpty) {
      ///new add
      for (var pointLatLng in decodedPolylineResult) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    polylineSet.clear();
    setState(() {
      ///property PolylinePoints
      Polyline polyline = Polyline(
          polylineId: const PolylineId("polylineId"),
          color: Colors.greenAccent.shade700,
          width: 6,
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          points: polylineCoordinates);

      ///set from above
      polylineSet.add(polyline);
    });

    ///for fit line on map PolylinePoints
    LatLngBounds latLngBounds;
    if (pickUpLatling.latitude > dropOfLatling.latitude &&
        pickUpLatling.longitude > dropOfLatling.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
    } else if (pickUpLatling.longitude > dropOfLatling.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatling.latitude, dropOfLatling.longitude),
          northeast: LatLng(dropOfLatling.latitude, pickUpLatling.longitude));
    } else if (pickUpLatling.latitude > dropOfLatling.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOfLatling.latitude, pickUpLatling.longitude),
          northeast: LatLng(pickUpLatling.latitude, dropOfLatling.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
    }
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    ///Marker
    Marker markerPickUpLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow:
            InfoWindow(title: initialPos.placeName, snippet: "My Location"),
        position: LatLng(pickUpLatling.latitude, pickUpLatling.longitude),
        markerId: const MarkerId("pickUpId"));

    Marker markerDropOfLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "Drop off Location"),
        position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
        markerId: const MarkerId("dropOfId"));

    setState(() {
      markersSet.add(markerPickUpLocation);
      markersSet.add(markerDropOfLocation);
    });

    ///Circle
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.white,
        radius: 14.0,
        center: pickUpLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 14.0,
        center: dropOfLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("dropOfId"));
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  void _checkUserInfo(BuildContext context) {
    final infoUserDataReal =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    if (infoUserDataReal == null) {
      DataBaseSrv().currentOnlineUserInfo(context);
    } else {
      return;
    }
  }
}
