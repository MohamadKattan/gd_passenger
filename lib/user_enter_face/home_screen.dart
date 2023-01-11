import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/google_map_methods.dart';
import 'package:gd_passenger/model/directions_details.dart';
import 'package:gd_passenger/model/nearest%20_driver_%20available.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
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
import 'package:flutter_geofire/flutter_geofire.dart';
import '../model/address.dart';
import '../my_provider/buttom_color_pro.dart';
import '../my_provider/close_botton_driverInfo.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/rider_id.dart';
import '../my_provider/sheet_cardsc.dart';
import '../my_provider/timeTrip_statusRide.dart';
import '../repo/api_srv_geo.dart';
import '../tools/curanny_type.dart';
import '../tools/geoFire_methods_tools.dart';
import '../tools/math_methods.dart';
import '../widget/custom_widgets.dart';
import '../widget/driver_info.dart';
import '../widget/rating_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "dart:collection";

import 'advance_reservation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  late AudioCache audioCache;
  StreamSubscription<DatabaseEvent>? _rideStreamSubscription;
  List<NearestDriverAvailable> _driverAvailable = [];
  List<String> _keyDriverAvailable = [];
  String state = "normal";
  String waitDriver = "wait";
  bool sound1 = false;
  bool sound2 = false;
  bool sound3 = false;
  bool openCollectMoney = false;
  bool updateDriverOnMap = true;
  bool isTimeRequstTrip = false;
  bool noChangeToTaxi = false;
  // final aNmarkers = <MarkerId, Marker>{};
  // final kMarkerId = const MarkerId('myDriver');
  late BitmapDescriptor driversNearIcon;
  late BitmapDescriptor driversNearIcon1;
  double geoFireRader = 4;
  @override
  void initState() {
    ApiSrvGeo().getCountry();
    audioCache = AudioCache(fixedPlayer: audioPlayer, prefix: "assets/");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearAll();
    super.dispose();
  }

  void _asyncMethod() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomWidgets().circularInductorCostem(context));
    await LogicGoogleMap().locationPosition(context).whenComplete(() async {
      await Future.delayed(const Duration(seconds: 2));
      await geoFireInitialize();
      Navigator.pop(context);
    });
    await trickMyTripAfterKilled();
    await DataBaseSrv().currentOnlineUserInfo(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    final carTypePro = Provider.of<CarTypeProvider>(context).carType;
    createDriverNearIcon();
    createDriverNearIcon1();
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
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              60 /
                                              100,
                                      width: MediaQuery.of(context).size.width,
                                      child: GoogleMap(
                                        padding:
                                            const EdgeInsets.only(bottom: 95.0),
                                        mapType: MapType.normal,
                                        initialCameraPosition:
                                            LogicGoogleMap().kGooglePlex,
                                        myLocationButtonEnabled: true,
                                        myLocationEnabled: true,
                                        polylines: polylineSet,
                                        markers: markersSet,
                                        circles: circlesSet,
                                        onMapCreated: (GoogleMapController
                                            controller) async {
                                          LogicGoogleMap()
                                              .controllerGoogleMap
                                              .complete(controller);
                                          newGoogleMapController = controller;
                                        },
                                      ),
                                    ),

                                    /// main container what include car types car drop button request button
                                    Consumer<PositionChang>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return AnimatedPositioned(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            right: 0.0,
                                            left: 0.0,
                                            bottom: _value.val,
                                            curve: Curves.ease,
                                            child: Container(
                                              // // padding:
                                              //     const EdgeInsets.all(8.0),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 6.0,
                                                        spreadRadius: 0.5,
                                                        color: Colors.black54,
                                                        offset:
                                                            Offset(0.7, 0.7))
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
                                                      builder:
                                                          (BuildContext context,
                                                              _value,
                                                              Widget? child) {
                                                        return dropBottomCustom(
                                                            context,
                                                            _value
                                                                .valueDropBottom);
                                                      },
                                                    ),

                                                    /// request button
                                                    GestureDetector(
                                                        onTap: () async {
                                                          if (tripDirectionDetails !=
                                                              null) {
                                                            gotKeyOfDriver(
                                                                userProvider);
                                                            // countFullTimeRequest(userProvider);
                                                            Provider.of<PositionCancelReq>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .updateValue(
                                                                    0.0);
                                                            Provider.of<PositionChang>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changValue(
                                                                    -500.0);
                                                            final int amount =
                                                                checkAnyAmount(
                                                                    carTypePro!,
                                                                    tripDirectionDetails!);
                                                            DataBaseSrv()
                                                                .saveRiderRequest(
                                                                    context,
                                                                    amount);
                                                            state =
                                                                "requesting";
                                                          } else {
                                                            Tools().toastMsg(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .chooseBefore);
                                                          }
                                                        },
                                                        child:
                                                            AnimatedContainer(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 12.0,
                                                                  bottom: 30),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              6.5 /
                                                              100,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              70 /
                                                              100,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: tripDirectionDetails !=
                                                                    null
                                                                ? const Color(
                                                                    0xFFFBC408)
                                                                : const Color(
                                                                    0xFF00A3E0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .requestTaxi,
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      },
                                    ),

                                    /// sheet Car desc
                                    Consumer<SheetCarDesc>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return AnimatedPositioned(
                                          child: CustomBottomSheet()
                                              .showSheetCarInfoTaxi(
                                                  context: context,
                                                  image: const Image(
                                                    image: AssetImage(
                                                        "assets/yellow.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .regularTaxi,
                                                  des: AppLocalizations.of(
                                                          context)!
                                                      .sedanCar,
                                                  iconM: Icons.money,
                                                  price: "",
                                                  iconP: Icons.person,
                                                  person: "4"),
                                          duration:
                                              const Duration(microseconds: 200),
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: _value.sheetValTaxi,
                                        );
                                      },
                                    ),
                                    Consumer<SheetCarDesc>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return AnimatedPositioned(
                                          child: CustomBottomSheet()
                                              .showSheetCarInfoMedeum(
                                                  context: context,
                                                  image: const Image(
                                                      image: AssetImage(
                                                          "assets/mers.png")),
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .medium,
                                                  des: AppLocalizations.of(
                                                          context)!
                                                      .mediumCar,
                                                  iconM: Icons.money,
                                                  price: "....",
                                                  iconP: Icons.person,
                                                  person: "6-10"),
                                          duration:
                                              const Duration(microseconds: 200),
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: _value.sheetValMed,
                                        );
                                      },
                                    ),
                                    Consumer<SheetCarDesc>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return AnimatedPositioned(
                                          child: CustomBottomSheet()
                                              .showSheetCarInfoBig(
                                                  context: context,
                                                  image: const Image(
                                                      image: AssetImage(
                                                          "assets/van.png")),
                                                  title: AppLocalizations
                                                          .of(context)!
                                                      .bigCommercial,
                                                  des: AppLocalizations.of(
                                                          context)!
                                                      .bigCar,
                                                  iconM: Icons.money,
                                                  price: "....",
                                                  iconP: Icons.person,
                                                  person: "11-19"),
                                          duration:
                                              const Duration(microseconds: 200),
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: _value.sheetValBig,
                                        );
                                      },
                                    ),

                                    ///cancel container
                                    Consumer<PositionCancelReq>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return AnimatedPositioned(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            right: 0.0,
                                            left: 0.0,
                                            curve: Curves.ease,
                                            bottom: _value.value,
                                            child: CancelTaxi()
                                                .cancelTaxiRequest(
                                                    context: context,
                                                    userIdProvider:
                                                        userProvider,
                                                    voidCallback: () async {
                                                      restApp();
                                                    }));
                                      },
                                    ),

                                    ///driver info
                                    Consumer<PositionDriverInfoProvider>(
                                      builder: (BuildContext context, _value,
                                          Widget? child) {
                                        return AnimatedPositioned(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            right: 0.0,
                                            left: 0.0,
                                            bottom: _value.positionDriverInfo,
                                            curve: Curves.ease,
                                            child: DriverInfo()
                                                .driverInfoContainer(
                                                    context: context,
                                                    userIdProvider:
                                                        userProvider,
                                                    voidCallback: () async {
                                                      // var marker = RippleMarker(
                                                      //   markerId: kMarkerId,
                                                      //   position: const LatLng(
                                                      //       0.0, 0.0),
                                                      //   icon: BitmapDescriptor
                                                      //       .defaultMarkerWithHue(
                                                      //           BitmapDescriptor
                                                      //               .hueBlue),
                                                      //   ripple: false,
                                                      // );
                                                      // aNmarkers[kMarkerId] =
                                                      //     marker;
                                                      _keyDriverAvailable
                                                          .clear();
                                                      restApp();
                                                    }));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  Positioned(
                    left: AppLocalizations.of(context)!.whereTo == "إلى أين ؟"
                        ? 0.0
                        : null,
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
                                  onPressed: () {
                                    if (value.isTrue == false) {
                                      Provider.of<DoubleValue>(context,
                                              listen: false)
                                          .value0Or1(1);
                                      Provider.of<ChangeColor>(context,
                                              listen: false)
                                          .updateState(true);
                                    } else {
                                      Provider.of<DoubleValue>(context,
                                              listen: false)
                                          .value0Or1(0);
                                      Provider.of<ChangeColor>(context,
                                              listen: false)
                                          .updateState(false);
                                    }
                                  },
                                  icon: value.isTrue == false
                                      ? const Icon(
                                          Icons
                                              .format_list_numbered_rtl_rounded,
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
                  ),

                  /// complain button
                  statusRide == "accepted" || statusRide == "Driver arrived"
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
                                      builder: (_) => CustomWidgets()
                                          .complainOnDriver(context));
                                },
                                icon: Icon(
                                  Icons.call,
                                  color: Colors.greenAccent.shade700,
                                  size: 25,
                                )),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          )),
    );
  }

