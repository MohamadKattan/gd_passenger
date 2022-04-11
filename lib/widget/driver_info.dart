// this class will show all driver info

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/tools/geoFire_methods_tools.dart';
import 'package:gd_passenger/widget/rating_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../model/nearest _driver_ available.dart';
import '../my_provider/close_botton_driverInfo.dart';
import '../my_provider/nearsert_driver_provider.dart';
import '../my_provider/placeDetails_drop_provider.dart';
import '../my_provider/position_v_chnge.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/user_id_provider.dart';
import '../repo/auth_srv.dart';
import '../tools/tools.dart';
import 'divider_box_.dart';

class DriverInfo {
  Widget driverInfoContainer(
      {required BuildContext context,
      required VoidCallback voidCallback,
      required UserIdProvider userIdProvider}) {
    final isCloseTrue =
        Provider.of<CloseButtonProvider>(context, listen: false).isClose;
    return Container(
        height: MediaQuery.of(context).size.height * 35 / 100,
        decoration:  BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  color: Colors.black54,
                  offset: Offset(0.7, 0.7))
            ],
            color: Colors.white.withOpacity(0.8)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                    child: Row(
                  children: [
                    const Text(
                      "Driver Status : ",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(statusRide,
                        style:  TextStyle(
                            color: Colors.green.shade700, fontSize: 15.0)),
                    const Text(
                      " Time : ",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(timeTrip == "" ? "..." : timeTrip,
                        style:  TextStyle(
                            color: Colors.green.shade700, fontSize: 15.0)),
                  ],
                )),
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Car Details : ",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      carDriverInfo,
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Driver name : ",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      driverName,
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ],
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
                      onPressed: () async {
                        // if (!await launch(url)) throw 'Could not launch $url';
                        await canLaunch("tel:$driverPhone")
                            ? launch("tel:$driverPhone")
                            : Tools().toastMsg('Could not launch $driverPhone');
                      },
                    ),
                    statusRide == "Trip Started"
                        ? IconButton(
                            iconSize: 40.0,
                            color: Colors.black12,
                            icon: Icon(Icons.map,
                                color: Colors.blueAccent.shade700),
                            onPressed: () => openGoogleMap(context))
                        : IconButton(
                            iconSize: 40.0,
                            color: Colors.black54,
                            icon: const Icon(Icons.map),
                            onPressed: () => Tools().toastMsg("Wait your Driver")),
                    isCloseTrue == true?
                    IconButton(
                        iconSize: 40.0,
                        icon:
                            Icon(Icons.close, color: Colors.redAccent.shade700),
                        onPressed: () {
                          voidCallback();
                          NearestDriverAvailable _nearestDriverAvailable =
                          NearestDriverAvailable("", 0.0, 0.0);
                          Provider.of<NearestDriverProvider>(context,
                              listen: false)
                              .updateState(_nearestDriverAvailable);
                          Provider.of<PositionDriverInfoProvider>(context,
                              listen: false)
                              .updateState(-400.0);
                          Provider.of<PositionChang>(context, listen: false)
                              .changValue(0.0);
                          deleteRideRequesr();
                          GeoFireMethods.listOfNearestDriverAvailable.clear();
                        })
                        :IconButton(
                        iconSize: 40.0,
                        icon:
                        Icon(Icons.close, color: Colors.redAccent.shade700),
                        onPressed: () {
                          Tools().toastMsg("Wait till finish your trip");
                        })
                  ],
                ),
              ),
              // const SizedBox(height: 10.0),
              // isCloseTrue == true
              //     ? Center(
              //         child: Padding(
              //           padding: const EdgeInsets.all(4.0),
              //           child: GestureDetector(
              //             onTap: () {
              //               voidCallback();
              //               NearestDriverAvailable _nearestDriverAvailable =
              //                   NearestDriverAvailable("", 0.0, 0.0);
              //               Provider.of<NearestDriverProvider>(context,
              //                       listen: false)
              //                   .updateState(_nearestDriverAvailable);
              //               Provider.of<PositionDriverInfoProvider>(context,
              //                       listen: false)
              //                   .updateState(-400.0);
              //               Provider.of<PositionChang>(context, listen: false)
              //                   .changValue(0.0);
              //               deleteRideRequesr();
              //               GeoFireMethods.listOfNearestDriverAvailable.clear();
              //             },
              //             child: Container(
              //               height:
              //                   MediaQuery.of(context).size.height * 6.5 / 100,
              //               width: MediaQuery.of(context).size.width * 70 / 100,
              //               decoration: BoxDecoration(
              //                 color: Colors.redAccent.shade700,
              //                 borderRadius: BorderRadius.circular(15.0),
              //               ),
              //               child: const Center(
              //                   child: Text(
              //                 "Close",
              //                 style: TextStyle(fontSize: 18),
              //               )),
              //             ),
              //           ),
              //         ),
              //       )
              //     : Center(
              //         child: Padding(
              //           padding: const EdgeInsets.all(4.0),
              //           child: GestureDetector(
              //             onTap: () {
              //               Tools().toastMsg("Wait till finish your trip");
              //             },
              //             child: Container(
              //               height:
              //                   MediaQuery.of(context).size.height * 6.5 / 100,
              //               width: MediaQuery.of(context).size.width * 70 / 100,
              //               decoration: BoxDecoration(
              //                 color: Colors.grey.shade700,
              //                 borderRadius: BorderRadius.circular(15.0),
              //               ),
              //               child: Center(
              //                   child: Text(
              //                 "Close",
              //                 style: TextStyle(
              //                     fontSize: 18, color: Colors.redAccent.shade700),
              //               )),
              //             ),
              //           ),
              //         ),
              //       ),
              // :const Text("")
            ],
          ),
        ));
  }

  Future<void> deleteRideRequesr() async {
    final userID = AuthSev().auth.currentUser?.uid;
    DatabaseReference refRideRequest =
        FirebaseDatabase.instance.ref().child("Ride Request").child(userID!);
    await refRideRequest.remove();
  }

  Future<void> openGoogleMap(BuildContext context) async {
    final dropOff=Provider.of<PlaceDetailsDropProvider>(context, listen: false)
        .dropOfLocation;
    String url =
        "https://www.google.com/maps/search/?api=1&query=${dropOff.latitude},${dropOff.longitude}";
    await canLaunch(url)
        ? launch(url)
        : Tools().toastMsg('Could not launch google map');
  }
}
