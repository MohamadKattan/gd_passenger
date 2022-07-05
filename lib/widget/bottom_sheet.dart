// this class for bottom sheet in home screen

import 'package:flutter/material.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:provider/provider.dart';
import '../my_provider/sheet_cardsc.dart';




class CustomBottomSheet {

  TextEditingController whereEdit = TextEditingController();
  CustomWidget customWidget = CustomWidget();

  Widget showSheetCarInfoTaxi(
      {required BuildContext context,
        required Image image,
        required String title,
        required String des,
        required IconData iconM,
        required String price,
        required IconData iconP,
        required String person}){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0)
      ),
      height: 350,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: ()=>  Provider.of<SheetCarDesc>(context,listen: false).updateStateTaxi(-400),
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
      required String person}){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0)
      ),
      height: 350,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: ()=>  Provider.of<SheetCarDesc>(context,listen: false).updateStateMed(-400),
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
        required String person}){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0)
      ),
      height: 350,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: ()=>  Provider.of<SheetCarDesc>(context,listen: false).updateStateBig(-400),
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
    );
  }
}
