// this class for bottom sheet in home screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/sheet_cardsc.dart';

class CustomBottomSheet {
  Widget showSheetCarInfoTaxi(
      {required BuildContext context,
      required Image image,
      required String title,
      required String des,
      required IconData iconM,
      required String price,
      required IconData iconP,
      required String person}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
      height: 250,
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            top: -5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => Provider.of<SheetCarDesc>(context, listen: false)
                      .updateStateTaxi(-400),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFFBC408),
                    size: 40,
                  )),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            top: 35.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF00A3E0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
              right: 0.0,
              left: 0.0,
              top: 70.0,
              child: Center(child: SizedBox(height: 90, child: image))),
          Positioned(
              right: 0.0,
              left: 0.0,
              top: 170,
              child: Image.asset("assets/blueBox.png")),
          Positioned(
            right: 0.0,
            left: 0.0,
            top: 180.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                des,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 5.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Icon(
                      iconM,
                      size: 25,
                      color: Colors.green,
                    ),
                    Text(price),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      iconP,
                      size: 25,
                      color: Colors.white,
                    ),
                    Text(person, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showSheetCarInfoMedeum(
      {required BuildContext context,
      required Image image,
      required String title,
      required String des,
      required IconData iconM,
      required String price,
      required IconData iconP,
      required String person}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      height: 250,
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            top: -5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => Provider.of<SheetCarDesc>(context, listen: false)
                      .updateStateMed(-400),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFFBC408),
                    size: 40,
                  )),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            top: 35.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF00A3E0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
              right: 0.0,
              left: 0.0,
              top: 70.0,
              child: Center(child: SizedBox(height: 90, child: image))),
          Positioned(
              right: 0.0,
              left: 0.0,
              top: 170,
              child: Image.asset("assets/blueBox.png")),
          Positioned(
            right: 0.0,
            left: 0.0,
            top: 180.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                des,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 5.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Icon(
                      iconM,
                      size: 25,
                      color: Colors.green,
                    ),
                    Text(price),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      iconP,
                      size: 25,
                      color: Colors.white,
                    ),
                    Text(person, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showSheetCarInfoBig(
      {required BuildContext context,
      required Image image,
      required String title,
      required String des,
      required IconData iconM,
      required String price,
      required IconData iconP,
      required String person}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      height: 250,
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            top: -5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => Provider.of<SheetCarDesc>(context, listen: false)
                      .updateStateBig(-400),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFFBC408),
                    size: 40,
                  )),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            top: 35.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Color(0xFF00A3E0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
              right: 0.0,
              left: 0.0,
              top: 70.0,
              child: Center(child: SizedBox(height: 90, child: image))),
          Positioned(
              right: 0.0,
              left: 0.0,
              top: 170,
              child: Image.asset("assets/blueBox.png")),
          Positioned(
            right: 0.0,
            left: 0.0,
            top: 180.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                des,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 5.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Icon(
                      iconM,
                      size: 25,
                      color: Colors.green,
                    ),
                    Text(price),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      iconP,
                      size: 25,
                      color: Colors.white,
                    ),
                    Text(person, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