// this widget include buttons tourism Trip and AdvanceReservation
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

// this widget in cloud whereToGo search failed
  Widget whereToGo() {
    return Expanded(
      flex: 0,
      child: GestureDetector(
        onTap: () async {
          final res = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return const SearchScreen();
          }));
          if (res == "dataDir") {
            await getPlaceDirection(context);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 4.0),
          margin: const EdgeInsets.only(bottom: 4.0, left: 4.0, right: 4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(width: 1.0, color: const Color(0xFFFBC408))),
          width: MediaQuery.of(context).size.width * 100,
          height: MediaQuery.of(context).size.width * 15.0 / 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: searchIconOrCancelBottom(tripDirectionDetails),
              ),
              changeTextWhereToOrTollpasses(tripDirectionDetails),
            ],
          ),
        ),
      ),
    );
  }

// this widget in cloud car box type taxi/van/veto
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
                    markersSet.clear();
                    GeoFireMethods.listOfNearestDriverAvailable.clear();
                    geoFireRader = 4;
                    geoFireInitialize();
                  }
                },
                child: Stack(
                  children: [
                    Consumer<OpacityChang>(
                      builder: (BuildContext context, _value, Widget? child) {
                        return Opacity(
                            opacity: _value.isOpacityTaxi == true ? 1 : 0.3,
                            child: CustomWidgets().carTypeBox(
                                const Image(
                                    image: AssetImage(
                                      "assets/yellow.png",
                                    ),
                                    fit: BoxFit.contain),
                                amountOrCarTypeTaxi(),
                                "4",
                                context));
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
                  Tools().changeAllProClickVanBox(context);
                },
                child: Stack(
                  children: [
                    Consumer<OpacityChang>(
                      builder: (BuildContext context, _value, Widget? child) {
                        return Opacity(
                            opacity: _value.isOpacityVan == true ? 1 : 0.3,
                            child: CustomWidgets().carTypeBox(
                                const Image(
                                    image: AssetImage("assets/mers.png"),
                                    fit: BoxFit.contain),
                                amountOrCarTypeVeto(),
                                "6-10",
                                context));
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
                Tools().changeAllProClickVetoBox(context);
              },
              child: Stack(
                children: [
                  Consumer<OpacityChang>(
                    builder: (BuildContext context, _value, Widget? child) {
                      return Opacity(
                          opacity: _value.isOpacityVeto == true ? 1.0 : 0.3,
                          child: CustomWidgets().carTypeBox(
                              const Image(
                                  image: AssetImage("assets/van.png"),
                                  fit: BoxFit.contain),
                              amountOrCarTypeVan(),
                              "11-19",
                              context));
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

  ///======Start got current loction + geoFire for add all drivers on map who are close to rider=========

  // this method for display nearest driver available from rider in list by using geoFire
  Future<void> geoFireInitialize() async {
    await Geofire.initialize("availableDrivers");
    final currentPosition =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    try {
      Geofire.queryAtLocation(currentPosition.latitude ?? 0.0,
              currentPosition.longitude ?? 0.0, geoFireRader)
          ?.listen((map) async {
        if (map != null) {
          var callBack = map['callBack'];
          switch (callBack) {
            case Geofire.onKeyEntered:
              NearestDriverAvailable nearestDriverAvailable =
                  NearestDriverAvailable("", 0.0, 0.0);
              nearestDriverAvailable.key = map['key'];
              nearestDriverAvailable.latitude = map['latitude'];
              nearestDriverAvailable.longitude = map['longitude'];
              GeoFireMethods.listOfNearestDriverAvailable
                  .add(nearestDriverAvailable);
              if (kDebugMode) {
                print(
                    "hhh${GeoFireMethods.listOfNearestDriverAvailable.length}");
              }
              break;
            case Geofire.onKeyExited:
              GeoFireMethods.removeDriverFromList(map["key"]);
              break;

            case Geofire.onKeyMoved:
              NearestDriverAvailable nearestDriverAvailable =
                  NearestDriverAvailable("", 0.0, 0.0);
              nearestDriverAvailable.key = map['key'];
              nearestDriverAvailable.latitude = map['latitude'];
              nearestDriverAvailable.longitude = map['longitude'];
              GeoFireMethods.updateDriverNearLocation(nearestDriverAvailable);
              updateAvailableDriverOnMap();
              break;
            case Geofire.onGeoQueryReady:
              updateAvailableDriverOnMap();
              break;
          }
        }
        setState(() {});
      }).onError((er) {
        if (kDebugMode) {
          print(er.toString());
        }
      });
    } on PlatformException {
      if (kDebugMode) {
        print('PlatformException geo fire');
      }
    }
    if (!mounted) return;
  }

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
                await gotDriverInfo().whenComplete(() {
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

  void updateAvailableDriverOnMap() async {
    if (updateDriverOnMap == true) {
      if (kDebugMode) {
        print('update drivers on Map');
      }
      late String driverPhoneOneOnMap;
      late String phone;
      for (NearestDriverAvailable driver
          in GeoFireMethods.listOfNearestDriverAvailable) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child("driver").child(driver.key);
        await ref.once().then((value) {
          final snap = value.snapshot.value;
          if (snap == null) {
            return;
          }
          Map<String, dynamic> map = Map<String, dynamic>.from(snap as Map);
          if (map["firstName"] != null) {
            fNameIcon = map["firstName"].toString();
          }
          if (map["lastName"] != null) {
            lNameIcon = map["lastName"].toString();
          }
          if (map["rating"] != null) {
            ratDriverRead = double.parse(map["rating"].toString());
          }
          if (map["carInfo"]["carType"] != null) {
            carTypeOnUpdateGeo = map["carInfo"]["carType"].toString();
          }
          if (map["phoneNumber"] != null) {
            driverPhoneOneOnMap = map["phoneNumber"].toString();
          }
        });
        LatLng driverAvailablePosititon =
            LatLng(driver.latitude, driver.longitude);

        Marker marker = Marker(
          markerId: MarkerId("driver${driver.key}"),
          position: driverAvailablePosititon,
          icon: carTypeOnUpdateGeo == "Taxi-4 seats"
              ? driversNearIcon
              : driversNearIcon1,
          infoWindow: InfoWindow(
              onTap: () async {
                await ref.child('phoneNumber').once().then((value) {
                  if (value.snapshot.value != null) {
                    phone = value.snapshot.value.toString();
                  }
                });
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        CustomWidgets().callDriverOnMap(context, phone));
              },
              title: " $fNameIcon $lNameIcon",
              snippet:
                  ' ${AppLocalizations.of(context)!.callDriver} : $driverPhoneOneOnMap'),
          rotation: MathMethods.createRandomNumber(90),
          anchor: const Offset(0.1, 0.5),
        );
        setState(() {
          markersSet.add(marker);
        });
      }
    } else {
      if (kDebugMode) {
        print('No update drivers on Map');
      }
      return;
    }
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
      driversNearIcon = value;
    });
  }

  //this Method for custom icon driver near van
  void createDriverNearIcon1() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(1.0, 1.0));
    BitmapDescriptor.fromAssetImage(imageConfiguration,
            Platform.isAndroid ? "assets/blackcar1.png" : "assets/blackcar.png")
        .then((value) {
      driversNearIcon1 = value;
    });
  }

  // this method for open tourism cites
  Future<void> startOpenTripCity() async {
    noChangeToTaxi = true;
    GeoFireMethods.listOfNearestDriverAvailable.clear();
    markersSet.clear();
    geoFireRader = 30;
    await geoFireInitialize();
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
            restApp();
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
    var infoUserDataReal =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    switch (infoUserDataReal.country) {
      case 'İstanbul':
        final _res = await showGeneralDialog(
            context: context,
            pageBuilder: (
              context,
              anim1,
              anim2,
            ) {
              return CustomWidgets().istanbulVeto(context);
            },
            barrierDismissible: true,
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                    opacity: anim1.value,
                    child: CustomWidgets().istanbulVeto(context)),
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
        if (_res == 'data') {
          getPlaceDirection(context);
        } else {
          Tools().toastMsg('No trip available now ');
          GeoFireMethods.listOfNearestDriverAvailable.clear();
          markersSet.clear();
          geoFireRader = 4;
          geoFireInitialize();
          Tools().changeAllProClickTaxiBox(context);
        }
        break;
      case 'Antalya':
        final _res = await showGeneralDialog(
            context: context,
            pageBuilder: (
              context,
              anim1,
              anim2,
            ) {
              return CustomWidgets().antalyVeto(context);
            },
            barrierDismissible: true,
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                    opacity: anim1.value,
                    child: CustomWidgets().antalyVeto(context)),
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
        if (_res == 'data') {
          getPlaceDirection(context);
        } else {
          Tools().toastMsg('No trip available now ');
          GeoFireMethods.listOfNearestDriverAvailable.clear();
          markersSet.clear();
          geoFireRader = 4;
          geoFireInitialize();
          Tools().changeAllProClickTaxiBox(context);
        }
        break;
      case 'Muğla':
        final _res = await showGeneralDialog(
            context: context,
            pageBuilder: (
              context,
              anim1,
              anim2,
            ) {
              return CustomWidgets().bodrunVeto(context);
            },
            barrierDismissible: true,
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                    opacity: anim1.value,
                    child: CustomWidgets().bodrunVeto(context)),
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
        if (_res == 'data') {
          getPlaceDirection(context);
        } else {
          Tools().toastMsg('No trip available now ');
          GeoFireMethods.listOfNearestDriverAvailable.clear();
          markersSet.clear();
          geoFireRader = 4;
          geoFireInitialize();
          Tools().changeAllProClickTaxiBox(context);
        }
        break;
      case 'Bursa':
        final _res = await showGeneralDialog(
            context: context,
            pageBuilder: (
              context,
              anim1,
              anim2,
            ) {
              return CustomWidgets().bursaVeto(context);
            },
            barrierDismissible: true,
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                    opacity: anim1.value,
                    child: CustomWidgets().bursaVeto(context)),
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
        if (_res == 'data') {
          getPlaceDirection(context);
        } else {
          Tools().toastMsg('No trip available now ');
          GeoFireMethods.listOfNearestDriverAvailable.clear();
          markersSet.clear();
          geoFireRader = 4;
          geoFireInitialize();
          Tools().changeAllProClickTaxiBox(context);
        }
        break;
      case 'Sakarya':
        final _res = await showGeneralDialog(
            context: context,
            pageBuilder: (
              context,
              anim1,
              anim2,
            ) {
              return CustomWidgets().sapancaVeto(context);
            },
            barrierDismissible: true,
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                    opacity: anim1.value,
                    child: CustomWidgets().sapancaVeto(context)),
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
        if (_res == 'data') {
          getPlaceDirection(context);
        } else {
          Tools().toastMsg('No trip available now ');
          GeoFireMethods.listOfNearestDriverAvailable.clear();
          markersSet.clear();
          geoFireRader = 4;
          geoFireInitialize();
          Tools().changeAllProClickTaxiBox(context);
        }
        break;
      case 'Trabzon':
        final _res = await showGeneralDialog(
            context: context,
            pageBuilder: (
              context,
              anim1,
              anim2,
            ) {
              return CustomWidgets().trabzonVeto(context);
            },
            barrierDismissible: true,
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                    opacity: anim1.value,
                    child: CustomWidgets().trabzonVeto(context)),
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
        if (_res == 'data') {
          getPlaceDirection(context);
        } else {
          Tools().toastMsg('No trip available now ');
          GeoFireMethods.listOfNearestDriverAvailable.clear();
          markersSet.clear();
          geoFireRader = 4;
          geoFireInitialize();
          Tools().changeAllProClickTaxiBox(context);
        }
        break;
      case 'Çaykara':
        final _res = await showGeneralDialog(
            context: context,
            pageBuilder: (
              context,
              anim1,
              anim2,
            ) {
              return CustomWidgets().uzungolVeto(context);
            },
            barrierDismissible: true,
            barrierLabel: '',
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                    opacity: anim1.value,
                    child: CustomWidgets().uzungolVeto(context)),
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
        if (_res == 'data') {
          getPlaceDirection(context);
        } else {
          Tools().toastMsg('No trip available now ');
          GeoFireMethods.listOfNearestDriverAvailable.clear();
          markersSet.clear();
          geoFireRader = 4;
          geoFireInitialize();
          Tools().changeAllProClickTaxiBox(context);
        }
        break;
      default:
        GeoFireMethods.listOfNearestDriverAvailable.clear();
        markersSet.clear();
        geoFireRader = 4;
        geoFireInitialize();
        Tools().changeAllProClickTaxiBox(context);
        break;
    }
  }

  // this method if dir Details != null amount : carType
  String amountOrCarTypeTaxi() {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;

    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Taxi-4 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.taxi;
          break;
      }
    }

    return result ?? AppLocalizations.of(context)!.taxi;
  }

  String amountOrCarTypeVeto() {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;
    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Medium commercial-6-10 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.mediumCommercial;
          break;
      }
    }
    return result ?? AppLocalizations.of(context)!.mediumCommercial;
  }

  String amountOrCarTypeVan() {
    var carTypePro = Provider.of<CarTypeProvider>(context).carType;
    String? result;
    if (tripDirectionDetails != null) {
      switch (carTypePro) {
        case "Big commercial-11-19 seats":
          result =
              "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}";
          break;
        default:
          result = AppLocalizations.of(context)!.bigCommercial;
          break;
      }
    }
    return result ?? AppLocalizations.of(context)!.bigCommercial;
  }

// this method for check any amount will set to   Ride Request collection
  int checkAnyAmount(String carTypePro, DirectionDetails details) {
    var amount = 0;
    if (tripDirectionDetails == null) {
      return 0;
    }
    amount = carTypePro == "Taxi-4 seats"
        ? ApiSrvDir.calculateFares1(details, carTypePro, context)
        : carTypePro == "Medium commercial-6-10 seats"
            ? ApiSrvDir.calculateFares1(details, carTypePro, context)
            : carTypePro == "Big commercial-11-19 seats"
                ? ApiSrvDir.calculateFares1(details, carTypePro, context)
                : 0;
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
                  // setState(() {
                  //   newValueDrop = AppLocalizations.of(context)!.cash;
                  //   Provider.of<DropBottomValue>(context, listen: false)
                  //       .updateValue("Cash");
                  // });
                } else if (val == "Pay in taxi by Credit Card" ||
                    val == "الدفع في سيارة الأجرة بواسطة بطاقة الائتمان" ||
                    val == "Kredi Kartı ile takside ödeme") {
                  newValueDrop = AppLocalizations.of(context)!.creditCard;
                  Provider.of<DropBottomValue>(context, listen: false)
                      .updateValue("Pay in taxi by Credit Card");
                  // setState(() {
                  //   newValueDrop = AppLocalizations.of(context)!.creditCard;
                  //   Provider.of<DropBottomValue>(context, listen: false)
                  //       .updateValue("Pay in taxi by Credit Card");
                  // });
                }
              }),
        ),
      ),
    );
  }

  ///================================Start Trip methods=========================

  //this them main logic for diretion + marker+ polline conect with class api
  Future<void> getPlaceDirection(BuildContext context) async {
    /// current position
    final initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;

    ///from api srv place drop of position
    final finalPos =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;

    final pickUpLatLng =
        LatLng(initialPos.latitude ?? 0.0, initialPos.longitude ?? 00);
    final dropOfLatLng =
        LatLng(finalPos.latitude ?? 0.0, finalPos.longitude ?? 0.0);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomWidgets().circularInductorCostem(context));

    ///from api dir
    final details = await ApiSrvDir.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOfLatLng, context);
    setState(() {
      tripDirectionDetails = details;
    });
    final color = Colors.greenAccent.shade700;
    Navigator.pop(context);
    const double valPadding = 50;
    // addPloyLine(details!, pickUpLatLng, dropOfLatLng, color, valPadding);
    LogicGoogleMap().addPloyLine(
        details!, pickUpLatLng, dropOfLatLng, color, valPadding, context);
  }

  // this method for add all key driver in list for pushing to searchMethod
  void gotKeyOfDriver(UserIdProvider userProvider) {
    showRiderCancelRequest = true;
    List<String> keyList = [];
    _driverAvailable = GeoFireMethods.listOfNearestDriverAvailable;
    for (var i in _driverAvailable) {
      keyList.add(i.key);
    }
    _keyDriverAvailable = LinkedHashSet<String>.from(keyList).toSet().toList();
    if (kDebugMode) {
      print('keynewList${_keyDriverAvailable.length}');
    }
    searchNearestDriver(userProvider);
  }

