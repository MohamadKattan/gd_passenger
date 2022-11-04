// this class for trabzon list

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../config.dart';
import '../model/address.dart';
import '../model/place_predictions.dart';
import '../my_provider/app_data.dart';
import '../my_provider/placeDetails_drop_provider.dart';
import '../repo/api_srv_dir.dart';
import '../tools/get_url.dart';
import 'custom_circuler.dart';
import 'divider_box_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var uuid = const Uuid();

class TrabzonVeto extends StatefulWidget {
  const TrabzonVeto({Key? key}) : super(key: key);

  @override
  State<TrabzonVeto> createState() => _TrabzonVetoState();
}

class _TrabzonVetoState extends State<TrabzonVeto> {
  final GetUrl _getUrl = GetUrl();
  // List<PlacePredictions> placePredictions = [];
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
            borderRadius: BorderRadius.circular(14.0), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color(0xFF00A3E0),
                    borderRadius: BorderRadius.only(topRight:Radius.circular(14.0),topLeft: Radius.circular(14.0))
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.torzimTrip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.pricesList,
                      style: const TextStyle(
                        color:Color(0xFF00A3E0),
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      )),
                ],
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName = "Trabzon";
                      tourismCityPrice = "100";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 55.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.trapzonMain,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A3E0),
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Expanded(
                            flex: 0,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "\$100",
                                style: TextStyle(
                                    color: Color(0xFF00A3E0),
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
                      tourismCityName = "Uzun gol";
                      tourismCityPrice = "130";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.trapzonUzu,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Color(0xFF00A3E0),
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Expanded(
                            flex: 0,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "\$130",
                                style: TextStyle(
                                    color: Color(0xFF00A3E0),
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
                      tourismCityName = "Ayder";
                      tourismCityPrice = "170";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.trapzonAyd,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A3E0),
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Expanded(
                            flex: 0,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "\$170",
                                style: TextStyle(
                                    color: Color(0xFF00A3E0),
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
                      tourismCityName = "Rize";
                      tourismCityPrice = "160";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.trapzonRiz,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A3E0),
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Expanded(
                            flex: 0,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "\$160",
                                style: TextStyle(
                                    color: Color(0xFF00A3E0),
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
                      tourismCityName = "Giresun";
                      tourismCityPrice = "160";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.trapzonGir,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A3E0),
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "\$160",
                              style: TextStyle(
                                  color: Color(0xFF00A3E0),
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
                      tourismCityName = "ondu";
                      tourismCityPrice = "200";
                    });
                    tourismCities(tourismCityName, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              AppLocalizations.of(context)!.trapzonOndu,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A3E0),
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Expanded(
                            flex: 0,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "\$200",
                                style: TextStyle(
                                  color: Color(0xFF00A3E0),
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
              _getPlaceDerction(context);
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
    Navigator.pop(context);

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

}