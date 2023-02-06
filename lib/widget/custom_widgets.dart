import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../config.dart';
import '../google_map_methods.dart';
import '../my_provider/dropBottom_value.dart';
import '../my_provider/google_set_provider.dart';
import '../my_provider/timeTrip_statusRide.dart';
import '../my_provider/user_id_provider.dart';
import '../repo/data_base_srv.dart';
import '../tools/geoFire_methods_tools.dart';
import '../tools/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomWidgets {
  var uuid = const Uuid();

// this widget for show list of tur cities
  Widget listOfTurCity(BuildContext context, List<dynamic> list) {
    return Dialog(
      elevation: 0.9,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color(0xFF00A3E0),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14.0),
                    topLeft: Radius.circular(14.0))),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.torzimTrip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.pricesList,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          // var googleMapState =
                          //     Provider.of<GoogleMapSet>(context, listen: false);
                          // noChangeToTaxi = false;
                          // GeoFireMethods.listOfNearestDriverAvailable.clear();
                          // googleMapState.markersSet.clear();
                          // geoFireRadios = 2;
                          // await LogicGoogleMap().geoFireInitialize(context);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.redAccent,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 55 / 100,
              width: double.infinity,
              color: Colors.white,
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          tourismCityName = list[index][0].toString();
                          tourismCityPrice = list[index][1].toString();
                          LogicGoogleMap()
                              .tourismCities(tourismCityName, context);
                        },
                        child: Container(
                            width: double.infinity,
                            height: 55.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                  width: 1.0, color: const Color(0xFFFBC408)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    list[index][2].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00A3E0),
                                        fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "\$${list[index][1].toString()}",
                                      style: const TextStyle(
                                          color: Color(0xFF00A3E0),
                                          fontSize: 20.0),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  })),

          ///oldCode
          // SingleChildScrollView(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Container(
          //         decoration: const BoxDecoration(
          //             color: Color(0xFF00A3E0),
          //             borderRadius: BorderRadius.only(
          //                 topRight: Radius.circular(14.0),
          //                 topLeft: Radius.circular(14.0))),
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text(
          //           AppLocalizations.of(context)!.torzimTrip,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 12.0,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text(
          //               AppLocalizations.of(context)!.pricesList,
          //               style: const TextStyle(
          //                 color: Color(0xFF00A3E0),
          //                 fontSize: 20.0,
          //               ),
          //               textAlign: TextAlign.center,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //           ),
          //           IconButton(
          //               onPressed: () => Navigator.pop(context),
          //               icon: const Icon(
          //                 Icons.close,
          //                 color: Colors.redAccent,
          //               )),
          //         ],
          //       ),
          //       customDivider(),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             //   tourismCityName = "istanbul";
          //             //   tourismCityPrice = "100";
          //             // });
          //             tourismCityName = "istanbul";
          //             tourismCityPrice = "100";
          //             LogicGoogleMap().tourismCities(tourismCityName, context);
          //           },
          //           child: Container(
          //               width: double.infinity,
          //               height: 55.0,
          //               decoration: BoxDecoration(
          //                   border: Border.all(
          //                       width: 2.0, color: const Color(0xFFFBC408)),
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(4.0)),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Text(
          //                       AppLocalizations.of(context)!.istanbul,
          //                       style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 16.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   const Expanded(
          //                     flex: 0,
          //                     child: Padding(
          //                       padding: EdgeInsets.all(8.0),
          //                       child: Text(
          //                         "\$100",
          //                         style: TextStyle(
          //                             color: Color(0xFF00A3E0), fontSize: 20.0),
          //                         textAlign: TextAlign.center,
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             //   tourismCityName = "bursa";
          //             //   tourismCityPrice = "220";
          //             // });
          //             tourismCityName = "bursa";
          //             tourismCityPrice = "220";
          //             LogicGoogleMap().tourismCities(tourismCityName, context);
          //           },
          //           child: Container(
          //               width: double.infinity,
          //               height: 55.0,
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(4.0),
          //                 border: Border.all(
          //                     width: 2.0, color: const Color(0xFFFBC408)),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Text(
          //                       AppLocalizations.of(context)!.bursa,
          //                       style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 16.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   const Expanded(
          //                     flex: 0,
          //                     child: Padding(
          //                       padding: EdgeInsets.all(8.0),
          //                       child: Text(
          //                         "\$220",
          //                         style: TextStyle(
          //                             color: Color(0xFF00A3E0), fontSize: 20.0),
          //                         textAlign: TextAlign.center,
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             //   tourismCityName = "izmit";
          //             //   tourismCityPrice = "150";
          //             // });
          //             tourismCityName = "izmit";
          //             tourismCityPrice = "150";
          //             LogicGoogleMap().tourismCities(tourismCityName, context);
          //           },
          //           child: Container(
          //               width: double.infinity,
          //               height: 55.0,
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(4.0),
          //                 border: Border.all(
          //                     width: 2.0, color: const Color(0xFFFBC408)),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Text(
          //                       AppLocalizations.of(context)!.izmit,
          //                       style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 16.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   const Expanded(
          //                     flex: 0,
          //                     child: Padding(
          //                       padding: EdgeInsets.all(8.0),
          //                       child: Text(
          //                         "\$150",
          //                         style: TextStyle(
          //                             color: Color(0xFF00A3E0), fontSize: 20.0),
          //                         textAlign: TextAlign.center,
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             //   tourismCityName = "sapanca";
          //             //   tourismCityPrice = "180";
          //             // });
          //             tourismCityName = "sapanca";
          //             tourismCityPrice = "180";
          //             LogicGoogleMap().tourismCities(tourismCityName, context);
          //           },
          //           child: Container(
          //               width: double.infinity,
          //               height: 55.0,
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(4.0),
          //                 border: Border.all(
          //                     width: 2.0, color: const Color(0xFFFBC408)),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Text(
          //                       AppLocalizations.of(context)!.sabanjah,
          //                       style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 16.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   const Expanded(
          //                     flex: 0,
          //                     child: Padding(
          //                       padding: EdgeInsets.all(8.0),
          //                       child: Text(
          //                         "\$180",
          //                         style: TextStyle(
          //                             color: Color(0xFF00A3E0), fontSize: 20.0),
          //                         textAlign: TextAlign.center,
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             //   tourismCityName = "Bolu abant";
          //             //   tourismCityPrice = "300";
          //             // });
          //             tourismCityName = "Bolu abant";
          //             tourismCityPrice = "300";
          //             LogicGoogleMap().tourismCities(tourismCityName, context);
          //           },
          //           child: Container(
          //               width: double.infinity,
          //               height: 55.0,
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(4.0),
          //                 border: Border.all(
          //                     width: 2.0, color: const Color(0xFFFBC408)),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Text(
          //                       AppLocalizations.of(context)!.polo,
          //                       style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 16.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   const Padding(
          //                     padding: EdgeInsets.all(8.0),
          //                     child: Text(
          //                       "\$300",
          //                       style: TextStyle(
          //                           color: Color(0xFF00A3E0), fontSize: 20.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             //   tourismCityName = "şile";
          //             //   tourismCityPrice = "170";
          //             // });
          //             tourismCityName = "şile";
          //             tourismCityPrice = "170";
          //             LogicGoogleMap().tourismCities(tourismCityName, context);
          //           },
          //           child: Container(
          //               width: double.infinity,
          //               height: 55.0,
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(4.0),
          //                 border: Border.all(
          //                     width: 2.0, color: const Color(0xFFFBC408)),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Text(
          //                       AppLocalizations.of(context)!.sala,
          //                       style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 16.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   const Expanded(
          //                     flex: 0,
          //                     child: Padding(
          //                       padding: EdgeInsets.all(8.0),
          //                       child: Text(
          //                         "\$170",
          //                         style: TextStyle(
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 20,
          //                         ),
          //                         textAlign: TextAlign.center,
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             // setState(() {
          //             //   tourismCityName = "yalova";
          //             //   tourismCityPrice = "170";
          //             // });
          //             tourismCityName = "yalova";
          //             tourismCityPrice = "170";
          //             LogicGoogleMap().tourismCities(tourismCityName, context);
          //           },
          //           child: Container(
          //               width: double.infinity,
          //               height: 55.0,
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(4.0),
          //                 border: Border.all(
          //                     width: 2.0, color: const Color(0xFFFBC408)),
          //               ),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Text(
          //                       AppLocalizations.of(context)!.yalua,
          //                       style: const TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           color: Color(0xFF00A3E0),
          //                           fontSize: 16.0),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                   const Padding(
          //                     padding: EdgeInsets.all(8.0),
          //                     child: Text(
          //                       "\$170",
          //                       style: TextStyle(
          //                         color: Color(0xFF00A3E0),
          //                         fontSize: 20.0,
          //                       ),
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // if rider want  call  driver who accepted his request
  Widget callDriver(BuildContext context) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    AppLocalizations.of(context)!.callDriver,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.red))
                ],
              ),
              GestureDetector(
                onTap: () async {
                  String _url = 'tel:$driverPhone';
                  await Tools().lunchUrl(context, _url);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call, color: Colors.greenAccent.shade700),
                      const SizedBox(width: 8.0),
                      Text(AppLocalizations.of(context)!.normalCall,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  String _url = 'https://wa.me/$driverPhone';
                  await Tools().lunchUrl(context, _url);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call, color: Colors.greenAccent.shade700),
                      const SizedBox(width: 8.0),
                      Text(AppLocalizations.of(context)!.whatsApp,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// if rider click on car icon on map to call any driver
  Widget callDriverOnMap(BuildContext context, String phone) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    AppLocalizations.of(context)!.callDriver,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        // driverPhoneOnMap='';
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.red))
                ],
              ),
              GestureDetector(
                onTap: () async {
                  String _url = 'tel:$phone';
                  await Tools().lunchUrl(context, _url);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call, color: Colors.greenAccent.shade700),
                      const SizedBox(width: 8.0),
                      Text(AppLocalizations.of(context)!.normalCall,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  String _url = 'https://wa.me/$phone';
                  await Tools().lunchUrl(context, _url);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call, color: Colors.greenAccent.shade700),
                      const SizedBox(width: 8.0),
                      Text(AppLocalizations.of(context)!.whatsApp,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// if rider want to complain on driver while trip started
  Widget complainOnDriver(BuildContext context) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 20 / 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.issue,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () async {
                  String _url = 'https://wa.me/+905057743644';
                  await Tools().lunchUrl(context, _url);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xFFFBC408)),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.callAs,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// collectMoney dialog when trip fished
  Widget collectMoney(BuildContext context, int totalAmount) {
    final dropBottomProvider =
        Provider.of<DropBottomValue>(context).valueDropBottom;
    final currencyType = Provider.of<TimeTripStatusRide>(context).currencyType;
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 275,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Lottie.asset('assets/51765-cash.json',
                      height: 90, width: 90)),
              Text(
                AppLocalizations.of(context)!.amountTrip,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "${AppLocalizations.of(context)!.paymentMethod} $dropBottomProvider",
                    style:
                        const TextStyle(color: Colors.white, fontSize: 16.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "${AppLocalizations.of(context)!.total}  $totalAmount $currencyType",
                    style:
                        const TextStyle(color: Colors.white, fontSize: 16.0)),
              ),
              customDivider(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, "close");
                  },
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: const Color(0xFFFBC408)),
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)!.ok,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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