// this method when rider will do order
  Future<void> searchNearestDriver(UserIdProvider userProvider) async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref().child("driver");
    if (_keyDriverAvailable.isEmpty) {
      if (kDebugMode) {
        print('No driver for notify');
      }
      final res = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              CustomWidgets().sorryNoDriverDialog(context, userProvider));
      if (res == 0) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                CustomWidgets().circularInductorCostem(context));
        Provider.of<PositionCancelReq>(context, listen: false)
            .updateValue(-400.0);
        Provider.of<PositionChang>(context, listen: false).changValue(0.0);
        LogicGoogleMap().locationPosition(context);
        Navigator.pop(context);
      }
    } else if (_keyDriverAvailable.isNotEmpty) {
      if (kDebugMode) {
        print('Notify driver No : ${_keyDriverAvailable.length}');
      }
      String idDriver = _keyDriverAvailable[0];
      await _ref
          .child(idDriver)
          .child("carInfo")
          .child("carType")
          .once()
          .then((value) async {
        final snap = value.snapshot.value;
        if (snap != null) {
          carRideType = snap.toString();
          if (carRideType == carOrderType) {
            await _ref
                .child(idDriver)
                .child("newRide")
                .once()
                .then((value) async {
              if (value.snapshot.value != null) {
                final newRideStatus = value.snapshot.value;
                if (newRideStatus == "searching") {
                  notifyDriver(idDriver, context, userProvider);
                  if (kDebugMode) {
                    print('notify Driver start');
                  }
                  _keyDriverAvailable.removeAt(0);
                } else {
                  _keyDriverAvailable.removeAt(0);
                  searchNearestDriver(userProvider);
                }
              }
            });
          } else {
            _keyDriverAvailable.removeAt(0);
            searchNearestDriver(userProvider);
          }
        }
      });
    }
  }

