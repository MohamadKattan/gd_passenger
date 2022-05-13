// this dailog if rider chose a van or veto car it will show dailog price in turkey $100

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/car_tupy_provider.dart';
import 'divider_box_.dart';

Widget vetoVanPriceTurkeyJust(BuildContext context){
  final carTypePro = Provider.of<CarTypeProvider>(context,listen: false).carType;
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 45 / 100,
      width: double.infinity,
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Lottie.asset('assets/84965-warning-yellow.json',fit: BoxFit.fill,
                    height: 160, width: 160)),
              Padding(
               padding: const EdgeInsets.all(8.0),
               child: Center(
                 child: Text(
                  "Order this type of car just for trip 10 hour cost : \$${carTypePro=="Medium commercial-6-10 seats"?"100":"120"} ",textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,),
            ),
               ),
             ),
            SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
            CustomWidget().customDivider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 30 / 100,
                    height: MediaQuery.of(context).size.height * 8 / 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.greenAccent.shade700),
                    child: const Center(
                        child: Text(
                          "Ok",
                          style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