// circularInductor when loading prose
  Widget circularInductorCostem(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Lottie.asset('assets/lf30_editor_lzxfkcgw.json',
                  height: 250, width: 250)),
        ],
      ),
    );
  }

  // divider
  Widget customDivider() {
    return Container(
      height: 0.6,
      decoration: const BoxDecoration(color: Colors.black12, boxShadow: [
        BoxShadow(
            blurRadius: 5.0,
            spreadRadius: 0.4,
            color: Colors.black54,
            offset: Offset(0.6, 0.6))
      ]),
    );
  }

// Home and work box in home screen
//   Widget containerBox (Icon icon, String text, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Container(
//         height: MediaQuery.of(context).size.height * 5.0 / 100,
//         width: MediaQuery.of(context).size.width * 40 / 100,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(4.0),
//             boxShadow: const [
//               BoxShadow(
//                   blurRadius: 4.0,
//                   spreadRadius: 0.3,
//                   color: Colors.black54,
//                   offset: Offset(0.4, 0.4))
//             ]),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Icon(
//                   icon.icon,
//                   color: const Color(0xFFFFD54F),
//                   size: 20,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: Center(
//                 child: Text(
//                   text,
//                   style: const TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

  /// car type box taxi/van/veto
  Widget carTypeBox(
      {required Image image,
      required String text,
      required Color mainColor,
      required String text1,
      required Color subColor,
      required BuildContext context}) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Expanded(
            child: image,
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: mainColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 18.0, color: Colors.black38),
              const SizedBox(width: 4.0),
              Text(
                text1,
                style: TextStyle(fontSize: 18.0, color: subColor),
              ),
            ],
          ))
        ],
      ),
    );
  }

