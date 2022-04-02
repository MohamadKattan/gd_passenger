// this class will show all driver info

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/tools/geoFire_methods_tools.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/nearest _driver_ available.dart';
import '../my_provider/close_botton_driverInfo.dart';
import '../my_provider/nearsert_driver_provider.dart';
import '../my_provider/position_v_chnge.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/user_id_provider.dart';
import '../repo/auth_srv.dart';
import 'divider_box_.dart';

class DriverInfo {
  Widget driverInfoContainer(
      {required BuildContext context,
      required VoidCallback voidCallback,
      required UserIdProvider userIdProvider}) {
    final isCloseTrue =
        Provider.of<CloseButtonProvider>(context, listen: false).isClose;
    return Container(
        height: MediaQuery.of(context).size.height * 45 / 100,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  color: Colors.black54,
                  offset: Offset(0.7, 0.7))
            ],
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: Text(
                "Driver Status : $statusRide : $timeTrip",
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              )),
            ),
            CustomWidget().customDivider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Car Details : $carDriverInfo ",
                style: const TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Driver name : $driverName",
                style: const TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomWidget().customDivider(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 40.0,
                    icon: Icon(Icons.call, color: Colors.greenAccent.shade700),
                    onPressed: () => null,
                  ),
                  IconButton(
                    iconSize: 40.0,
                    color: Colors.black12,
                    icon: const Icon(Icons.details, color: Colors.black45),
                    onPressed: () => null,
                  ),
                  IconButton(
                      iconSize: 40.0,
                      icon:
                          Icon(Icons.star, color: Colors.yellowAccent.shade700),
                      onPressed: () {
                        voidCallback();
                        // DataBaseSrv().cancelRiderRequest(userIdProvider,context);
                        //  Provider.of<PositionDriverInfoProvider>(context,listen: false)
                        //      .updateState(-400.0);
                        //  Provider.of<PositionChang>(context,listen: false).changValue(0.0);
                      }),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            isCloseTrue == true
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          voidCallback();
                          NearestDriverAvailable _nearestDriverAvailable = NearestDriverAvailable("",0.0,0.0);
                          Provider.of<NearestDriverProvider>(context,listen: false).updateState(_nearestDriverAvailable);
                          Provider.of<PositionDriverInfoProvider>(context,
                                  listen: false)
                              .updateState(-400.0);
                          Provider.of<PositionChang>(context, listen: false)
                              .changValue(0.0);
                          deleteRideRequesr();
                          GeoFireMethods.listOfNearestDriverAvailable.clear();
                        },
                        child: Container(
                          height:
                              MediaQuery.of(context).size.height * 6.5 / 100,
                          width: MediaQuery.of(context).size.width * 70 / 100,
                          decoration: BoxDecoration(
                            color: Colors.redAccent.shade700,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: const Center(
                              child: Text(
                            "Close",
                            style: TextStyle(fontSize: 18),
                          )),
                        ),
                      ),
                    ),
                  )
                : const Text(""),
            // :const Text("")
          ],
        ));
  }

  Future<void> deleteRideRequesr() async {
    final userID = AuthSev().auth.currentUser?.uid;
    DatabaseReference refRideRequest = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(userID!);
    await refRideRequest.remove();
  }
}
