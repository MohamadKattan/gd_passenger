// this widget to show popup if no drive available

// import 'package:flutter/material.dart';
// import 'package:gd_passenger/my_provider/user_id_provider.dart';
// import 'package:gd_passenger/repo/data_base_srv.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// Widget sorryNoDriverDialog(BuildContext context, UserIdProvider userProvider) {
//   return Dialog(
//     elevation: 1.0,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//     backgroundColor: Colors.transparent,
//     child: Container(
//       height: 250,
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16.0),
//           color: const Color(0xFF00A3E0)),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Center(
//                 child: Lottie.asset('assets/85557-empty.json',
//                     fit: BoxFit.contain, height: 130, width: 130)),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 AppLocalizations.of(context)!.sorry,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             GestureDetector(
//               onTap: () async {
//                 // Provider.of<PositionCancelReq>(context, listen: false)
//                 //     .updateValue(-400.0);
//                 // Provider.of<PositionChang>(context, listen: false)
//                 //     .changValue(0.0);
//                 await DataBaseSrv().cancelRiderRequest(userProvider, context);
//                 Navigator.pop(context, 0);
//               },
//               child: Center(
//                 child: Container(
//                   margin: const EdgeInsets.all(8.0),
//                   width: 160.0,
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4.0),
//                       color: const Color(0xFFFBC408)),
//                   child: Center(
//                       child: Text(
//                     AppLocalizations.of(context)!.ok,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold),
//                   )),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
