import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/google_map_methods.dart';
import 'package:gd_passenger/model/directions_details.dart';
import 'package:gd_passenger/model/nearest%20_driver_%20available.dart';
import 'package:gd_passenger/model/user.dart';
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
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:gd_passenger/widget/rider_cancel_rquest.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import '../my_provider/buttom_color_pro.dart';
import '../my_provider/close_botton_driverInfo.dart';
import '../my_provider/nearsert_driver_provider.dart';
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/rider_id.dart';
import '../notification.dart';
import '../repo/api_srv_geo.dart';
import '../tools/curanny_type.dart';
import '../tools/geoFire_methods_tools.dart';
import '../widget/collect_money_dialog.dart';
import '../widget/complain_onDriver.dart';
import '../widget/driver_iconCar_info.dart';
import '../widget/driver_info.dart';
import '../widget/sorry_no_driver.dart';
import '../widget/veto_van_price_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CustomWidget _customWidget = CustomWidget();
  CustomBottomSheet customBottomSheet = CustomBottomSheet();
  final LogicGoogleMap _logicGoogleMap = LogicGoogleMap();
  final ApiSrvGeo _apiMethods = ApiSrvGeo();
  late Position currentPosition;
  bool nearDriverAvailableLoaded = false;
  late BitmapDescriptor driversNearIcon;
  late BitmapDescriptor driversNearIcon1;
  List<NearestDriverAvailable> driverAvailable = [];
  String state = "normal";
  late StreamSubscription<DatabaseEvent> rideStreamSubscription;
  bool isTimeRequstTrip = false;
  String waitState = "wait";
  double grofireRadr = 2;
  String carOrderType = "Taxi-4 seats";
  // AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();
  late AudioCache audioCache;
  bool sound1 = false;
  bool sound2 = false;
  bool sound3 = false;

  @override
  void initState() {
    DataBaseSrv().currentOnlineUserInfo(context);
    audioCache = AudioCache(fixedPlayer: audioPlayer, prefix: "assets/");
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<DoubleValue>(context).value;
    final taxiLine = Provider.of<LineTaxi>(context).islineTaxi;
    final vanLine = Provider.of<LineTaxi>(context).islineVan;
    final vetoLine = Provider.of<LineTaxi>(context).islineVeto;
    final opacityTaxi = Provider.of<OpacityChang>(context).isOpacityTaxi;
    final opacityVan = Provider.of<OpacityChang>(context).isOpacityVan;
    final opacityVeto = Provider.of<OpacityChang>(context).isOpacityVeto;
    final postionChang = Provider.of<PositionChang>(context).val;
    final carTypePro = Provider.of<CarTypeProvider>(context).carType;
    final postionCancel = Provider.of<PositionCancelReq>(context).value;
    final dropBottomProvider =
        Provider.of<DropBottomValue>(context).valueDropBottom;
    final userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    final infoUserDataReal = Provider.of<UserAllInfoDatabase>(context).users;
    final changeColor = Provider.of<ChangeColor>(context).isTrue;
    final postionDriverInfo =
        Provider.of<PositionDriverInfoProvider>(context).positionDriverInfo;
    createDriverNearIcon();
    createDriverNearIcon1();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Builder(
        builder: (context) => SafeArea(
          child: Stack(
            children: [
              customDrawer(context),
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: value),
                  duration: const Duration(milliseconds: 100),
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
                            GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition:
                                  _logicGoogleMap.kGooglePlex,
                              myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                              polylines: polylineSet,
                              markers: markersSet,
                              circles: circlesSet,
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                _logicGoogleMap.controllerGoogleMap
                                    .complete(controller);
                                newGoogleMapController = controller;
                                locationPosition(context);
                              },
                            ),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              left: 0.0,
                              child: GestureDetector(
                                onTap: () => Provider.of<PositionChang>(context,
                                        listen: false)
                                    .changValue(0.0),
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_circle_up,
                                      size: 40,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// order taxi and else...
                            AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                right: 0.0,
                                left: 0.0,
                                bottom: postionChang,
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      40 /
                                      100,
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
                                        GestureDetector(
                                          onTap: () async {
                                            final res = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SearchScreen()));
                                            if (res == "dataDir") {
                                              await getPlaceDerction(context);
                                              checkAllUserInfoReal(
                                                  infoUserDataReal, context);
                                            }
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                100,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                15.0 /
                                                100,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      searchIconOrCancelBottom(
                                                          tripDirectionDetails),
                                                ),
                                                changeTextWhereToOrTollpasses(
                                                    tripDirectionDetails),
                                                tripDirectionDetails != null
                                                    ? SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            5 /
                                                            100)
                                                    : SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            45 /
                                                            100),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons
                                                        .arrow_circle_down_outlined,
                                                    color: Colors.purple,
                                                    size: 35,
                                                  ),
                                                  onPressed: () {
                                                    Provider.of<PositionChang>(
                                                            context,
                                                            listen: false)
                                                        .changValue(-500.0);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        _customWidget.customDivider(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 0,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        changeAllProClickTaxiBox(),
                                                    child: Stack(
                                                      children: [
                                                        Opacity(
                                                            opacity: opacityTaxi ==
                                                                    true
                                                                ? 1
                                                                : 0.3,
                                                            child: _customWidget.carTypeBox(
                                                                const Image(
                                                                    image: AssetImage(
                                                                        "assets/yellow.png"),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                tripDirectionDetails !=
                                                                            null &&
                                                                        carTypePro !=
                                                                            "" &&
                                                                        carTypePro ==
                                                                            "Taxi-4 seats"
                                                                    ? "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}"
                                                                    : AppLocalizations.of(
                                                                            context)!
                                                                        .taxi,
                                                                "4",
                                                                context)),
                                                        Positioned(
                                                            right: -10.0,
                                                            top: -10.0,
                                                            child: IconButton(
                                                                onPressed: () => customBottomSheet
                                                                    .showSheetCarInfo(
                                                                        context:
                                                                            context,
                                                                        image:
                                                                            const Image(
                                                                          image:
                                                                              AssetImage("assets/yellow.png"),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                        title: AppLocalizations.of(context)!
                                                                            .regularTaxi,
                                                                        des: AppLocalizations.of(context)!
                                                                            .sedanCar,
                                                                        iconM: Icons
                                                                            .money,
                                                                        price:
                                                                            "",
                                                                        iconP: Icons
                                                                            .person,
                                                                        person:
                                                                            "4"),
                                                                icon: opacityTaxi ==
                                                                        true
                                                                    ? const Icon(
                                                                        Icons
                                                                            .info_outline,
                                                                        color: Colors
                                                                            .purple,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    : const Text(
                                                                        ""))),
                                                        Positioned(
                                                          right: 0.0,
                                                          left: 0.0,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.15 /
                                                              100,
                                                          child: Container(
                                                            height: 4,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                              color: taxiLine ==
                                                                      true
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .transparent,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await changeAllProClickVanBox();
                                                      await checkAllUserInfoReal(infoUserDataReal!, context);
                                                      infoUserDataReal
                                                                  .country ==
                                                              "Turkey"
                                                      ||contry=="Turkey"
                                                          ? await showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder: (_) =>
                                                                  const VetoVanPriceTurkeyJust())
                                                          : null;
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Opacity(
                                                            opacity:
                                                                opacityVan ==
                                                                        true
                                                                    ? 1
                                                                    : 0.3,
                                                            child: _customWidget.carTypeBox(
                                                                const Image(
                                                                    image:
                                                                        AssetImage(
                                                                            "assets/mers.png"),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                tripDirectionDetails !=
                                                                            null &&
                                                                        carTypePro !=
                                                                            "" &&
                                                                        carTypePro ==
                                                                            "Medium commercial-6-10 seats"
                                                                    ? "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}"
                                                                    : AppLocalizations.of(
                                                                            context)!
                                                                        .mediumCommercial,
                                                                "6-10",
                                                                context)),
                                                        Positioned(
                                                            right: -10.0,
                                                            top: -10.0,
                                                            child: IconButton(
                                                                onPressed: () => customBottomSheet.showSheetCarInfo(
                                                                    context:
                                                                        context,
                                                                    image: const Image(
                                                                        image: AssetImage(
                                                                            "assets/mers.png")),
                                                                    title: AppLocalizations.of(
                                                                            context)!
                                                                        .medium,
                                                                    des: AppLocalizations.of(
                                                                            context)!
                                                                        .mediumCar,
                                                                    iconM: Icons
                                                                        .money,
                                                                    price:
                                                                        "....",
                                                                    iconP: Icons
                                                                        .person,
                                                                    person:
                                                                        "6-10"),
                                                                icon: opacityVan ==
                                                                        true
                                                                    ? const Icon(
                                                                        Icons
                                                                            .info_outline,
                                                                        color: Colors
                                                                            .purple,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    : const Text(
                                                                        ""))),
                                                        Positioned(
                                                          right: 0.0,
                                                          left: 0.0,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.15 /
                                                              100,
                                                          child: Container(
                                                            height: 4,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                              color: vanLine ==
                                                                      true
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .transparent,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      changeAllProClickVetoBox();
                                                      await checkAllUserInfoReal(
                                                          infoUserDataReal!,
                                                          context);
                                                      infoUserDataReal
                                                                  .country ==
                                                              "Turkey"
                                                          ||contry=="Turkey"
                                                          ? await showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder: (_) =>
                                                                  const VetoVanPriceTurkeyJust())
                                                          : null;
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Opacity(
                                                            opacity: opacityVeto ==
                                                                    true
                                                                ? 1.0
                                                                : 0.3,
                                                            child: _customWidget.carTypeBox(
                                                                const Image(
                                                                    image: AssetImage(
                                                                        "assets/van.png"),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                tripDirectionDetails !=
                                                                            null &&
                                                                        carTypePro !=
                                                                            "" &&
                                                                        carTypePro ==
                                                                            "Big commercial-11-19 seats"
                                                                    ? "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}"
                                                                    : AppLocalizations.of(
                                                                            context)!
                                                                        .bigCommercial,
                                                                "11-19",
                                                                context)),
                                                        Positioned(
                                                            right: -10.0,
                                                            top: -10.0,
                                                            child: IconButton(
                                                                onPressed: () => customBottomSheet.showSheetCarInfo(
                                                                    context:
                                                                        context,
                                                                    image: const Image(
                                                                        image: AssetImage(
                                                                            "assets/van.png")),
                                                                    title: AppLocalizations.of(
                                                                            context)!
                                                                        .bigCommercial,
                                                                    des: AppLocalizations.of(
                                                                            context)!
                                                                        .bigCar,
                                                                    iconM: Icons
                                                                        .money,
                                                                    price:
                                                                        "....",
                                                                    iconP: Icons
                                                                        .person,
                                                                    person:
                                                                        "11-19"),
                                                                icon: opacityVeto ==
                                                                        true
                                                                    ? const Icon(
                                                                        Icons
                                                                            .info_outline,
                                                                        color: Colors
                                                                            .purple,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    : const Text(
                                                                        ""))),
                                                        Positioned(
                                                          right: 0.0,
                                                          left: 0.0,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.15 /
                                                              100,
                                                          child: Container(
                                                            height: 4,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                              color: vetoLine ==
                                                                      true
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .transparent,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        dropBottomCustom(
                                            context, dropBottomProvider),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () async {
                                                if (tripDirectionDetails ==
                                                    null) {
                                                  Tools().toastMsg(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .chooseBefore);
                                                } else {
                                                  final int amount =
                                                      checkAnyAmount(
                                                          carTypePro!,
                                                          tripDirectionDetails!);
                                                  DataBaseSrv()
                                                      .saveRiderRequest(
                                                          context, amount);
                                                  Provider.of<PositionCancelReq>(
                                                          context,
                                                          listen: false)
                                                      .updateValue(0.0);
                                                  Provider.of<PositionChang>(
                                                          context,
                                                          listen: false)
                                                      .changValue(-500.0);
                                                  setState(() {
                                                    state = "requesting";
                                                  });
                                                  driverAvailable = GeoFireMethods
                                                      .listOfNearestDriverAvailable;
                                                  searchNearestDriver(
                                                    userProvider,
                                                    context,
                                                  );
                                                  gotDriverInfo(context);
                                                }
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    6.5 /
                                                    100,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    70 /
                                                    100,
                                                decoration: BoxDecoration(
                                                  color: tripDirectionDetails !=
                                                          null
                                                      ? const Color(0xFFFFD54F)
                                                      : Colors.purple,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  AppLocalizations.of(context)!
                                                      .requestTaxi,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                )),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),

                            ///cancel container
                            AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                right: 0.0,
                                left: 0.0,
                                bottom: postionCancel,
                                child: CancelTaxi().cancelTaxiRequest(
                                    context: context,
                                    userIdProvider: userProvider,
                                    voidCallback: () {
                                      restApp();
                                      setState(() {
                                        state = "normal";
                                      });
                                    })),

                            ///driver info
                            AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                right: 0.0,
                                left: 0.0,
                                bottom: postionDriverInfo,
                                child: DriverInfo().driverInfoContainer(
                                    context: context,
                                    userIdProvider: userProvider,
                                    voidCallback: () {
                                      restApp();
                                      setState(() {
                                        state = "normal";
                                      });
                                    })),
                          ],
                        ),
                      ),
                    );
                  }),
              changeColor == false
                  ? Positioned(
                      left: AppLocalizations.of(context)!.whereTo == "إلى أين ؟"
                          ? 0.0
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFFFD54F),
                          child: IconButton(
                              onPressed: () {
                                checkAllUserInfoReal(infoUserDataReal, context);
                                Provider.of<DoubleValue>(context, listen: false)
                                    .value0Or1(1);
                                Provider.of<ChangeColor>(context, listen: false)
                                    .updateState(true);
                              },
                              icon: const Icon(
                                Icons.format_list_numbered_rtl_rounded,
                                color: Colors.black54,
                                size: 25,
                              )),
                        ),
                      ),
                    )
                  : Positioned(
                      left: AppLocalizations.of(context)!.whereTo == "إلى أين ؟"
                          ? 0.0
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () {
                                Provider.of<DoubleValue>(context, listen: false)
                                    .value0Or1(0);
                                Provider.of<ChangeColor>(context, listen: false)
                                    .updateState(false);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black54,
                                size: 25,
                              )),
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
                                  builder: (_) => complainOnDriver(context));
                            },
                            icon: Icon(
                              Icons.call,
                              color: Colors.greenAccent.shade700,
                              size: 25,
                            )),
                      ),
                    )
                  : const Text("")
            ],
          ),
        ),
      )),
    );
  }

  ///this them main logic for diretion + marker+ polline conect with class api
  Future<void> getPlaceDerction(BuildContext context) async {
    /// from api geo
    final initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;

    ///from api srv place
    final finalPos =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;

    final pickUpLatling = LatLng(initialPos.latitude, initialPos.longitude);
    final dropOfLatling = LatLng(finalPos.latitude, finalPos.longitude);
    showDialog(
        context: context,
        builder: (context) =>
            CircularInductorCostem().circularInductorCostem(context));

    ///from api dir
    final details = await ApiSrvDir.obtainPlaceDirectionDetails(
        pickUpLatling, dropOfLatling, context);
    setState(() {
      tripDirectionDetails = details;
    });
    Navigator.pop(context);

    /// PolylinePoints method
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylineResult =
        polylinePoints.decodePolyline(details!.enCodingPoints);
    polylineCoordinates.clear();

    if (decodedPolylineResult.isNotEmpty) {
      ///new add
      for (var pointLatLng in decodedPolylineResult) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    polylineSet.clear();
    setState(() {
      ///property PolylinePoints
      Polyline polyline = Polyline(
          polylineId: const PolylineId("polylineId"),
          color: Colors.greenAccent.shade700,
          width: 6,
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          points: polylineCoordinates);

      ///set from above
      polylineSet.add(polyline);
    });

    ///for fit line on map PolylinePoints
    LatLngBounds latLngBounds;
    if (pickUpLatling.latitude > dropOfLatling.latitude &&
        pickUpLatling.longitude > dropOfLatling.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
    } else if (pickUpLatling.longitude > dropOfLatling.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatling.latitude, dropOfLatling.longitude),
          northeast: LatLng(dropOfLatling.latitude, pickUpLatling.longitude));
    } else if (pickUpLatling.latitude > dropOfLatling.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOfLatling.latitude, pickUpLatling.longitude),
          northeast: LatLng(pickUpLatling.latitude, dropOfLatling.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
    }
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    ///Marker
    Marker markerPickUpLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(
            title: initialPos.placeName,
            snippet: AppLocalizations.of(context)!.myLocation),
        position: LatLng(pickUpLatling.latitude, pickUpLatling.longitude),
        markerId: const MarkerId("pickUpId"));

    Marker markerDropOfLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
            title: finalPos.placeName,
            snippet: AppLocalizations.of(context)!.dropOff),
        position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
        markerId: const MarkerId("dropOfId"));

    setState(() {
      markersSet.add(markerPickUpLocation);
      markersSet.add(markerDropOfLocation);
    });

    ///Circle
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.white,
        radius: 14.0,
        center: pickUpLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 14.0,
        center: dropOfLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("dropOfId"));
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  ///this method for got current location after that run geofire method for got the drivers nearest
  Future<dynamic> locationPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    // to fitch LatLng in google map
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    // update on google map
    CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition, zoom: 16.50, tilt: 80.0, bearing: 35.0);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    ///Not for chacking
    await _apiMethods.searchCoordinatesAddress(position, context);
    geoFireInitialize();
  }

  /// this method for display nearest driver available from rider in list by using geoFire
  void geoFireInitialize() {
    final currentPosition =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    Geofire.initialize("availableDrivers");
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, grofireRadr)
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
            if (nearDriverAvailableLoaded == true) {
              updateAvailableDriverOnMap();
            }

            break;

          case Geofire.onKeyExited:
            GeoFireMethods.removeDriverFromList(map["key"]);
            break;

          case Geofire.onKeyMoved:
            // Update your key's location
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
    });
  }

  /// this method for add icon new near driver on map
  void updateAvailableDriverOnMap() async {
    late String driverPhoneOnMap;
    setState(() {
      ///canceled
      // markersSet.clear();
    });

    Set<Marker> tMarker = {};

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
        if (map["personImage"] != null) {
          driverImage = map["personImage"].toString();
        }
        if (map["carInfo"]["carType"] != null) {
          carDriverType = map["carInfo"]["carType"].toString();
        }
        if (map["phoneNumber"] != null) {
          driverPhoneOnMap = map["phoneNumber"].toString();
        }
      });

      LatLng driverAvailablePosititon =
          LatLng(driver.latitude, driver.longitude);
      Marker marker = Marker(
        markerId: MarkerId("driver${driver.key}"),
        position: driverAvailablePosititon,
        icon: carDriverType == "Taxi-4 seats"
            ? driversNearIcon
            : driversNearIcon1,
        infoWindow: InfoWindow(
            onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => callDriverIconMap(context, driverPhoneOnMap)),
            title: " $fNameIcon $lNameIcon / " +
                AppLocalizations.of(context)!.dropOff,
            snippet:
                AppLocalizations.of(context)!.callDriver + driverPhoneOnMap),
        // rotation: MathMethods.createRandomNumber(120),
      );

      tMarker.add(marker);
      setState(() {
        markersSet.add(marker);
      });
    }

    ///cancel
    // setState(() {
    //   markersSet=tMarker;
    // });
  }

  ///this Method for custom icon driver near
  void createDriverNearIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(0.6, 0.6));
    BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/yellowcar.png")
        .then((value) {
      setState(() {
        driversNearIcon = value;
      });
    });
  }

  void createDriverNearIcon1() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(0.6, 0.6));
    BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/blackcar.png")
        .then((value) {
      setState(() {
        driversNearIcon1 = value;
      });
    });
  }

  void restApp() {
    setState(() {
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      polylineCoordinates.clear();
      tripDirectionDetails = null;
      statusRide = "";
      newstatusRide = "";
      waitState = "wait";
      carDriverInfo = "";
      driverName = "";
      driverPhone = "";
      timeTrip = "";
      driverId = "";
      titleRate = "";
      rating = 0.0;
      carRideType = "";
      carOrderType = "Taxi-4 seats";
      grofireRadr = 2;
      tourismCityName = "";
      tourismCityPrice = "";
      driverNewLocation = const LatLng(0.0, 0.0);
      markersSet.removeWhere((ele) => ele.markerId.value.contains("myDriver"));
      sound1 = false;
      sound2 = false;
      sound3 = false;
    });
    locationPosition(context);
  }

  // this method for switch text where to OR toll passes
  changeTextWhereToOrTollpasses(DirectionDetails? tripDirectionDetails) {
    if (tripDirectionDetails != null) {
      return Expanded(
          child: Text(
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
      ));
    } else {
      return Text(
        AppLocalizations.of(context)!.whereTo,
        style: const TextStyle(
            color: Colors.black38, fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  // this method for switch if cancel bottom or search icon
  searchIconOrCancelBottom(DirectionDetails? tripDirectionDetails) {
    if (tripDirectionDetails != null) {
      return IconButton(
          onPressed: () => restApp(),
          icon: const Icon(
            Icons.cancel,
            color: Colors.redAccent,
            size: 35,
          ));
    } else {
      return const Icon(
        Icons.search,
        color: Colors.black54,
        size: 35,
      );
    }
  }

  // this method for change all provider state when click taxiBox
  Future<void> changeAllProClickTaxiBox() async {
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Taxi-4 seats");
    setState(() {
      carOrderType = "Taxi-4 seats";
      grofireRadr = 2;
    });
  }

  // this method will change all provider state when click on van box
  Future<void> changeAllProClickVanBox() async {
    Provider.of<LineTaxi>(context, listen: false).changelineVan(true);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Medium commercial-6-10 seats");
    setState(() {
      carOrderType = "Medium commercial-6-10 seats";
      grofireRadr = 10;
    });
  }

  // this method will change all provider state when click on Veto box
  Future<void> changeAllProClickVetoBox() async {
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Big commercial-11-19 seats");
    setState(() {
      carOrderType = "Big commercial-11-19 seats";
      grofireRadr = 10;
    });
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

// this method for got user info from database if it was null befoer user start his request a driver
  Future<void> checkAllUserInfoReal(
      Users? infoUserDataReal, BuildContext context) async {
    if (infoUserDataReal == null) {
      DataBaseSrv().currentOnlineUserInfo(context);
    } else {
      return;
    }
  }

//dropBottom
  Widget dropBottomCustom(BuildContext context, String dropBottomProvider) {
    String? value1 = AppLocalizations.of(context)!.cash;
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        height: MediaQuery.of(context).size.height * 6 / 100,
        width: MediaQuery.of(context).size.width * 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.purple, width: 2)),
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
                              width: 50.0,
                              height: 50.0,
                            ),
                      const SizedBox(width: 10.0),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val == "Cash" || val == "نقدا" || val == "Nakit") {
                  setState(() {
                    newValueDrop = AppLocalizations.of(context)!.cash;
                    Provider.of<DropBottomValue>(context, listen: false)
                        .updateValue("Cash");
                  });
                } else if (val == "Pay in taxi by Credit Card" ||
                    val == "الدفع في سيارة الأجرة بواسطة بطاقة الائتمان" ||
                    val == "Kredi Kartı ile takside ödeme") {
                  setState(() {
                    newValueDrop = AppLocalizations.of(context)!.creditCard;
                    Provider.of<DropBottomValue>(context, listen: false)
                        .updateValue("Pay in taxi by Credit Card");
                  });
                }
              }),
        ),
      ),
    );
  }

  ///================================Start========================================