// this method if driver in list of driver for sent notify after take his token
  Future<void> notifyDriver(String driverId, BuildContext context,
      UserIdProvider userProvider) async {
    DatabaseReference _driverRef =
        FirebaseDatabase.instance.ref().child("driver").child(driverId);
    rideRequestTimeOut = 25;
    late Timer _timer;
    await DataBaseSrv().sendRideRequestId(driverId, context);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      rideRequestTimeOut = rideRequestTimeOut - 1;
      if (state != "requesting") {
        rideRequestTimeOut = 25;
        after2MinTimeOut = 200;
        _driverRef.child("newRide").set("canceled");
        _driverRef.child("newRide").onDisconnect();
        _timer.cancel();
        timer.cancel();
        if (kDebugMode) {
          print('rider has canceled');
        }
      } else if (rideRequestTimeOut <= 0) {
        _timer.cancel();
        timer.cancel();
        rideRequestTimeOut = 25;
        _driverRef.child("newRide").set("timeOut");
        _driverRef.child("newRide").onDisconnect();
        if (kDebugMode) {
          print('timeOut  Research another Driver');
        }
        searchNearestDriver(userProvider);
      }
    });

    /// delete send token
    // await _driverRef.child("token").once().then((value) async {
    //   final snapshot = value.snapshot.value;
    //   String token = snapshot.toString();
    //   SendNotification().sendNotificationToDriver(context, token);
    //1
    _driverRef.child("newRide").onValue.listen((event) async {
      if (event.snapshot.value.toString() == "accepted") {
        _driverRef.child("newRide").onDisconnect();
        _timer.cancel();
        // closeTimerSearch.cancel();
        waitDriver = "";
        rideRequestTimeOut = 25;
        after2MinTimeOut = 200;
        sound1 = true;
        sound2 = true;
        sound3 = true;
        showDialog(
            context: context,
            builder: (context) =>
                CustomWidgets().circularInductorCostem(context));
        gotDriverInfo();
        Future.delayed(const Duration(seconds: 1))
            .whenComplete(() => Navigator.pop(context));
        if (kDebugMode) {
          print('Driver has Accepted');
        }
      }
      if (event.snapshot.value.toString() == "canceled") {
        _driverRef.child("newRide").onDisconnect();
        if (kDebugMode) {
          print('driver has canceled');
        }
        rideRequestTimeOut = 1;
      }
    });
  }

  // this method for got driver info from Ride request collection
  Future<void> gotDriverInfo() async {
    if (kDebugMode) {
      print('GOT DRIVER INFO');
    }
    final id = Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    final carType =
        Provider.of<CarTypeProvider>(context, listen: false).carType;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("Ride Request").child(id.userId);
    _rideStreamSubscription = reference.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        if (kDebugMode) {
          print('NO DRIVER INFO VAL NULL');
        }
        return;
      } else {
        showDriverInfoContainer = true;
        if (kDebugMode) {
          print('HAS DRIVER INFO VAL != NULL');
        }
        Map<String, dynamic> map =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        if (map["carInfo"] != null) {
          carDriverInfo = map["carInfo"].toString();
        }
        if (map["driverImage"] != null) {
          final newdriverImage = map["driverImage"].toString();
          driverImage = newdriverImage;
        }
        if (map["driverName"] != null) {
          carPlack = map["carPlack"].toString();
        }
        if (map["driverName"] != null) {
          driverName = map["driverName"].toString();
        }
        if (map["driverPhone"] != null) {
          driverPhone = map["driverPhone"].toString();
        }
        if (map["status"] != null) {
          statusRide = map["status"].toString();
        }
        if (map["driverLocation"] != null) {
          final driverLatitude =
              double.parse(map["driverLocation"]["latitude"].toString());
          final driverLongitude =
              double.parse(map["driverLocation"]["longitude"].toString());
          LatLng driverCurrentLocation =
              LatLng(driverLatitude, driverLongitude);
          driverNewLocation = driverCurrentLocation;
          if (statusRide == "accepted") {
            Provider.of<PositionDriverInfoProvider>(context, listen: false)
                .updateState(0.0);
            Provider.of<PositionCancelReq>(context, listen: false)
                .updateValue(-400.0);
            soundAccepted();
            newstatusRide = AppLocalizations.of(context)!.accepted;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
          } else if (statusRide == "arrived") {
            await audioPlayer.stop();
            soundArrived();
            statusRide = "Driver arrived";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.arrived;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateTimeTrip(timeTrip);
          } else if (statusRide == "onride") {
            await audioPlayer.stop();
            soundTripStart();
            if (driverNewLocation.latitude != 0.0) {
              Marker marker = Marker(
                markerId: MarkerId("myDriver$driverId"),
                position: driverNewLocation,
                icon: carType == "Taxi-4 seats"
                    ? driversNearIcon
                    : driversNearIcon1,
                infoWindow: InfoWindow(
                    title: driverName,
                    snippet: AppLocalizations.of(context)!.onWay),
                rotation: MathMethods.createRandomNumber(360),
              );
              statusRide = "Trip Started";
              newstatusRide = AppLocalizations.of(context)!.started;
              Provider.of<TimeTripStatusRide>(context, listen: false)
                  .updateStatusRide(newstatusRide);

              /// old code
              // var marker = RippleMarker(
              //   markerId: kMarkerId,
              //   position: driverNewLocation,
              //   ripple: true,
              //   icon: carType == "Taxi-4 seats"
              //       ? driversNearIcon
              //       : driversNearIcon1,
              // );
              // aNmarkers[kMarkerId] = marker;
              updateTorRidePickToDropOff(context);
              setState(() => markersSet.add(marker));
              // trickDriverCaronTrpe(driverNewLocation, marker);
            }
          } else if (statusRide == "ended") {
            updateDriverOnMap = true;
            openCollectMoney = true;
            statusRide = "Trip finished";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.finished;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateTimeTrip(timeTrip);
            markersSet.removeWhere(
                (ele) => ele.markerId.value.contains("myDriver$driverId"));
            await audioPlayer.stop();
            if (map["total"] != null) {
              int fare = int.parse(map["total"].toString());
              if (openCollectMoney == true) {
                openCollectMoney = false;
                var res = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CustomWidgets().collectMoney(context, fare);
                    });
                if (res == "close") {
                  if (map["driverId"] != null) {
                    driverId = map["driverId"].toString();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return RatingWidget(id: driverId);
                        });
                    Provider.of<RiderId>(context, listen: false)
                        .updateStatus(driverId);
                  }
                  if (_rideStreamSubscription != null) {
                    _rideStreamSubscription?.cancel();
                    _rideStreamSubscription = null;
                  }
                }
              }
            }

            ///old code
            // var marker = RippleMarker(
            //   markerId: kMarkerId,
            //   position: const LatLng(0.0, 0.0),
            //   icon: BitmapDescriptor.defaultMarkerWithHue(
            //       BitmapDescriptor.hueBlue),
            //   ripple: false,
            // );
            // setState(() => aNmarkers[kMarkerId] = marker);
          } else if (statusRide == "0") {
            statusRide = "0";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.driverCancelTrip;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateStatusRide(newstatusRide);
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateTimeTrip(timeTrip);
          }
        }
        if (statusRide == "accepted") {
          Provider.of<CloseButtonProvider>(context, listen: false)
              .updateState(false);
          updateDriverOnMap = false;
          await Geofire.stopListener();
          await deleteGeoFireMarker();
          markersSet
              .removeWhere((ele) => ele.markerId.value.contains("driver"));
          if (driverNewLocation.latitude != 0.0) {
            Marker marker = Marker(
              markerId: MarkerId("myDriver$driverId"),
              position: driverNewLocation,
              icon: carType == "Taxi-4 seats"
                  ? driversNearIcon
                  : driversNearIcon1,
              infoWindow: InfoWindow(
                  title: " $driverName",
                  snippet: AppLocalizations.of(context)!.onWay),
              rotation: MathMethods.createRandomNumber(360),
            );
            setState(() {
              markersSet.add(marker);
            });
            updateDriverToRidePickUp(driverNewLocation, context);

            ///oldCode
            // var marker = RippleMarker(
            //   markerId: kMarkerId,
            //   position: driverNewLocation,
            //   ripple: true,
            //   icon: carType == "Taxi-4 seats"
            //       ? driversNearIcon
            //       : driversNearIcon1,
            // );
            // aNmarkers[kMarkerId] = marker;
            // markersSet.add(aNmarkers[kMarkerId]!);
            setState(() => markersSet.add(marker));
          }
        }
      }
    });
  }

  Future<void> updateDriverToRidePickUp(
      LatLng driverCurrentLocation, BuildContext context) async {
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    LatLng riderLoc =
        LatLng(pickUpLoc.latitude ?? 0.0, pickUpLoc.longitude ?? 0.0);
    if (isTimeRequstTrip == false) {
      isTimeRequstTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          driverCurrentLocation, riderLoc, context);
      final color = Colors.blueAccent.shade700;
      const double valPadding = 100.0;
      LogicGoogleMap().addPloyLine(details!, riderLoc, driverCurrentLocation,
          color, valPadding, context);
      markersSet.removeWhere((ele) => ele.markerId.value.contains("dropOfId"));
      setState(() {
        timeTrip = details.durationText.toString();
      });
      Provider.of<TimeTripStatusRide>(context, listen: false)
          .updateTimeTrip(timeTrip);
      isTimeRequstTrip = false;
    }
  }

