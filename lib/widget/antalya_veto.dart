// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import '../config.dart';
// import '../google_map_methods.dart';
// import 'divider_box_.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// var uuid = const Uuid();
//
// Widget antalyVeto(BuildContext context) {
//   return Dialog(
//     elevation: 1.0,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//     backgroundColor: Colors.transparent,
//     child: Container(
//       height: MediaQuery.of(context).size.height * 60 / 100,
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14.0), color: Colors.white),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                   color: Color(0xFF00A3E0),
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(14.0),
//                       topLeft: Radius.circular(14.0))),
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 AppLocalizations.of(context)!.torzimTrip,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12.0,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     AppLocalizations.of(context)!.pricesList,
//                     style: const TextStyle(
//                       color: Color(0xFF00A3E0),
//                       fontSize: 20.0,
//                     ),
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(
//                       Icons.close,
//                       color: Colors.redAccent,
//                     )),
//               ],
//             ),
//             CustomWidget().customDivider(),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   tourismCityName = "Antalya";
//                   tourismCityPrice = "100";
//                   LogicGoogleMap().tourismCities(tourismCityName, context);
//                 },
//                 child: Container(
//                     width: double.infinity,
//                     height: 55.0,
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             width: 2.0, color: const Color(0xFFFBC408)),
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4.0)),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             AppLocalizations.of(context)!.antalMain,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 16.0),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Expanded(
//                           flex: 0,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "\$100",
//                               style: TextStyle(
//                                   color: Color(0xFF00A3E0), fontSize: 20.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   tourismCityName = "Manavgat";
//                   tourismCityPrice = "130";
//                   LogicGoogleMap().tourismCities(tourismCityName, context);
//                 },
//                 child: Container(
//                     width: double.infinity,
//                     height: 55.0,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4.0),
//                       border: Border.all(
//                           width: 2.0, color: const Color(0xFFFBC408)),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             AppLocalizations.of(context)!.antalManar,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 16.0),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Expanded(
//                           flex: 0,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "\$130",
//                               style: TextStyle(
//                                   color: Color(0xFF00A3E0), fontSize: 20.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   tourismCityName = "Marmaris";
//                   tourismCityPrice = "250";
//                   LogicGoogleMap().tourismCities(tourismCityName, context);
//                 },
//                 child: Container(
//                     width: double.infinity,
//                     height: 55.0,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4.0),
//                       border: Border.all(
//                           width: 2.0, color: const Color(0xFFFBC408)),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             AppLocalizations.of(context)!.antalMarr,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 16.0),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Expanded(
//                           flex: 0,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "\$250",
//                               style: TextStyle(
//                                   color: Color(0xFF00A3E0), fontSize: 20.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   tourismCityName = "Bodrum";
//                   tourismCityPrice = "400";
//                   LogicGoogleMap().tourismCities(tourismCityName, context);
//                 },
//                 child: Container(
//                     width: double.infinity,
//                     height: 55.0,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4.0),
//                       border: Border.all(
//                           width: 2.0, color: const Color(0xFFFBC408)),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             AppLocalizations.of(context)!.antalBoder,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 16.0),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Expanded(
//                           flex: 0,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "\$400",
//                               style: TextStyle(
//                                   color: Color(0xFF00A3E0), fontSize: 20.0),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   tourismCityName = "Izmir";
//                   tourismCityPrice = "500";
//                   LogicGoogleMap().tourismCities(tourismCityName, context);
//                 },
//                 child: Container(
//                     width: double.infinity,
//                     height: 55.0,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4.0),
//                       border: Border.all(
//                           width: 2.0, color: const Color(0xFFFBC408)),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             AppLocalizations.of(context)!.antalIzmir,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 16.0),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "\$500",
//                             style: TextStyle(
//                                 color: Color(0xFF00A3E0), fontSize: 20.0),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   tourismCityName = "Alanya";
//                   tourismCityPrice = "160";
//                   LogicGoogleMap().tourismCities(tourismCityName, context);
//                 },
//                 child: Container(
//                     width: double.infinity,
//                     height: 55.0,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4.0),
//                       border: Border.all(
//                           width: 2.0, color: const Color(0xFFFBC408)),
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             AppLocalizations.of(context)!.antalAlan,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 16.0),
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const Expanded(
//                           flex: 0,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text(
//                               "\$160",
//                               style: TextStyle(
//                                 color: Color(0xFF00A3E0),
//                                 fontSize: 20,
//                               ),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// this method for static cities location for tourism trip
// Future<void> tourismCities(String tourismCityName, BuildContext context) async {
//   final GetUrl _getUrl = GetUrl();
//   showDialog(
//       context: context,
//       builder: (context) =>
//           CircularInductorCostem().circularInductorCostem(context));
//   final addressModle =
//       Provider.of<AppData>(context, listen: false).pickUpLocation;
//   if (tourismCityName.length > 1) {
//     //apiFindPlace
//     final autocompleteUrl = Uri.parse(
//         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$tourismCityName&key=$mapKey&sessiontoken=${uuid.v4()}&location=${addressModle.latitude},${addressModle.longitude}&radius=${50.000}");
//     final response = await _getUrl.getUrlMethod(autocompleteUrl);
//     if (response == "failed") {
//       return;
//     } else {
//       if (response["status"] == "OK") {
//         final predictions = response["predictions"][0];
//
//         String id, mainTile, secondTitle;
//         id = predictions["place_id"];
//         mainTile = predictions["structured_formatting"]["main_text"];
//         secondTitle = predictions["structured_formatting"]["secondary_text"];
//         PlacePredictions pre = PlacePredictions("", "", "");
//         pre.placeId = id;
//         pre.mainText = mainTile;
//         pre.secondaryText = secondTitle;
//
//         await Future.delayed(const Duration(milliseconds: 300))
//             .whenComplete(() async {
//           final placeDetailsUrl = Uri.parse(
//               "https://maps.googleapis.com/maps/api/place/details/json?place_id=${pre.placeId}&key=$mapKey");
//           final res = await _getUrl.getUrlMethod(placeDetailsUrl);
//           if (res == "failed") {
//             return;
//           }
//           if (res["status"] == "OK") {
//             Address address = Address(
//                 placeFormattedAddress: "",
//                 placeName: "",
//                 placeId: "",
//                 latitude: 0.0,
//                 longitude: 0.0);
//             address.placeId = pre.placeId;
//             address.placeName = res["result"]["name"];
//             address.latitude = res["result"]["geometry"]["location"]["lat"];
//             address.longitude = res["result"]["geometry"]["location"]["lng"];
//             Provider.of<PlaceDetailsDropProvider>(context, listen: false)
//                 .updateDropOfLocation(address);
//             Navigator.pop(context);
//             Navigator.pop(context, 'data');
//           }
//         });
//       }
//     }
//   }
// }