/* this method when rider will do order it will send notification
* to nearest driver [0] id driver it will cancel will switch to another
* driver if no found drivers will cancel this trip and if driver accepted
* will remove driver from map till finish his trip*/
  Future<void> searchNearestDriver(
      UserIdProvider userProvider, BuildContext context) async {
    setState(() {
      waitState = "wait";
    });
    if (driverAvailable.isEmpty) {
      DataBaseSrv().cancelRiderRequest(userProvider, context);
      restApp();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => sorryNoDriverDialog(context, userProvider));
    } else if (driverAvailable.isNotEmpty) {
      for (var ele in driverAvailable) {
        Provider.of<NearestDriverProvider>(context, listen: false)
            .updateState(ele);
        DatabaseReference ref = FirebaseDatabase.instance
            .ref()
            .child("driver")
            .child(ele.key)
            .child("carInfo")
            .child("carType");
        await ref.once().then((value) {
          final snap = value.snapshot.value;
          if (snap != null) {
            carRideType = snap.toString();
            if (carRideType == carOrderType) {
              notifyDriver(ele, context, userProvider);
              driverAvailable.removeAt(0);
            }
            Future.delayed(const Duration(seconds: 60)).whenComplete(() {
              if (waitState == "wait") {
                // Tools().toastMsg(AppLocalizations.of(context)!.noCarAvailable);
                Provider.of<PositionCancelReq>(context, listen: false)
                    .updateValue(-400.0);
                Provider.of<PositionChang>(context, listen: false)
                    .changValue(0.0);
                DataBaseSrv().cancelRiderRequest(userProvider, context);
                restApp();
              }
            });
            // else {
            //   if (waitState == "wait") {
            //     print("typenot:::$carOrderType");
            //     Tools().toastMsg(AppLocalizations.of(context)!.noCarAvailable);
            //     Provider.of<PositionCancelReq>(context, listen: false)
            //         .updateValue(-400.0);
            //     Provider.of<PositionChang>(context, listen: false)
            //         .changValue(0.0);
            //     DataBaseSrv().cancelRiderRequest(userProvider, context);
            //     restApp();
            //   }
            // }
          }
        });
      }
    } else {
      // Tools().toastMsg(AppLocalizations.of(context)!.noCarAvailable);
    }
  }

  Future<void> notifyDriver(NearestDriverAvailable driver, BuildContext context,
      UserIdProvider userProvider) async {
    setState(() {
      waitState = "";
    });
    DataBaseSrv().sendRideRequestId(driver, context);
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child("driver").child(driver.key);

    final snapshot = await driverRef.child("token").get();
    if (snapshot.value != null) {
      String token = snapshot.value.toString();
      SendNotification().sendNotificationToDriver(context, token);
    } else {
      return;
    }
    const secondPassed = Duration(seconds: 1);
    Timer.periodic(secondPassed, (timer) {
      rideRequestTimeOut = rideRequestTimeOut - 1;
      after2MinTimeOut = after2MinTimeOut - 1;
      //1
      if (state != "requesting") {
        driverRef.child("newRide").set("canceled");
        driverRef.child("newRide").onDisconnect();
        timer.cancel();
        restApp();
        setState(() {
          rideRequestTimeOut = 20;
          after2MinTimeOut = 100;
        });
      }
      //2
      driverRef.child("newRide").onValue.listen((event) {
        if (event.snapshot.value.toString() == "accepted") {
          driverRef.child("newRide").onDisconnect();
          timer.cancel();
          setState(() {
            rideRequestTimeOut = 20;
            after2MinTimeOut = 100;
            sound1 = true;
            sound2 = true;
            sound3 = true;
          });
        }
      });
      //3
      if (rideRequestTimeOut == 0) {
        driverRef.child("newRide").set("timeOut");
        driverRef.child("newRide").onDisconnect();
        timer.cancel();
        setState(() {
          rideRequestTimeOut = 20;
        });
        Geofire.initialize("availableDrivers");
        Geofire.removeLocation(driver.key);
        Future.delayed(const Duration(seconds: 2))
            .whenComplete(() => searchNearestDriver(userProvider, context));
      }
      //4
      if (after2MinTimeOut <= 0) {
        timer.cancel();
        setState(() {
          after2MinTimeOut = 100;
          rideRequestTimeOut = 20;
        });
        Tools().toastMsg(AppLocalizations.of(context)!.noCarAvailable);
        Provider.of<PositionCancelReq>(context, listen: false)
            .updateValue(-400.0);
        Provider.of<PositionChang>(context, listen: false).changValue(0.0);
        DataBaseSrv().cancelRiderRequest(userProvider, context);
        restApp();
      }
    });
  }

  // this method for got driver info from Ride request collection
  Future<void> gotDriverInfo(BuildContext context) async {
    final id = Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("Ride Request").child(id!.userId);
    rideStreamSubscription = reference.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        return;
      }
      Map<String, dynamic> map =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      if (map["carInfo"] != null) {
        carDriverInfo = map["carInfo"].toString();
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
        LatLng driverCurrentLocation = LatLng(driverLatitude, driverLongitude);
        setState(() {
          driverNewLocation = driverCurrentLocation;
        });
        if (statusRide == "accepted") {
          soundAccepted();
          updateTireRideToPickUp(driverCurrentLocation, context);
          setState(() {
            newstatusRide = AppLocalizations.of(context)!.accepted;
          });
        } else if (statusRide == "arrived") {
          await audioPlayer.stop();
          soundArrived();
          setState(() {
            statusRide = "Driver arrived";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.arrived;
          });
        } else if (statusRide == "onride") {
          await audioPlayer.stop();
          soundTripStart();
          updateTireRideToDropOff(context);
          setState(() {
            statusRide = "Trip Started";
            newstatusRide = AppLocalizations.of(context)!.started;
          });
        } else if (statusRide == "ended") {
          setState(() {
            statusRide = "Trip finished";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.finished;
          });
          await audioPlayer.stop();
          if (map["total"] != null) {
            int fare = int.parse(map["total"].toString());
            var res = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return collectMoney(context, fare);
                });

            if (res == "close") {
              if (map["driverId"] != null) {
                driverId = map["driverId"].toString();
                Provider.of<RiderId>(context, listen: false)
                    .updateStatus(driverId);
              }
              //   // showDialog(
              //   //     context: context,
              //   //     barrierDismissible: false,
              //   //     builder: (BuildContext context) {
              //   //       return RatingWidget(id: driverId);
              //   //     });
              rideStreamSubscription.cancel();
            }
          }
          Provider.of<CloseButtonProvider>(context, listen: false)
              .updateState(true);
        }
      }
      if (statusRide == "accepted") {
        Provider.of<PositionDriverInfoProvider>(context, listen: false)
            .updateState(0.0);
        Provider.of<PositionCancelReq>(context, listen: false)
            .updateValue(-400.0);
        Provider.of<CloseButtonProvider>(context, listen: false)
            .updateState(false);
        Geofire.stopListener();
        deleteGeoFireMarker();
        if (driverNewLocation != null) {
          Set<Marker> tMarker1 = {};
          Marker marker = Marker(
            markerId: MarkerId("myDriver$driverId"),
            position: driverNewLocation,
            icon: carDriverType == "Taxi-4 seats"
                ? driversNearIcon
                : driversNearIcon1,
            infoWindow: InfoWindow(
                title: " $fNameIcon $lNameIcon",
                snippet: AppLocalizations.of(context)!.onWay),
            // rotation: MathMethods.createRandomNumber(120),
          );

          tMarker1.add(marker);
          setState(() {
            markersSet.add(marker);
          });
        }
      }
    });
  }

