//custom widget class use in home scrren
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// class CustomWidget {
//   // divider
//   Widget customDivider() {
//     return Container(
//       height: 0.6,
//       decoration: const BoxDecoration(color: Colors.black12, boxShadow: [
//         BoxShadow(
//             blurRadius: 5.0,
//             spreadRadius: 0.4,
//             color: Colors.black54,
//             offset: Offset(0.6, 0.6))
//       ]),
//     );
//   }
//
// // Home and work box in home screen
//   Widget containerBox(Icon icon, String text, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Container(
//         height: MediaQuery.of(context).size.height * 5.0 / 100,
//         width: MediaQuery.of(context).size.width * 40 / 100,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(4.0),
//             boxShadow: const [
//               BoxShadow(
//                   blurRadius: 4.0,
//                   spreadRadius: 0.3,
//                   color: Colors.black54,
//                   offset: Offset(0.4, 0.4))
//             ]),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Icon(
//                   icon.icon,
//                   color: const Color(0xFFFFD54F),
//                   size: 20,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: Center(
//                 child: Text(
//                   text,
//                   style: const TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // car type box taxi/van/veto
//   Widget carTypeBox(
//       Image image, String text, String text1, BuildContext context) {
//     return Container(
//       // height: MediaQuery.of(context).size.height * 12.5 / 100,
//       // width: MediaQuery.of(context).size.height * 20 / 100,
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Column(
//         children: [
//           Expanded(
//             child: image,
//           ),
//           Expanded(
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//               child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Icon(Icons.person, size: 18.0, color: Colors.black38),
//               const SizedBox(width: 4.0),
//               Text(
//                 text1,
//                 style: const TextStyle(fontSize: 18.0, color: Colors.black38),
//               ),
//             ],
//           ))
//         ],
//       ),
//     );
//   }
// }
