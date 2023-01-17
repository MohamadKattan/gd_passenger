// this class will show all driver info

import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../config.dart';
import '../my_provider/app_data.dart';
import '../my_provider/placeDetails_drop_provider.dart';
import '../my_provider/position_v_chnge.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/timeTrip_statusRide.dart';
import '../my_provider/true_false.dart';
import '../my_provider/user_id_provider.dart';
import '../repo/auth_srv.dart';
import '../repo/data_base_srv.dart';
import '../tools/tools.dart';
import 'custom_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var uuid = const Uuid();

class DriverInfo {
  Widget driverInfoContainer({
    required BuildContext context,
    required VoidCallback voidCallback,
    required UserIdProvider userIdProvider,
  }) {
    var _colorGreenColors = [
      Colors.greenAccent.shade700,
      Colors.greenAccent.shade200,
      Colors.grey.shade400,
      Colors.greenAccent.shade700,
      Colors.green,
    ];
    var _colorTimeDriver = [Colors.grey, Colors.black, Colors.white];
    var _colorRedColors = [
      Colors.red.shade700,
      Colors.red.shade900,
      Colors.grey,
      Colors.red.shade900,
    ];
    return Consumer<TrueFalse>(
      builder: (BuildContext context, value, Widget? child) {
        return value.showDriverInfoContainer
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          color: Colors.white,
                          offset: Offset(0.7, 0.7))
                    ],
                    color: Colors.white.withOpacity(0.8)),
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .driverStatus,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: Consumer<TimeTripStatusRide>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return AnimatedTextKit(
                                            repeatForever: true,
                                            animatedTexts: [
                                              ColorizeAnimatedText(
                                                _value.statusRude,
                                                textAlign: TextAlign.center,
                                                speed: const Duration(
                                                    milliseconds: 200),
                                                textStyle: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                colors: statusRide == '0'
                                                    ? _colorRedColors
                                                    : _colorGreenColors,
                                              )
                                            ]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  width: newstatusRide ==
                                          AppLocalizations.of(context)!.accepted
                                      ? 130
                                      : 50),
                              Expanded(
                                  flex: 0,
                                  child: Container(
                                    height: 60,
                                    width: newstatusRide ==
                                            AppLocalizations.of(context)!
                                                .accepted
                                        ? 60
                                        : 120,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                            width: 2.5, color: Colors.grey)),
                                    child: Center(
                                      child: Consumer<TimeTripStatusRide>(
                                        builder: (BuildContext context, _value,
                                            Widget? child) {
                                          return AnimatedTextKit(
                                              repeatForever: true,
                                              animatedTexts: [
                                                ColorizeAnimatedText(
                                                    _value.timeTrip == ""
                                                        ? "...."
                                                        : _value.timeTrip,
                                                    textAlign: TextAlign.center,
                                                    speed: const Duration(
                                                        milliseconds: 200),
                                                    textStyle: const TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    colors: _colorTimeDriver)
                                              ]);
                                        },
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 100,
                      ),
                      CustomWidgets().customDivider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: driverImage == ""
                                        ? const Text('')
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white,
                                            child: CachedNetworkImage(
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              imageUrl: driverImage,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.person),
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              width: 2.0, color: Colors.grey)),
                                      child: SmoothStarRating(
                                        allowHalfRating: true,
                                        starCount: 5,
                                        rating: ratDriverRead,
                                        size: 15.0,
                                        color: Colors.yellow.shade700,
                                        borderColor: Colors.yellow.shade700,
                                        spacing: 0.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: Text(
                                      driverName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black87, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Text(
                                      carPlack.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: Text(
                                      carDriverInfo,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black26, fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 100,
                      ),
                      CustomWidgets().customDivider(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 40.0,
                            icon: Icon(Icons.call,
                                color: Colors.greenAccent.shade700),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) =>
                                      CustomWidgets().callDriver(context));
                            },
                          ),
                          IconButton(
                              iconSize: 40.0,
                              color: Colors.black12,
                              icon: Icon(Icons.map,
                                  color: Colors.blueAccent.shade700),
                              onPressed: () => openGoogleMap(context)),
                          IconButton(
                              iconSize: 40.0,
                              icon: Icon(Icons.close,
                                  color: Colors.redAccent.shade700),
                              onPressed: () async {
                                Provider.of<PositionDriverInfoProvider>(context,
                                        listen: false)
                                    .updateState(-400.0);
                                Provider.of<PositionChang>(context,
                                        listen: false)
                                    .changValue(0.0);
                                DataBaseSrv().deleteRideRequest(context);
                                voidCallback();
                              }),
                        ],
                      ),
                    ],
                  ),
                ))
            : const SizedBox();
      },
    );
  }



  Future<void> openGoogleMap(BuildContext context) async {
    final dropOff =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;
    String _url =
        'https://www.google.com/maps/search/?api=1&query=${dropOff.latitude},${dropOff.longitude}';
    await Tools().lunchUrl(context, _url);
  }
}