// this method for update time driver arrive to rider in driver info container
  Future<void> updateTireRideToPickUp(
      LatLng driverCurrentLocation, BuildContext context) async {
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    LatLng riderLoc = LatLng(pickUpLoc.latitude, pickUpLoc.longitude);
    if (isTimeRequstTrip == false) {
      isTimeRequstTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          driverCurrentLocation, riderLoc, context);
      setState(() {
        timeTrip = details!.durationText.toString();
      });
      isTimeRequstTrip = false;
    }
  }

// this method for update time from pickUp to dropOff
  Future<void> updateTireRideToDropOff(BuildContext context) async {
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    final dropOffLoc =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation;
    LatLng riderLocPickUp = LatLng(pickUpLoc.latitude, pickUpLoc.longitude);
    LatLng riderLocDropOff = LatLng(dropOffLoc.latitude, dropOffLoc.longitude);
    if (isTimeRequstTrip == false) {
      isTimeRequstTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          riderLocPickUp, riderLocDropOff, context);
      setState(() {
        timeTrip = details!.durationText.toString();
      });
      isTimeRequstTrip = false;
    }
  }

// this method for delete all taxi when on taxi accepted
  void deleteGeoFireMarker() {
    setState(() {
      markersSet.removeWhere((ele) => ele.markerId.value.contains("driver"));
    });
  }

  // this metod for change voice conect to languge

  Future<void> soundAccepted() async {
    if (sound1 == true) {
      if (AppLocalizations.of(context)!.taxi == "Taksi") {
        await audioCache.play("commingtr.mp3");
      } else if (AppLocalizations.of(context)!.taxi == "تاكسي") {
        await audioCache.play("dcomingtoyouar.wav");
      } else {
        await audioCache.play("onway.wav");
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      sound1 = false;
    });
  }

  Future<void> soundArrived() async {
    if (sound2 == true) {
      if (AppLocalizations.of(context)!.taxi == "Taksi") {
        await audioCache.play("arrivedtr.mp3");
      } else if (AppLocalizations.of(context)!.taxi == "تاكسي") {
        await audioCache.play("darrivedtoyouar.wav");
      } else {
        await audioCache.play("waiten.wav");
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      sound2 = false;
    });
  }

  Future<void> soundTripStart() async {
    if (sound3 == true) {
      if (AppLocalizations.of(context)!.taxi == "Taksi") {
        await audioCache.play("starttr.mp3");
      } else if (AppLocalizations.of(context)!.taxi == "تاكسي") {
        await audioCache.play("youintripar.wav");
      } else {
        await audioCache.play("intripen.wav");
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      sound3 = false;
    });
  }

  ///================================End==========================================
}
