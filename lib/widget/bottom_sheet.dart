// this class for bottom sheet in home screen

import 'package:flutter/material.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CustomBottomSheet {

  TextEditingController whereEdit = TextEditingController();
  CustomWidget customWidget = CustomWidget();

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
          return SizedBox(
            height: 500,
            child: Material(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_circle_down_outlined,
                            color: Colors.grey,
                            size: 30,
                          )),
                    ),
                    SizedBox(height: 150, child: image),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        des,
                        style: const TextStyle(fontSize: 16, color: Colors.black45),
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
