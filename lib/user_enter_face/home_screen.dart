import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/google_map_methods.dart';
import 'package:gd_passenger/model/directions_details.dart';
import 'package:gd_passenger/my_provider/car_tupy_provider.dart';
import 'package:gd_passenger/my_provider/double_value.dart';
import 'package:gd_passenger/my_provider/dropBottom_value.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/my_provider/lineTaxiProvider.dart';
import 'package:gd_passenger/my_provider/opictyProvider.dart';
import 'package:gd_passenger/my_provider/placeDetails_drop_provider.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/posotoion_cancel_request.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/repo/api_srv_dir.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/search_screen.dart';
import 'package:gd_passenger/widget/bottom_sheet.dart';
import 'package:gd_passenger/widget/coustom_drawer.dart';
import 'package:gd_passenger/widget/rider_cancel_rquest.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../model/address.dart';
import '../my_provider/buttom_color_pro.dart';
import '../my_provider/google_set_provider.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/sheet_cardsc.dart';
import '../my_provider/true_false.dart';
import '../repo/api_srv_geo.dart';
import '../tools/geoFire_methods_tools.dart';
import '../tools/notify_driver_method.dart';
import '../widget/custom_widgets.dart';
import '../widget/driver_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'advance_reservation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ApiSrvGeo().getCountry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearAll();
  }

  void _asyncMethod() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomWidgets().circularInductorCostem(context));
      await LogicGoogleMap().locationPosition(context).whenComplete(() async {
      await LogicGoogleMap().geoFireInitialize(context);
      await DataBaseSrv().currentOnlineUserInfo(context);
      Navigator.pop(context);
      audioCache = AudioCache(fixedPlayer: audioPlayer, prefix: "assets/");
      await trickMyTripAfterKilled();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserIdProvider>(context, listen: false);
    createDriverNearIcon();
    createDriverNearIcon1();
    userProvider.getUserIdProvider();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white12,
          body: Builder(
            builder: (context) => SafeArea(
              child: Stack(
                children: [
                  customDrawer(context),
                  Consumer<DoubleValue>(
                    builder: (BuildContext context, value, Widget? child) {
                      return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.0, end: value.value),
                          duration: const Duration(milliseconds: 500),
                          builder: (_, double val, __) {
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..setEntry(0, 3, 300 * val)
                                ..rotateY((pi / 3) * val),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    googleMap(),

                                    /// disCount pop countainer 10%
                                    disCountContainer(),

                                    /// main container what include car types car drop button request button
                                    Consumer<PositionChang>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return mainBord(
                                            context, _value, userProvider);
                                      },
                                    ),

                                    /// sheet Car desc
                                    Consumer<SheetCarDesc>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return sheetTaxi(context, _value);
                                      },
                                    ),
                                    Consumer<SheetCarDesc>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return sheetVeto(context, _value);
                                      },
                                    ),
                                    Consumer<SheetCarDesc>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return sheetVan(context, _value);
                                      },
                                    ),

                                    ///cancel container
                                    Consumer<PositionCancelReq>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return cancelBord(
                                            context, _value, userProvider);
                                      },
                                    ),

                                    ///driver info
                                    Consumer<PositionDriverInfoProvider>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return driverInfoBord(
                                            context, _value, userProvider);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  btnDrawer(),

                  /// complain button
                  btnComplainOnDriver(),
                ],
              ),
            ),
          )),
    );
  }

  ///=========================main widgets ======================================
  // this widget for googleMap
  Widget googleMap() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 60 / 100,
      width: MediaQuery.of(context).size.width,
      child: Consumer<GoogleMapSet>(
        builder: (BuildContext context, value, Widget? child) {
          return GoogleMap(
            padding: const EdgeInsets.only(bottom: 95.0),
            mapType: MapType.normal,
            initialCameraPosition: LogicGoogleMap().kGooglePlex,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            polylines: value.polylineSet,
            markers: value.markersSet,
            circles: value.circlesSet,
            onMapCreated: (GoogleMapController controller) async {
              LogicGoogleMap().controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
            },
          );
        },
      ),
    );
  }

  // this widget for show pop 10% discount
  Widget disCountContainer() {
    return Consumer<PositionChang>(
      builder: (BuildContext context, value, Widget? child) {
        return value.discountVal == -700.0
            ? const SizedBox()
            : AnimatedPositioned(
                top: value.discountVal,
                left: 25.0,
                right: 25.0,
                height: 200,
                duration: const Duration(milliseconds: 1200),
                curve: Curves.bounceInOut,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0)),
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      Positioned(
                          left: 0.0,
                          right: 0.0,
                          child: Image.asset(
                            'assets/10dis.png',
                            fit: BoxFit.fill,
                            height: 175,
                          )),
                      Positioned(
                        right: 0.0,
                        top: -20.0,
                        child: AnimatedTextKit(
                            pause: const Duration(milliseconds: 200),
                            repeatForever: true,
                            animatedTexts: [
                              ScaleAnimatedText(
                                  AppLocalizations.of(context)!.wow,
                                  textStyle: const TextStyle(
                                      color: Color(0xFFFBC408),
                                      shadows: [
                                        Shadow(
                                          blurRadius: 7.0,
                                          color: Colors.grey,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                      fontSize: 70,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                      Positioned(
                          top: 50,
                          right: 0.0,
                          child: AnimatedTextKit(
                            pause: const Duration(milliseconds: 200),
                            repeatForever: true,
                            animatedTexts: [
                              ColorizeAnimatedText(
                                AppLocalizations.of(context)!.discount,
                                textAlign: TextAlign.center,
                                colors: [const Color(0xFF00A3E0), Colors.black],
                                textStyle: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ))
                    ],
                  ),
                ));
      },
    );
  }

// this widget main user bord
  Widget mainBord(
      BuildContext context, PositionChang _value, UserIdProvider userProvider) {
    var carTypePro =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        right: 0.0,
        left: 0.0,
        bottom: _value.val,
        curve: Curves.ease,
        child: Container(
          // // padding:
          //     const EdgeInsets.all(8.0),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                btnTripAdvanceReservation(),
                whereToGo(),
                rowOfCarTypeBox(),

                /// drop of botton
                Consumer<DropBottomValue>(
                  builder: (BuildContext context, _value, Widget? child) {
                    return dropBottomCustom(context, _value.valueDropBottom);
                  },
                ),

                /// request button
                Consumer<GoogleMapSet>(
                  builder: (BuildContext context, val, Widget? child) {
                    return GestureDetector(
                        onTap: () async {
                          if (val.tripDirectionDetail != null) {
                            NotifyDriver()
                                .gotKeyOfDriver(userProvider, context);
                            // countFullTimeRequest(userProvider);
                            Provider.of<PositionCancelReq>(context,
                                    listen: false)
                                .updateValue(0.0);
                            Provider.of<PositionChang>(context, listen: false)
                                .changValue(-500.0);
                            final int amount = checkAnyAmount(
                                carTypePro!, val.tripDirectionDetail!);
                            DataBaseSrv().saveRiderRequest(context, amount);
                            state = "requesting";
                          } else {
                            Tools().toastMsg(
                                AppLocalizations.of(context)!.chooseBefore,
                                Colors.red);
                          }
                        },
                        child: AnimatedContainer(
                          margin: const EdgeInsets.only(top: 12.0, bottom: 30),
                          duration: const Duration(milliseconds: 1000),
                          height:
                              MediaQuery.of(context).size.height * 6.5 / 100,
                          width: MediaQuery.of(context).size.width * 70 / 100,
                          decoration: BoxDecoration(
                            color: val.tripDirectionDetail != null
                                ? const Color(0xFFFBC408)
                                : const Color(0xFF00A3E0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context)!.requestTaxi,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  // this widget include buttons tourism Trip and AdvanceReservation in mainBord
  Widget btnTripAdvanceReservation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomWidgets().buttons(
            context: context,
            title: AppLocalizations.of(context)!.bookAHead,
            color: const Color(0xFFFBC408),
            valBorderL: 12,
            valBorderR: 0,
            voidCallback: () {
              Navigator.of(context).push(
                  Tools().createRoute(context, const AdvanceReservation()));
            }),
        CustomWidgets().buttons(
            context: context,
            title: AppLocalizations.of(context)!.tourismTrips,
            color: const Color(0xFF00A3E0),
            valBorderL: 0,
            valBorderR: 12,
            voidCallback: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return CustomWidgets()
                        .choseCarTypeBeforOrderTourismTrip(context, () {
                      startOpenTripCity();
                    });
                  });
            })
      ],
    );
  }

// this widget in cloud whereToGo search failed mainBord
  Widget whereToGo() {
    return Consumer<GoogleMapSet>(
      builder: (BuildContext context, value, Widget? child) {
        return Expanded(
          flex: 0,
          child: GestureDetector(
            onTap: () async {
              final res = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const SearchScreen();
              }));
              if (res == "dataDir") {
                await LogicGoogleMap().getPlaceDirection(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 4.0),
              margin: const EdgeInsets.only(bottom: 4.0, left: 4.0, right: 4.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  border:
                      Border.all(width: 1.0, color: const Color(0xFFFBC408))),
              width: MediaQuery.of(context).size.width * 100,
              height: MediaQuery.of(context).size.width * 15.0 / 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: searchIconOrCancelBottom(value.tripDirectionDetail),
                  ),
                  changeTextWhereToOrTollpasses(value.tripDirectionDetail),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// this widget in cloud car box type taxi/van/veto mainBord
  Widget rowOfCarTypeBox() {
    return Container(
      margin:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
      height: 65.0,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!noChangeToTaxi) {
                    Tools().changeAllProClickTaxiBox(context);
                  }
                },
                child: Stack(
                  children: [
                    Consumer<OpacityChang>(
                      builder: (BuildContext context, _value, Widget? child) {
                        return Opacity(
                            opacity: _value.isOpacityTaxi == true ? 1 : 0.3,
                            child: Consumer<TrueFalse>(
                              builder: (BuildContext context, valueColor,
                                  Widget? child) {
                                return CustomWidgets().carTypeBox(
                                  image: const Image(
                                      image: AssetImage(
                                        "assets/yellow.png",
                                      ),
                                      fit: BoxFit.contain),
                                  text: Tools().amountOrCarTypeTaxi(context),
                                  mainColor: valueColor.colorTaxiInRow
                                      ? Colors.greenAccent.shade700
                                      : Colors.black38,
                                  text1: Tools()
                                      .amountOrCarTypeTaxiDiscount(context),
                                  subColor: valueColor.colorTaxiInRow
                                      ? Colors.redAccent.shade700
                                      : Colors.black38,
                                  context: context,
                                );
                              },
                            ));
                      },
                    ),
                    Positioned(
                        right: -10.0,
                        top: -10.0,
                        child: Consumer<OpacityChang>(
                          builder:
                              (BuildContext context, _value, Widget? child) {
                            return IconButton(
                                onPressed: () {
                                  Provider.of<SheetCarDesc>(context,
                                          listen: false)
                                      .updateStateTaxi(0);
                                },
                                icon: _value.isOpacityTaxi == true
                                    ? const Icon(
                                        Icons.info_outline,
                                        color: Color(0xFFFBC408),
                                        size: 20,
                                      )
                                    : const Text(""));
                          },
                        )),
                    Consumer<TrueFalse>(
                      builder: (BuildContext context, value, Widget? child) {
                        return value.showLineDiscountTaxi
                            ? Positioned(
                                right: 20.0,
                                left: 20.0,
                                bottom: MediaQuery.of(context).size.height *
                                    2.3 /
                                    100,
                                child: AnimatedContainer(
                                  height: 2.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey,
                                  ),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                    Positioned(
                      right: 0.0,
                      left: 0.0,
                      bottom: MediaQuery.of(context).size.height * 0.15 / 100,
                      child: Consumer<LineTaxi>(
                        builder: (BuildContext context, _val, Widget? child) {
                          return AnimatedContainer(
                            height: _val.islineTaxi == true ? 4 : 0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: _val.islineTaxi == true
                                  ? const Color(0xFF00A3E0)
                                  : Colors.transparent,
                            ),
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  Tools().changeAllProClickVetoBox(context);
                },
                child: Stack(
                  children: [
                    Consumer<OpacityChang>(
                      builder: (BuildContext context, _value, Widget? child) {
                        return Opacity(
                            opacity: _value.isOpacityVan ? 1 : 0.3,
                            child: Consumer<TrueFalse>(
                              builder: (BuildContext context, valueColor,
                                  Widget? child) {
                                return CustomWidgets().carTypeBox(
                                    image: const Image(
                                        image: AssetImage("assets/mers.png"),
                                        fit: BoxFit.contain),
                                    text: Tools().amountOrCarTypeVeto(context),
                                    mainColor: valueColor.colorVetoInRow
                                        ? Colors.greenAccent.shade700
                                        : Colors.black38,
                                    text1: Tools()
                                        .amountOrCarTypeVetoDiscount(context),
                                    subColor: valueColor.colorVetoInRow
                                        ? Colors.red.shade700
                                        : Colors.black38,
                                    context: context);
                              },
                            ));
                      },
                    ),
                    Positioned(
                        right: -10.0,
                        top: -10.0,
                        child: Consumer<OpacityChang>(
                          builder:
                              (BuildContext context, _value, Widget? child) {
                            return IconButton(
                                onPressed: () {
                                  Provider.of<SheetCarDesc>(context,
                                          listen: false)
                                      .updateStateMed(0);
                                },
                                icon: _value.isOpacityVan == true
                                    ? const Icon(
                                        Icons.info_outline,
                                        color: Color(0xFFFBC408),
                                        size: 20,
                                      )
                                    : const Text(""));
                          },
                        )),
                    Consumer<TrueFalse>(
                      builder: (BuildContext context, value, Widget? child) {
                        return value.showLineDiscountVeto
                            ? Positioned(
                                right: 20.0,
                                left: 20.0,
                                bottom: MediaQuery.of(context).size.height *
                                    2.5 /
                                    100,
                                child: AnimatedContainer(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.grey,
                                  ),
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                    Positioned(
                      right: 0.0,
                      left: 0.0,
                      bottom: MediaQuery.of(context).size.height * 0.15 / 100,
                      child: Consumer<LineTaxi>(
                        builder: (BuildContext context, _value, Widget? child) {
                          return AnimatedContainer(
                            height: _value.islineVan == true ? 4 : 0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: _value.islineVan == true
                                  ? const Color(0xFF00A3E0)
                                  : Colors.transparent,
                            ),
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Tools().changeAllProClickVanBox(context);
              },
              child: Stack(
                children: [
                  Consumer<OpacityChang>(
                    builder: (BuildContext context, _value, Widget? child) {
                      return Opacity(
                          opacity: _value.isOpacityVeto ? 1.0 : 0.3,
                          child: Consumer<TrueFalse>(
                            builder: (BuildContext context, valueColor,
                                Widget? child) {
                              return CustomWidgets().carTypeBox(
                                image: const Image(
                                    image: AssetImage("assets/van.png"),
                                    fit: BoxFit.contain),
                                text: Tools().amountOrCarTypeVan(context),
                                mainColor: valueColor.colorVanInRow
                                    ? Colors.greenAccent.shade700
                                    : Colors.black38,
                                text1:
                                    Tools().amountOrCarTypeVanDiscount(context),
                                subColor: valueColor.colorVanInRow
                                    ? Colors.redAccent.shade700
                                    : Colors.black38,
                                context: context,
                              );
                            },
                          ));
                    },
                  ),
                  Positioned(
                      right: -10.0,
                      top: -10.0,
                      child: Consumer<OpacityChang>(
                        builder: (BuildContext context, _value, Widget? child) {
                          return IconButton(
                              onPressed: () => Provider.of<SheetCarDesc>(
                                      context,
                                      listen: false)
                                  .updateStateBig(0),
                              icon: _value.isOpacityVeto == true
                                  ? const Icon(
                                      Icons.info_outline,
                                      color: Color(0xFFFBC408),
                                      size: 20,
                                    )
                                  : const Text(""));
                        },
                      )),
                  Consumer<TrueFalse>(
                    builder: (BuildContext context, value, Widget? child) {
                      return value.showLineDiscountVan
                          ? Positioned(
                              right: 20.0,
                              left: 20.0,
                              bottom: MediaQuery.of(context).size.height *
                                  2.3 /
                                  100,
                              child: AnimatedContainer(
                                height: 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey,
                                ),
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                  Positioned(
                    right: 0.0,
                    left: 0.0,
                    bottom: MediaQuery.of(context).size.height * 0.15 / 100,
                    child: Consumer<LineTaxi>(
                      builder: (BuildContext context, _value, Widget? child) {
                        return AnimatedContainer(
                          height: _value.islineVeto == true ? 4 : 0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: _value.islineVeto == true
                                ? const Color(0xFF00A3E0)
                                : Colors.transparent,
                          ),
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
          ]),
    );
  }

  // this taxi description sheet
  Widget sheetTaxi(BuildContext context, SheetCarDesc _value) {
    return AnimatedPositioned(
      child: CustomBottomSheet().showSheetCarInfoTaxi(
          context: context,
          image: const Image(
            image: AssetImage("assets/yellow.png"),
            fit: BoxFit.contain,
          ),
          title: AppLocalizations.of(context)!.regularTaxi,
          des: AppLocalizations.of(context)!.sedanCar,
          iconM: Icons.money,
          price: "",
          iconP: Icons.person,
          person: "4"),
      duration: const Duration(microseconds: 200),
      left: 0.0,
      right: 0.0,
      bottom: _value.sheetValTaxi,
    );
  }

  // this veto description sheet
  Widget sheetVeto(BuildContext context, SheetCarDesc _value) {
    return AnimatedPositioned(
      child: CustomBottomSheet().showSheetCarInfoMedeum(
          context: context,
          image: const Image(image: AssetImage("assets/mers.png")),
          title: AppLocalizations.of(context)!.medium,
          des: AppLocalizations.of(context)!.mediumCar,
          iconM: Icons.money,
          price: "....",
          iconP: Icons.person,
          person: "6-10"),
      duration: const Duration(microseconds: 200),
      left: 0.0,
      right: 0.0,
      bottom: _value.sheetValMed,
    );
  }

  // this van description sheet
  Widget sheetVan(BuildContext context, SheetCarDesc _value) {
    return AnimatedPositioned(
      child: CustomBottomSheet().showSheetCarInfoBig(
          context: context,
          image: const Image(image: AssetImage("assets/van.png")),
          title: AppLocalizations.of(context)!.bigCommercial,
          des: AppLocalizations.of(context)!.bigCar,
          iconM: Icons.money,
          price: "....",
          iconP: Icons.person,
          person: "11-19"),
      duration: const Duration(microseconds: 200),
      left: 0.0,
      right: 0.0,
      bottom: _value.sheetValBig,
    );
  }

// this widget cancelBord when user start his request
  Widget cancelBord(BuildContext context, PositionCancelReq _value,
      UserIdProvider userProvider) {
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        right: 0.0,
        left: 0.0,
        curve: Curves.ease,
        bottom: _value.value,
        child: CancelTaxi()
            .cancelTaxiRequest(context: context, userIdProvider: userProvider));
  }

// this widget for driverInfoBord to display driver info after he accepted
  Widget driverInfoBord(BuildContext context, PositionDriverInfoProvider _value,
      UserIdProvider userProvider) {
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        right: 0.0,
        left: 0.0,
        bottom: _value.positionDriverInfo,
        curve: Curves.ease,
        child: DriverInfo().driverInfoContainer(
            context: context, userIdProvider: userProvider));
  }

  Widget btnDrawer() {
    return Positioned(
      left: AppLocalizations.of(context)!.whereTo == "إلى أين ؟" ? 0.0 : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ChangeColor>(
          builder: (BuildContext context, value, Widget? child) {
            return CircleAvatar(
                radius: 30,
                backgroundColor: value.isTrue == false
                    ? const Color(0xFF00A3E0)
                    : Colors.white,
                child: IconButton(
                    onPressed: () async {
                      if (value.isTrue == false) {
                        Provider.of<DoubleValue>(context, listen: false)
                            .value0Or1(1);
                        Provider.of<ChangeColor>(context, listen: false)
                            .updateState(true);
                      } else {
                        Provider.of<DoubleValue>(context, listen: false)
                            .value0Or1(0);
                        Provider.of<ChangeColor>(context, listen: false)
                            .updateState(false);
                      }
                    },
                    icon: value.isTrue == false
                        ? const Icon(
                            Icons.format_list_numbered_rtl_rounded,
                            color: Colors.white,
                            size: 25,
                          )
                        : const Icon(
                            Icons.close,
                            color: Color(0xFFFBC408),
                            size: 25,
                          )));
          },
        ),
      ),
    );
  }

  Widget btnComplainOnDriver() {
    return statusRide == "accepted" || statusRide == "Driver arrived"
        ? Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 10.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            CustomWidgets().complainOnDriver(context));
                  },
                  icon: Icon(
                    Icons.call,
                    color: Colors.greenAccent.shade700,
                    size: 25,
                  )),
            ),
          )
        : const SizedBox();
  }

  ///===================start main methods==============================

  // this method for rider trick has trip if killed app and reOpen
  Future<void> trickMyTripAfterKilled() async {
    final _id =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users.userId;

    DatabaseReference refRideRequest =
        FirebaseDatabase.instance.ref().child("Ride Request").child(_id);
    refRideRequest.once().then((value) async {
      final snap = value.snapshot.value;
      try {
        if (snap != null) {
          Map<String, dynamic> map = Map<String, dynamic>.from(snap as Map);
          if (map['driverId'] != null) {
            final _checkIdDriver = map['driverId'].toString();
            if (_checkIdDriver != 'waiting') {
              var _checkCarType = '';
              var _dropOffLat = 0.0;
              var _dropOfflon = 0.0;
              if (map['vehicleType_id'] != null) {
                _checkCarType = map['vehicleType_id'].toString();
              }
              if (map['dropoff']['latitude'] != null) {
                _dropOffLat =
                    double.parse(map['dropoff']['latitude'].toString());
              }
              if (map['dropoff']['longitude'] != null) {
                _dropOfflon =
                    double.parse(map['dropoff']['longitude'].toString());
              }
              Address dropOfLocation = Address();
              dropOfLocation.placeFormattedAddress = "";
              dropOfLocation.placeName = "";
              dropOfLocation.placeId = "";
              dropOfLocation.latitude = _dropOffLat;
              dropOfLocation.longitude = _dropOfflon;
              Provider.of<CarTypeProvider>(context, listen: false)
                  .updateCarType(_checkCarType);
              Provider.of<PlaceDetailsDropProvider>(context, listen: false)
                  .updateDropOfLocation(dropOfLocation);
              if (dropOfLocation.longitude != 0.0) {
                await NotifyDriver().gotDriverInfo(context).whenComplete(() {
                  Provider.of<PositionChang>(context, listen: false)
                      .changValue(-500.0);
                  Provider.of<PositionDriverInfoProvider>(context,
                          listen: false)
                      .updateState(0.0);
                });
              }
            } else {
              return;
            }
          }
        } else {
          refRideRequest.onDisconnect();
          return;
        }
      } catch (ex) {
        if (kDebugMode) {
          print('error trickMyTripAfterKilled:::${ex.toString()}');
        }
      }
    });
  }

  //this Method for custom icon driver near taxi
  void createDriverNearIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(1.0, 1.0));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            Platform.isAndroid
                ? "assets/yellowcar1.png"
                : "assets/yellowcar.png")
        .then((value) {
      Provider.of<GoogleMapSet>(context, listen: false)
          .updateBitmapIconShapeTaxi(value);
    });
  }

  //this Method for custom icon driver near van
  void createDriverNearIcon1() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(1.0, 1.0));
    BitmapDescriptor.fromAssetImage(imageConfiguration,
            Platform.isAndroid ? "assets/blackcar1.png" : "assets/blackcar.png")
        .then((value) {
      Provider.of<GoogleMapSet>(context, listen: false)
          .updateBitmapIconShapeVeto(value);
    });
  }

  // this method for open tourism cites
  Future<void> startOpenTripCity() async {
    await Geofire.stopListener();
    var googleMapState = Provider.of<GoogleMapSet>(context, listen: false);
    noChangeToTaxi = true;
    GeoFireMethods.listOfNearestDriverAvailable.clear();
    googleMapState.markersSet.clear();
    geoFireRadios = 30;
    await LogicGoogleMap().geoFireInitialize(context);
    checkAnyListTurCityOpen();
  }

  // this method for switch text where to OR toll passes
  changeTextWhereToOrTollpasses(DirectionDetails? tripDirectionDetails) {
    if (tripDirectionDetails != null) {
      return Text(
        AppLocalizations.of(context)!.km +
            "  " +
            tripDirectionDetails.distanceText +
            "  " +
            AppLocalizations.of(context)!.time +
            "  " +
            tripDirectionDetails.durationText,
        style: TextStyle(color: Colors.blueAccent.shade700),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return Expanded(
        child: Text(
          AppLocalizations.of(context)!.whereTo,
          style: const TextStyle(
              color: Colors.black38, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  // this method for switch if cancel bottom or search icon
  searchIconOrCancelBottom(DirectionDetails? tripDirectionDetails) {
    if (tripDirectionDetails != null) {
      return IconButton(
          onPressed: () async {
            Tools().restApp(context);
          },
          icon: const Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.cancel,
              color: Colors.redAccent,
              size: 30,
            ),
          ));
    } else {
      return const Icon(
        Icons.search,
        color: Colors.black54,
        size: 35,
      );
    }
  }

  // this method for check any city in turkey and open list of city tur
  Future<void> checkAnyListTurCityOpen() async {
    var googleMapState = Provider.of<GoogleMapSet>(context, listen: false);
    var list = [];
    var _map = <String, dynamic>{};
    var infoUserDataReal =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    switch (infoUserDataReal.country) {
      case 'İstanbul':
        _map = {
          "istan": ["istanbul", "100", AppLocalizations.of(context)!.istanbul],
          "bursa": ["bursa", "220", AppLocalizations.of(context)!.bursa],
          "izmit": ["izmit", "150", AppLocalizations.of(context)!.izmit],
          "sapanca": ["sapanca", "180", AppLocalizations.of(context)!.sabanjah],
          "Bolu": ["Bolu abant", "300", AppLocalizations.of(context)!.polo],
          "şile": ["şile", "170", AppLocalizations.of(context)!.sala],
          "yalova": ["yalova", "170", AppLocalizations.of(context)!.yalua],
        };
        break;
      case 'Antalya':
        _map = {
          "Antaly": ["Antalya", "100", AppLocalizations.of(context)!.antalMain],
          "Mana": ["Manavgat", "130", AppLocalizations.of(context)!.antalManar],
          "Marar": ["Marmaris", "250", AppLocalizations.of(context)!.antalMarr],
          "Bodrum": ["Bodrum", "400", AppLocalizations.of(context)!.antalBoder],
          "Izmir": ["Izmir", "500", AppLocalizations.of(context)!.antalIzmir],
          "Alanya": ["Alanya", "160", AppLocalizations.of(context)!.antalAlan],
        };
        break;
      case 'Muğla':
        _map = {
          "Bodrum": ["Bodrum", "100", AppLocalizations.of(context)!.bodMain],
          "Izmir": ["Izmir", "300", AppLocalizations.of(context)!.bodIzmir],
          "Mar": ["Marmaris", "250", AppLocalizations.of(context)!.bodMarmar],
          "sapca": ["Bodrum", "180", AppLocalizations.of(context)!.sabanjah],
        };
        break;
      case 'Bursa':
        _map = {
          "Bursa": ["Bursa", "100", AppLocalizations.of(context)!.bursaMain],
          "Yalova": ["Yalova", "140", AppLocalizations.of(context)!.bursaYal],
          "ist": ["istanbul", "250", AppLocalizations.of(context)!.bursaIst],
          "sap": ["sapanca", "180", AppLocalizations.of(context)!.bursaSpan],
          "Bolu": ["Bolu abant", "500", AppLocalizations.of(context)!.bursaPol],
          "izm": ["izmite", "190", AppLocalizations.of(context)!.bursaIzn],
        };
        break;
      case 'Sakarya':
        _map = {
          "spanca": ["spanca", "90", AppLocalizations.of(context)!.spanMain],
          "bursa": ["bursa", "200", AppLocalizations.of(context)!.spanBursa],
          "izmit": ["istanbul", "100", AppLocalizations.of(context)!.spanIzn],
          "ista": ["istanbul", "180", AppLocalizations.of(context)!.spanIst],
          "Bolu": ["Bolu abant", "200", AppLocalizations.of(context)!.spanPol],
          "yalova": ["yalova", "150", AppLocalizations.of(context)!.spanYal],
        };
        break;
      case 'Trabzon':
        _map = {
          "Tra": ["Trabzon", "100", AppLocalizations.of(context)!.trapzonMain],
          "Uzun": ["Uzun gol", "130", AppLocalizations.of(context)!.trapzonUzu],
          "Ayder": ["Ayder", "170", AppLocalizations.of(context)!.trapzonAyd],
          "Rize": ["Rize", "160", AppLocalizations.of(context)!.trapzonRiz],
          "Gir": ["Giresun", "160", AppLocalizations.of(context)!.trapzonGir],
          "ondu": ["ondu", "200", AppLocalizations.of(context)!.trapzonOndu],
        };
        break;
      case 'Çaykara':
        _map = {
          "Uzu": ["Uzungöl", "80", AppLocalizations.of(context)!.uzunMain],
          "Trn": ["Trabzon", "190", AppLocalizations.of(context)!.uzuTrapzon],
          "Ayder": ["Ayder", "170", AppLocalizations.of(context)!.uzuAyd],
          "Rize": ["Rize", "140", AppLocalizations.of(context)!.uzuRiz],
          "onda": ["onda", "220", AppLocalizations.of(context)!.uzuOndu],
        };
        break;
      default:
        await Geofire.stopListener();
        Tools().toastMsg(AppLocalizations.of(context)!.noTrip, Colors.red);
        GeoFireMethods.listOfNearestDriverAvailable.clear();
        googleMapState.markersSet.clear();
        geoFireRadios = 2;
        await LogicGoogleMap().geoFireInitialize(context);
        Tools().changeAllProClickTaxiBox(context);
        break;
    }
    if (_map.isNotEmpty) {
      _map.forEach((key, value) {
        list.add(value);
      });
      final _res = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomWidgets().listOfTurCity(context, list);
          });
      if (_res == 'data') {
        await LogicGoogleMap().getPlaceDirection(context);
      } else {
        await Geofire.stopListener();
        Tools().toastMsg(AppLocalizations.of(context)!.noTrip, Colors.red);
        GeoFireMethods.listOfNearestDriverAvailable.clear();
        googleMapState.markersSet.clear();
        geoFireRadios = 2;
       await LogicGoogleMap().geoFireInitialize(context);
        Tools().changeAllProClickTaxiBox(context);
      }
    }
  }

// this method for check any amount will set to  Ride Request collection
  int checkAnyAmount(String carTypePro, DirectionDetails details) {
    var tripDirection =
        Provider.of<GoogleMapSet>(context, listen: false).tripDirectionDetail;
    var amount = 0;
    if (tripDirection == null) {
      amount = 0;
    }
    amount = ApiSrvDir.calculateFares1(details, carTypePro, context);
    return amount;
  }

// // dropBottom payment way cash or card
  Widget dropBottomCustom(BuildContext context, String dropBottomProvider) {
    String? value1 = AppLocalizations.of(context)!.cash;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        margin: const EdgeInsets.only(left: 6.0, right: 6.0),
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height * 6 / 100,
        width: MediaQuery.of(context).size.width * 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: const Color(0xFFFBC408), width: 1)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              value: newValueDrop == "" ? value1 : newValueDrop,
              isExpanded: true,
              dropdownColor: Colors.white,
              iconSize: 40.0,
              items: <String>[
                AppLocalizations.of(context)!.cash,
                AppLocalizations.of(context)!.creditCard,
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      value == AppLocalizations.of(context)!.cash
                          ? const Icon(
                              Icons.money,
                              color: Colors.green,
                            )
                          : Image.asset(
                              "assets/iconDrop.png",
                              fit: BoxFit.contain,
                              width: 30.0,
                              height: 30.0,
                            ),
                      const SizedBox(width: 4.0),
                      Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val == "Cash" || val == "نقدا" || val == "Nakit") {
                  newValueDrop = AppLocalizations.of(context)!.cash;
                  Provider.of<DropBottomValue>(context, listen: false)
                      .updateValue("Cash");
                } else if (val == "Pay in taxi by Credit Card" ||
                    val == "الدفع في سيارة الأجرة بواسطة بطاقة الائتمان" ||
                    val == "Kredi Kartı ile takside ödeme") {
                  newValueDrop = AppLocalizations.of(context)!.creditCard;
                  Provider.of<DropBottomValue>(context, listen: false)
                      .updateValue("Pay in taxi by Credit Card");
                }
              }),
        ),
      ),
    );
  }
  ///================================End==================================
}