// this method for update time from pickUp to dropOff
  Future<void> updateTorRidePickToDropOff(BuildContext context) async {
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    final dropOffLoc =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;
    LatLng riderLocPickUp =
        LatLng(pickUpLoc.latitude ?? 0.0, pickUpLoc.longitude ?? 0.0);
    LatLng riderLocDropOff =
        LatLng(dropOffLoc.latitude ?? 0.0, dropOffLoc.longitude ?? 0.0);
    if (isTimeRequstTrip == false) {
      isTimeRequstTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          riderLocPickUp, riderLocDropOff, context);
      final color = Colors.greenAccent.shade700;
      const double valPadding = 50;
      LogicGoogleMap().addPloyLine(details!, riderLocPickUp, riderLocDropOff,
          color, valPadding, context);
      timeTrip = details.durationText.toString();
      Provider.of<TimeTripStatusRide>(context, listen: false)
          .updateTimeTrip(timeTrip);
      setState(() {});
      isTimeRequstTrip = false;
    }
  }

  // this method for trick driver on trip step by step
  void trickDriverCaronTrpe(LatLng driverNewLocation, Marker marker) {
    CameraPosition cameraPosition = CameraPosition(
        target: driverNewLocation, zoom: 14.0, tilt: 0.0, bearing: 0.0);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // markersSet.removeWhere((ele) => ele.markerId.value == "myDriver");
    // markersSet.add(marker);
  }

  Future<void> deleteGeoFireMarker() async {
    setState(() {
      markersSet.removeWhere((ele) => ele.markerId.value.contains("driver"));
    });
  }

  // this method for change voice connect to language
  Future<void> soundAccepted() async {
    String val = AppLocalizations.of(context)!.taxi;
    if (sound1 == true) {
      switch (val) {
        case 'Taksi':
          await audioCache.play("commingtr.mp3");
          break;
        case 'تاكسي':
          await audioCache.play("dcomingtoyouar.wav");
          break;
        default:
          await audioCache.play("onway.wav");
          break;
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    sound1 = false;
  }

  Future<void> soundArrived() async {
    String val = AppLocalizations.of(context)!.taxi;
    if (sound2 == true) {
      switch (val) {
        case 'Taksi':
          await audioCache.play("arrivedtr.mp3");
          break;
        case 'تاكسي':
          await audioCache.play("darrivedtoyouar.wav");
          break;
        default:
          await audioCache.play("waiten.wav");
          break;
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    sound2 = false;
  }

  Future<void> soundTripStart() async {
    String val = AppLocalizations.of(context)!.taxi;
    if (sound3 == true) {
      switch (val) {
        case 'Taksi':
          await audioCache.play("starttr.mp3");
          break;
        case 'تاكسي':
          await audioCache.play("youintripar.wav");
          break;
        default:
          await audioCache.play("intripen.wav");
          break;
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    sound3 = false;
  }

  // this method for clean req after cancel
  Future<void> restApp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomWidgets().circularInductorCostem(context));
    if (_rideStreamSubscription != null) {
      _rideStreamSubscription?.cancel();
      _rideStreamSubscription = null;
    }
    _driverAvailable.clear();
    GeoFireMethods.listOfNearestDriverAvailable.clear();
    updateDriverOnMap = true;
    openCollectMoney = false;
    sound1 = false;
    sound2 = false;
    sound3 = false;
    noChangeToTaxi = false;
    showRiderCancelRequest = false;
    showDriverInfoContainer = false;
    // markersSet.removeWhere((ele) => ele.markerId.value.contains("pickUpId"));
    // markersSet.removeWhere((ele) => ele.markerId.value.contains("dropOfId"));
    polylineSet.clear();
    markersSet.clear();
    after2MinTimeOut = 200;
    rideRequestTimeOut = 25;
    circlesSet.clear();
    polylineCoordinates.clear();
    tripDirectionDetails = null;
    fNameIcon = "";
    lNameIcon = "";
    waitDriver = "wait";
    state = "normal";
    geoFireRader = 4;
    statusRide = "";
    newstatusRide = "";
    carDriverInfo = "";
    driverName = "";
    driverImage = "";
    driverPhone = "";
    timeTrip = "";
    driverId = "";
    titleRate = "";
    rating = 0.0;
    carRideType = "";
    carOrderType = "Taxi-4 seats";
    tourismCityName = "";
    tourismCityPrice = "";
    driverNewLocation = const LatLng(0.0, 0.0);
    Tools().changeAllProClickTaxiBox(context);
    await LogicGoogleMap().locationPosition(context);
    await geoFireInitialize();
    setState(() {});
    Navigator.pop(context);
  }

  ///================================End=======================================
}
