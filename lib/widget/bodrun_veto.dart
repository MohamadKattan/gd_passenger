// import 'package:flutter/material.dart';
// import 'package:gd_passenger/google_map_methods.dart';
// import 'package:uuid/uuid.dart';
// import '../config.dart';
// import 'divider_box_.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// var uuid = const Uuid();
//
// Widget bodrunVeto(BuildContext context) {
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
//                   tourismCityName = "Bodrum";
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
//                             AppLocalizations.of(context)!.bodMain,
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
//                   tourismCityName = "Izmir";
//                   tourismCityPrice = "300";
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
//                             AppLocalizations.of(context)!.bodIzmir,
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
//                               "\$300",
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
//                             AppLocalizations.of(context)!.bodMarmar,
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
//                   tourismCityName = "sapanca";
//                   tourismCityPrice = "180";
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
//                             AppLocalizations.of(context)!.sabanjah,
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
//                               "\$180",
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
//           ],
//         ),
//       ),
//     ),
//   );
// }
// this method for static cities location for tourism trip
