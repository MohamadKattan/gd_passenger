// this class for container user cancel his request a taxi

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/posotoion_cancel_request.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CancelTaxi {
  Widget cancelTaxiRequest(
      {required BuildContext context, required VoidCallback voidCallback}) {
    return Container(
      height: MediaQuery.of(context).size.height * 40 / 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
                blurRadius: 6.0,
                spreadRadius: 0.5,
                color: Colors.black54,
                offset: Offset(0.7, 0.7))
          ],
          color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                  child: Lottie.asset('assets/71796-searching-taxi.json',
                      height: 150, width: 250,fit: BoxFit.contain)),
            ),
            Text(
              "Searching a driver...",
              style: TextStyle(color: Colors.black45),
            ),
            GestureDetector(
                onTap: () {
                  voidCallback;
                  Provider.of<PosotionCancelReq>(context, listen: false)
                      .updateValue(-400.0);
                  Provider.of<PositionChang>(context, listen: false).changValue(0.0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 40.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              color: Colors.black54,
                              offset: Offset(0.7, 0.7))
                        ],
                        color: Colors.redAccent[700]),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
