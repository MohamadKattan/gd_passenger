// this class will show all driver info

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/tools/geoFire_methods_tools.dart';
import 'package:gd_passenger/widget/rating_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../model/nearest _driver_ available.dart';
import '../my_provider/app_data.dart';
import '../my_provider/close_botton_driverInfo.dart';
import '../my_provider/nearsert_driver_provider.dart';
import '../my_provider/placeDetails_drop_provider.dart';
import '../my_provider/position_v_chnge.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/user_id_provider.dart';
import '../repo/auth_srv.dart';
import '../tools/tools.dart';
import 'call_driver.dart';
import 'divider_box_.dart';
import 'package:uuid/uuid.dart';
var uuid = const Uuid();

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
                    Text(timeTrip == "" ? "...." : timeTrip,
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
                    const SizedBox(width: 10.0),
                    SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: ratDriverRead,
                      size: 15.0,
                      color: Colors.yellow.shade700,
                      borderColor: Colors.yellow.shade700,
                      spacing:0.0,
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
                     showDialog(context: context,
                         barrierDismissible: false,
                         builder:(_)=>callDriver(context));
                      },
                    ),
                    // statusRide == "Trip Started"
                        IconButton(
                            iconSize: 40.0,
                            color: Colors.black12,
                            icon: Icon(Icons.map,
                                color: Colors.blueAccent.shade700),
                            onPressed: () => openGoogleMap(context)),
                    isCloseTrue == true?
                    IconButton(
                        iconSize: 40.0,
                        icon:
                            Icon(Icons.close, color: Colors.redAccent.shade700),
                        onPressed: () async {
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
                        await   deleteRideRequesr(context);
                            GeoFireMethods.listOfNearestDriverAvailable.clear();

                        }):const Text(""),
                    IconButton(
                        iconSize: 40.0,
                        icon:
                        Icon(Icons.star, color: Colors.yellow.shade700),
                        onPressed: () {
                          showDialog(context: context,barrierDismissible: false, builder:(_)=>
                          const RatingWidget()
                          );
                        }),

                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> deleteRideRequesr(BuildContext context) async {
    final pickUpLoc=Provider.of<AppData>(context, listen: false).pickUpLocation;
    final dropOffLoc=
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;
    final userID = AuthSev().auth.currentUser?.uid;
    DatabaseReference ref =
    FirebaseDatabase.instance.ref()
        .child("users")
        .child(userID!)
        .child("history")
        .child(uuid.v4());
    ref.set({
      "pickAddress":pickUpLoc.placeName,
      "dropAddress":dropOffLoc.placeName,
      "trip":"don",
    }).whenComplete(() async {
      DatabaseReference refRideRequest =
      FirebaseDatabase.instance.ref().child("Ride Request").child(userID);
      await refRideRequest.remove();
    });
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
