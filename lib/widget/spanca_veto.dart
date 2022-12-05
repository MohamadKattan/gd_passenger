// this class for sapanca list

import 'package:flutter/material.dart';
import '../config.dart';
import '../google_map_methods.dart';
import 'divider_box_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// var uuid = const Uuid();
//
// class SapancaVeto extends StatefulWidget {
//   const SapancaVeto({Key? key}) : super(key: key);
//
//   @override
//   State<SapancaVeto> createState() => _SapancaVetoState();
// }
//
// class _SapancaVetoState extends State<SapancaVeto> {
//   final GetUrl _getUrl = GetUrl();
//   // List<PlacePredictions> placePredictions = [];
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       elevation: 1.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       backgroundColor: Colors.transparent,
//       child: Container(
//         height: MediaQuery.of(context).size.height * 60 / 100,
//         width: double.infinity,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14.0), color: Colors.white),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                     color: Color(0xFF00A3E0),
//                     borderRadius: BorderRadius.only(topRight:Radius.circular(14.0),topLeft: Radius.circular(14.0))
//                 ),
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   AppLocalizations.of(context)!.torzimTrip,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12.0,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       AppLocalizations.of(context)!.pricesList,
//                       style: const TextStyle(
//                         color:Color(0xFF00A3E0),
//                         fontSize: 20.0,
//                       ),
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.redAccent,
//                       )),
//                 ],
//               ),
//               CustomWidget().customDivider(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tourismCityName = "spanca";
//                       tourismCityPrice = "90";
//                     });
//                     tourismCities(tourismCityName, context);
//                   },
//                   child: Container(
//                       width: double.infinity,
//                       height: 55.0,
//                       decoration: BoxDecoration(
//                           border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4.0)),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               AppLocalizations.of(context)!.spanMain,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF00A3E0),
//                                   fontSize: 16.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Expanded(
//                             flex: 0,
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 "\$90",
//                                 style: TextStyle(
//                                     color: Color(0xFF00A3E0),
//                                     fontSize: 20.0),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tourismCityName = "bursa";
//                       tourismCityPrice = "200";
//                     });
//                     tourismCities(tourismCityName, context);
//                   },
//                   child: Container(
//                       width: double.infinity,
//                       height: 55.0,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4.0),
//                         border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               AppLocalizations.of(context)!.spanBursa,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color:Color(0xFF00A3E0),
//                                   fontSize: 16.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Expanded(
//                             flex: 0,
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 "\$200",
//                                 style: TextStyle(
//                                     color: Color(0xFF00A3E0),
//                                     fontSize: 20.0),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tourismCityName = "izmit";
//                       tourismCityPrice = "100";
//                     });
//                     tourismCities(tourismCityName, context);
//                   },
//                   child: Container(
//                       width: double.infinity,
//                       height: 55.0,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4.0),
//                         border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               AppLocalizations.of(context)!.spanIzn,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF00A3E0),
//                                   fontSize: 16.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Expanded(
//                             flex: 0,
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 "\$100",
//                                 style: TextStyle(
//                                     color: Color(0xFF00A3E0),
//                                     fontSize: 20.0),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tourismCityName = "istanbul";
//                       tourismCityPrice = "180";
//                     });
//                     tourismCities(tourismCityName, context);
//                   },
//                   child: Container(
//                       width: double.infinity,
//                       height: 55.0,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4.0),
//                         border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               AppLocalizations.of(context)!.spanIst,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF00A3E0),
//                                   fontSize: 16.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Expanded(
//                             flex: 0,
//                             child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 "\$180",
//                                 style: TextStyle(
//                                     color: Color(0xFF00A3E0),
//                                     fontSize: 20.0),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tourismCityName = "Bolu abant";
//                       tourismCityPrice = "200";
//                     });
//                     tourismCities(tourismCityName, context);
//                   },
//                   child: Container(
//                       width: double.infinity,
//                       height: 55.0,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4.0),
//                         border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               AppLocalizations.of(context)!.spanPol,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF00A3E0),
//                                   fontSize: 16.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "\$200",
//                               style: TextStyle(
//                                   color: Color(0xFF00A3E0),
//                                   fontSize: 20.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tourismCityName = "yalova";
//                       tourismCityPrice = "150";
//                     });
//                     tourismCities(tourismCityName, context);
//                   },
//                   child: Container(
//                       width: double.infinity,
//                       height: 55.0,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4.0),
//                         border: Border.all(width: 2.0, color: const Color(0xFFFBC408)),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               AppLocalizations.of(context)!.spanYal,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF00A3E0),
//                                   fontSize: 16.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "\$150",
//                               style: TextStyle(
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 20.0,
//                               ),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // this method for static cities location for tourism trip
//   Future<void> tourismCities(
//       String tourismCityName, BuildContext context) async {
//     showDialog(
//         context: context,
//         builder: (context) =>
//             CircularInductorCostem().circularInductorCostem(context));
//     final addressModle =
//         Provider.of<AppData>(context, listen: false).pickUpLocation;
//     if (tourismCityName.length > 1) {
//       //apiFindPlace
//       final autocompleteUrl = Uri.parse(
//           "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$tourismCityName&key=$mapKey&sessiontoken=${uuid.v4()}&location=${addressModle.latitude},${addressModle.longitude}&radius=${50.000}");
//       final response = await _getUrl.getUrlMethod(autocompleteUrl);
//       if (response == "failed") {
//         return;
//       } else {
//         if (response["status"] == "OK") {
//           final predictions = response["predictions"][0];
//
//           String id, mainTile, secondTitle;
//           id = predictions["place_id"];
//           mainTile = predictions["structured_formatting"]["main_text"];
//           secondTitle = predictions["structured_formatting"]["secondary_text"];
//           PlacePredictions pre = PlacePredictions("", "", "");
//           pre.placeId = id;
//           pre.mainText = mainTile;
//           pre.secondaryText = secondTitle;
//
//           await Future.delayed(const Duration(milliseconds: 300))
//               .whenComplete(() async {
//             final placeDetailsUrl = Uri.parse(
//                 "https://maps.googleapis.com/maps/api/place/details/json?place_id=${pre.placeId}&key=$mapKey");
//             final res = await _getUrl.getUrlMethod(placeDetailsUrl);
//             if (res == "failed") {
//               return;
//             }
//             if (res["status"] == "OK") {
//               Address address = Address(
//                   placeFormattedAddress: "",
//                   placeName: "",
//                   placeId: "",
//                   latitude: 0.0,
//                   longitude: 0.0);
//               address.placeId = pre.placeId;
//               address.placeName = res["result"]["name"];
//               address.latitude = res["result"]["geometry"]["location"]["lat"];
//               address.longitude = res["result"]["geometry"]["location"]["lng"];
//               Provider.of<PlaceDetailsDropProvider>(context, listen: false)
//                   .updateDropOfLocation(address);
//               _getPlaceDerction(context);
//             }
//           });
//         }
//       }
//     }
//   }
//
//   ///this them main logic for diretion + marker+ polline conect with class api
//   Future<void> _getPlaceDerction(BuildContext context) async {
//     /// from api geo
//     final initialPos =
//         Provider.of<AppData>(context, listen: false).pickUpLocation;
//
//     ///from api srv place
//     final finalPos =
//         Provider.of<PlaceDetailsDropProvider>(context, listen: false)
//             .dropOfLocation;
//
//     final pickUpLatling = LatLng(initialPos.latitude, initialPos.longitude);
//     final dropOfLatling = LatLng(finalPos.latitude, finalPos.longitude);
//
//     ///from api dir
//     final details = await ApiSrvDir.obtainPlaceDirectionDetails(
//         pickUpLatling, dropOfLatling, context);
//     setState(() {
//       tripDirectionDetails = details;
//     });
//
//     /// PolylinePoints method
//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> decodedPolylineResult =
//     polylinePoints.decodePolyline(details!.enCodingPoints);
//     polylineCoordinates.clear();
//
//     if (decodedPolylineResult.isNotEmpty) {
//       ///new add
//       for (var pointLatLng in decodedPolylineResult) {
//         polylineCoordinates
//             .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
//       }
//     }
//     polylineSet.clear();
//     setState(() {
//       ///property PolylinePoints
//       Polyline polyline = Polyline(
//           polylineId: const PolylineId("polylineId"),
//           color: Colors.greenAccent.shade700,
//           width: 6,
//           geodesic: true,
//           startCap: Cap.roundCap,
//           endCap: Cap.roundCap,
//           jointType: JointType.round,
//           points: polylineCoordinates);
//
//       ///set from above
//       polylineSet.add(polyline);
//     });
//     Navigator.pop(context);
//     Navigator.pop(context);
//     ///for fit line on map PolylinePoints
//     // LatLngBounds latLngBounds;
//     // if (pickUpLatling.latitude > dropOfLatling.latitude &&
//     //     pickUpLatling.longitude > dropOfLatling.longitude) {
//     //   latLngBounds =
//     //       LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
//     // } else if (pickUpLatling.longitude > dropOfLatling.longitude) {
//     //   latLngBounds = LatLngBounds(
//     //       southwest: LatLng(pickUpLatling.latitude, dropOfLatling.longitude),
//     //       northeast: LatLng(dropOfLatling.latitude, pickUpLatling.longitude));
//     // } else if (pickUpLatling.latitude > dropOfLatling.latitude) {
//     //   latLngBounds = LatLngBounds(
//     //       southwest: LatLng(dropOfLatling.latitude, pickUpLatling.longitude),
//     //       northeast: LatLng(pickUpLatling.latitude, dropOfLatling.longitude));
//     // } else {
//     //   latLngBounds =
//     //       LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
//     // }
//     // newGoogleMapController
//     //     ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
//
//     double nLat, nLon, sLat, sLon;
//
//     if (dropOfLatling.latitude <= pickUpLatling.latitude ) {
//       sLat = dropOfLatling.latitude;
//       nLat = pickUpLatling.latitude ;
//     }else{
//       sLat = pickUpLatling.latitude ;
//       nLat = dropOfLatling.latitude;
//     }
//     if (dropOfLatling.longitude <= pickUpLatling.longitude) {
//       sLon = dropOfLatling.longitude;
//       nLon = pickUpLatling.longitude;
//     }else{
//       sLon = pickUpLatling.longitude;
//       nLon = dropOfLatling.longitude;
//     }
//     LatLngBounds latLngBounds=  LatLngBounds(
//       northeast: LatLng(nLat, nLon),
//       southwest: LatLng(sLat, sLon),
//     );
//
//     newGoogleMapController
//         ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50.0));
//
//     ///Marker
//     Marker markerPickUpLocation = Marker(
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
//         infoWindow:
//         InfoWindow(title: initialPos.placeName, snippet: "My Location"),
//         position: LatLng(pickUpLatling.latitude, pickUpLatling.longitude),
//         markerId: const MarkerId("pickUpId"));
//
//     Marker markerDropOfLocation = Marker(
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueRed,
//         ),
//         infoWindow:
//         InfoWindow(title: finalPos.placeName, snippet: "Drop off Location"),
//         position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
//         markerId: const MarkerId("dropOfId"));
//
//     setState(() {
//       markersSet.add(markerPickUpLocation);
//       markersSet.add(markerDropOfLocation);
//     });
//
//     ///Circle
//     Circle pickUpLocCircle = Circle(
//         fillColor: Colors.white,
//         radius: 14.0,
//         center: pickUpLatling,
//         strokeWidth: 2,
//         strokeColor: Colors.grey,
//         circleId: const CircleId("pickUpId"));
//
//     Circle dropOffLocCircle = Circle(
//         fillColor: Colors.white,
//         radius: 14.0,
//         center: dropOfLatling,
//         strokeWidth: 2,
//         strokeColor: Colors.grey,
//         circleId: const CircleId("dropOfId"));
//     setState(() {
//       circlesSet.add(pickUpLocCircle);
//       circlesSet.add(dropOffLocCircle);
//     });
//   }
// }

Widget sapancaVeto (BuildContext context){
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
                  tourismCityName = "spanca";
                  tourismCityPrice = "90";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
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
                            AppLocalizations.of(context)!.spanMain,
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
                              "\$90",
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
                    tourismCityName = "bursa";
                    tourismCityPrice = "200";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
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
                            AppLocalizations.of(context)!.spanBursa,
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
                              "\$200",
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
                    tourismCityName = "izmit";
                    tourismCityPrice = "100";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
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
                            AppLocalizations.of(context)!.spanIzn,
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
                    tourismCityName = "istanbul";
                    tourismCityPrice = "180";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
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
                            AppLocalizations.of(context)!.spanIst,
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
                              "\$180",
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
                    tourismCityName = "Bolu abant";
                    tourismCityPrice = "200";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
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
                            AppLocalizations.of(context)!.spanPol,
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
                            "\$200",
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
                    tourismCityName = "yalova";
                    tourismCityPrice = "150";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
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
                            AppLocalizations.of(context)!.spanYal,
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
                            "\$150",
                            style: TextStyle(
                              color: Color(0xFF00A3E0),
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