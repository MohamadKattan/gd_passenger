// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
//
// class CustomButton {
//   Widget buttons({
//     required BuildContext context,
//     required String title,
//     required Color color,
//     required VoidCallback voidCallback,
//     required double valBorderR,
//     required double valBorderL,
//   }) {
//     const _colorizeColors = [
//       Colors.black,
//       Colors.white,
//       Colors.black,
//       Colors.white,
//     ];
//     const _colorizeTextStyle = TextStyle(
//       fontSize: 20.0,
//       fontFamily: 'Horizon',
//     );
//     return GestureDetector(
//       onTap: () {
//         voidCallback();
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width * 50 / 100,
//         height: MediaQuery.of(context).size.height * 10 / 100,
//         padding: const EdgeInsets.all(8),
//         margin: const EdgeInsets.only(bottom: 8),
//         decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [
//               color.withOpacity(0.6),
//               color.withOpacity(0.6),
//               color.withOpacity(0.7),
//               color.withOpacity(0.8),
//               color.withOpacity(0.9),
//             ], begin: Alignment.bottomRight, end: Alignment.topLeft),
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(valBorderL),
//                 topRight: Radius.circular(valBorderR))),
//         child: Center(
//           child: AnimatedTextKit(
//             onTap: ()=>voidCallback(),
//             repeatForever: true,
//             animatedTexts: [
//               FadeAnimatedText(
//                 title,
//                 textAlign: TextAlign.center,
//                 textStyle: const TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black54,
//                 ),
//               ),
//               ScaleAnimatedText(
//                 title,
//                 textAlign: TextAlign.center,
//                 textStyle: const TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black54,
//                 ),
//               ),
//               RotateAnimatedText(
//                 title,
//                 textAlign: TextAlign.center,
//                 textStyle: const TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black54,
//                 ),
//                 rotateOut: true,
//                 duration: const Duration(milliseconds: 500),
//               ),
//               ColorizeAnimatedText(
//                 title,
//                 textAlign: TextAlign.center,
//                 speed: const Duration(milliseconds: 300),
//                 textStyle: _colorizeTextStyle,
//                 colors: _colorizeColors,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