// to notify user we send to his email rest pass word
  Widget sendPassDon(BuildContext context) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 175,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.emailCheck,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      overflow: TextOverflow.fade),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                  width: 160,
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFBC408),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0.10, 0.7),
                            spreadRadius: 0.9)
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// no Driver available
  Widget sorryNoDriverDialog(
      BuildContext context, UserIdProvider userProvider) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Lottie.asset('assets/85557-empty.json',
                      fit: BoxFit.contain, height: 130, width: 130)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.sorry,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // Provider.of<PositionCancelReq>(context, listen: false)
                  //     .updateValue(-400.0);
                  // Provider.of<PositionChang>(context, listen: false)
                  //     .changValue(0.0);
                  await DataBaseSrv().cancelRiderRequest(userProvider, context);
                  Navigator.pop(context, 0);
                },
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 160.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: const Color(0xFFFBC408)),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// this buttons for book ahead or tourism trip in main container
  Widget buttons({
    required BuildContext context,
    required String title,
    required Color color,
    required VoidCallback voidCallback,
    required double valBorderR,
    required double valBorderL,
  }) {
    const _colorizeColors = [
      Colors.black,
      Colors.white,
      Colors.black,
      Colors.white,
    ];
    const _colorizeTextStyle = TextStyle(
      fontSize: 20.0,
      fontFamily: 'Horizon',
    );
    return GestureDetector(
      onTap: () {
        voidCallback();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 50 / 100,
        height: MediaQuery.of(context).size.width * 12 / 100,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              color.withOpacity(0.6),
              color.withOpacity(0.6),
              color.withOpacity(0.7),
              color.withOpacity(0.8),
              color.withOpacity(0.9),
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(valBorderL),
                topRight: Radius.circular(valBorderR))),
        child: Center(
          child: AnimatedTextKit(
            onTap: () => voidCallback(),
            repeatForever: true,
            animatedTexts: [
              FadeAnimatedText(
                title,
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              ScaleAnimatedText(
                title,
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              RotateAnimatedText(
                title,
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                rotateOut: true,
                duration: const Duration(milliseconds: 500),
              ),
              ColorizeAnimatedText(
                title,
                textAlign: TextAlign.center,
                speed: const Duration(milliseconds: 300),
                textStyle: _colorizeTextStyle,
                colors: _colorizeColors,
              ),
            ],
          ),
        ),
      ),
    );
  }

// this Dialog when user click on tourism btn to choose car type before show list of city's
  Widget choseCarTypeBeforOrderTourismTrip(
      BuildContext context, VoidCallback voidCallback) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedTextKit(repeatForever: true, animatedTexts: [
                    ColorizeAnimatedText(
                        AppLocalizations.of(context)!.tourismTrips,
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 300),
                        textStyle: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        colors: [Colors.white60, Colors.black, Colors.white])
                  ]),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ))
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.tourismTripsDes,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      voidCallback();
                      Tools().changeAllProClickVetoBox(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFBC408),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '${AppLocalizations.of(context)!.mediumCommercial}\n 6-10',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      voidCallback();
                      Tools().changeAllProClickVanBox(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFBC408),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          '${AppLocalizations.of(context)!.bigCommercial}\n 10-19',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
