// this class for bottom sheet in home screen

import 'package:flutter/material.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CustomBottomSheet {

  TextEditingController whereEdit = TextEditingController();
  CustomWidget customWidget = CustomWidget();

  /// void showSheetWhereto(BuildContext context, Address addressModle, PlacePredictions placeModle) async {
  //   await showSlidingBottomSheet(context, builder: (context) {
  //     return SlidingSheetDialog(
  //       duration: Duration(seconds: 1),
  //       controller: _sheetController,
  //       elevation: 8,
  //       cornerRadius: 16,
  //       snapSpec: const SnapSpec(
  //         snap: true,
  //         initialSnap: 0.700,
  //         snappings: [0.4, 0.7, 0.700],
  //         positioning: SnapPositioning.relativeToAvailableSpace,
  //       ),
  //       builder: (context, state) {
  //         return GestureDetector(
  //           onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
  //           child: Container(
  //             height: 600,
  //             child: Material(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: GestureDetector(
  //                           onTap: () => Navigator.pop(context),
  //                           child: Icon(
  //                             Icons.arrow_circle_down_outlined,
  //                             color: Colors.grey,
  //                             size: 30,
  //                           )),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(15.0),
  //                       child: TextField(
  //                         maxLength: 25,
  //                         onChanged: (val) {
  //                           _apiSrvPlace.finedPlace(val, addressModle, context);
  //                         },
  //                         controller: whereEdit,
  //                         showCursor: true,
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.w600),
  //                         cursorColor: Color(0xFFFFD54F),
  //                         decoration: InputDecoration(
  //                           fillColor: Color(0xFFFFD54F),
  //                           label: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Text(
  //                               "Where to?",
  //                               style: TextStyle(fontSize: 20),
  //                             ),
  //                           ),
  //                         ),
  //                         keyboardType: TextInputType.text,
  //                       ),
  //                     ),
  //                     Row(
  //                       children: [
  //                         customWidget.containerBox(
  //                             Icon(
  //                               Icons.home,
  //                             ),
  //                             "Home",
  //                             context),
  //                         customWidget.containerBox(
  //                             Icon(
  //                               Icons.work,
  //                             ),
  //                             "Work",
  //                             context),
  //                       ],
  //                     ),
  //                     placeModle.main_text.length < 0 && whereEdit.text.isEmpty
  //                         ? Text("")
  //                         : Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: Container(
  //                               child: ListView.separated(
  //                                 itemBuilder: (context, index) {
  //                                   return _listPlaceWidget
  //                                       .listPlaceInfo(placeModle);
  //                                 },
  //                                 separatorBuilder: (context, index) =>
  //                                     customWidget.customDivider(),
  //                                 itemCount: placeModle.main_text.length,
  //                                 shrinkWrap: true,
  //                                 physics: ClampingScrollPhysics(),
  //                               ),
  //                             ),
  //                           ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  void showSheetCarInfo(
      {required BuildContext context,
      required Image image,
      required String title,
      required String des,
      required IconData iconM,
      required String price,
      required IconData iconP,
      required String person}) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          initialSnap: 0.500,
          snappings: [0.4, 0.7, 0.500],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Container(
            height: 500,
            child: Material(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_circle_down_outlined,
                            color: Colors.grey,
                            size: 30,
                          )),
                    ),
                    Container(height: 150, child: image),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        des,
                        style: TextStyle(fontSize: 16, color: Colors.black45),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customWidget.customDivider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Icon(
                              iconM,
                              size: 25,
                              color: Colors.green,
                            ),
                            Text(price),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              iconP,
                              size: 25,
                            ),
                            Text(person),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
