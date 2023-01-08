// this widget for dialog collect money after finish trip

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import '../my_provider/dropBottom_value.dart';
// import '../my_provider/timeTrip_statusRide.dart';
// import 'divider_box_.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// Widget collectMoney(BuildContext context, int totalAmount) {
//   final dropBottomProvider =
//       Provider.of<DropBottomValue>(context).valueDropBottom;
//   final currencyType = Provider.of<TimeTripStatusRide>(context).currencyType;
//   return Dialog(
//     elevation: 1.0,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//     backgroundColor: Colors.transparent,
//     child: Container(
//       height: 275,
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.0),
//           color: const Color(0xFF00A3E0)),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Center(
//                 child: Lottie.asset('assets/51765-cash.json',
//                     height: 90, width: 90)),
//             Text(
//               AppLocalizations.of(context)!.amountTrip,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                   "${AppLocalizations.of(context)!.paymentMethod} $dropBottomProvider",
//                   style: const TextStyle(color: Colors.white, fontSize: 16.0)),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                   "${AppLocalizations.of(context)!.total}  $totalAmount $currencyType",
//                   style: const TextStyle(color: Colors.white, fontSize: 16.0)),
//             ),
//             CustomWidget().customDivider(),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context, "close");
//                 },
//                 child: Center(
//                   child: Container(
//                     width: 120,
//                     height: 50,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4.0),
//                         color: const Color(0xFFFBC408)),
//                     child: Center(
//                         child: Text(
//                       AppLocalizations.of(context)!.ok,
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     )),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
