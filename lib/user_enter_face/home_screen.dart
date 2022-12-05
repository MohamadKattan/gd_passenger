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
import '../my_provider/positon_driver_info_provide.dart';
import '../my_provider/rider_id.dart';
import '../my_provider/sheet_cardsc.dart';
import '../repo/api_srv_geo.dart';
import '../tools/curanny_type.dart';
import '../tools/geoFire_methods_tools.dart';
import '../tools/math_methods.dart';
import '../widget/antalya_veto.dart';
import '../widget/bodrun_veto.dart';
import '../widget/bursa_veto.dart';
import '../widget/call_driver_map.dart';
import '../widget/collect_money_dialog.dart';
import '../widget/complain_onDriver.dart';
import '../widget/driver_info.dart';
import '../widget/sorry_no_driver.dart';
import '../widget/spanca_veto.dart';
import '../widget/trabzon_veto.dart';
import '../widget/uzungol_veto.dart';
import '../widget/veto_van_price_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "dart:collection";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final CustomWidget _customWidget = CustomWidget();
  CustomBottomSheet customBottomSheet = CustomBottomSheet();
  final LogicGoogleMap _logicGoogleMap = LogicGoogleMap();
  final ApiSrvGeo _apiMethods = ApiSrvGeo();
  bool nearDriverAvailableLoaded = false;
  late BitmapDescriptor driversNearIcon;
  late BitmapDescriptor driversNearIcon1;
  List<NearestDriverAvailable> driverAvailable = [];
  List<String> keyDriverAvailable = [];
  List<String> mainKeyDriverAvailable = [];
  String state = "normal";
  String waitDriver = "wait";
  late StreamSubscription<DatabaseEvent> rideStreamSubscription;
  bool isTimeRequstTrip = false;
  double geoFireRader = 4;
  String carOrderType = "Taxi-4 seats";
  AudioPlayer audioPlayer = AudioPlayer();
  late AudioCache audioCache;
  bool sound1 = false;
  bool sound2 = false;
  bool sound3 = false;
  late Timer closeTimerSearch;
  bool updateDriverOnMap = true;

  @override
  void initState() {
    Geofire.initialize("availableDrivers");
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
    super.build(context);
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
    final dropBottomProvider = Provider.of<DropBottomValue>(context).valueDropBottom;
    final userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    final infoUserDataReal = Provider.of<UserAllInfoDatabase>(context).users;
    final changeColor = Provider.of<ChangeColor>(context).isTrue;
    final postionDriverInfo =
        Provider.of<PositionDriverInfoProvider>(context).positionDriverInfo;
    final sheetCarDsc = Provider.of<SheetCarDesc>(context).sheetValTaxi;
    final sheetCarDscMed = Provider.of<SheetCarDesc>(context).sheetValMed;
    final sheetCarDscBig = Provider.of<SheetCarDesc>(context).sheetValBig;
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
                            ///map
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 55 / 100,
                              child: GoogleMap(
                                padding: EdgeInsets.only(
                                    bottom: Platform.isIOS ? 65.0 : 8.0),
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
                                  await locationPosition();
                                  await DataBaseSrv()
                                      .currentOnlineUserInfo(context);
                                  await geoFireInitialize();
                                },
                              ),
                            ),

                            /// main container what include car types car drop button request button
                            AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                right: 0.0,
                                left: 0.0,
                                bottom: postionChang,
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      42 /
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
                                        const SizedBox(height: 3.0),

                                        /// where to
                                        Expanded(
                                          flex: 0,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final res = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SearchScreen()));
                                              if (res == "dataDir") {
                                                changeAllProClickTaxiBox();
                                                await getPlaceDirection(
                                                    context);
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 12.0, right: 12.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14.0),
                                                  border: Border.all(
                                                      width: 2.0,
                                                      color: const Color(
                                                          0xFFFBC408))),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        searchIconOrCancelBottom(
                                                            tripDirectionDetails),
                                                  ),
                                                  changeTextWhereToOrTollpasses(
                                                      tripDirectionDetails),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  2 /
                                                  100),
                                        ),
                                        Expanded(
                                            flex: 0,
                                            child:
                                                _customWidget.customDivider()),

                                        /// row of 3 car type
                                        Expanded(
                                          flex: 0,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: SizedBox(
                                              height: 75.0,
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            changeAllProClickTaxiBox(),
                                                        child: Stack(
                                                          children: [
                                                            Opacity(
                                                                opacity:
                                                                    opacityTaxi ==
                                                                            true
                                                                        ? 1
                                                                        : 0.3,
                                                                child: _customWidget
                                                                    .carTypeBox(
                                                                        const Image(
                                                                            image:
                                                                                AssetImage(
                                                                              "assets/yellow.png",
                                                                            ),
                                                                            fit: BoxFit
                                                                                .contain),
                                                                        tripDirectionDetails != null &&
                                                                                carTypePro != "" &&
                                                                                carTypePro == "Taxi-4 seats"
                                                                            ? "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}"
                                                                            : AppLocalizations.of(context)!.taxi,
                                                                        "4",
                                                                        context)),
                                                            Positioned(
                                                                right: -10.0,
                                                                top: -10.0,
                                                                child: IconButton(
                                                                    onPressed: () => Provider.of<SheetCarDesc>(context, listen: false).updateStateTaxi(0),
                                                                    icon: opacityTaxi == true
                                                                        ? const Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                Color(0xFFFBC408),
                                                                            size:
                                                                                20,
                                                                          )
                                                                        : const Text(""))),
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
                                                                      ? const Color(
                                                                          0xFF00A3E0)
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
                                                          changeAllProClickVanBox();
                                                          checkAnyListTurCityOpen(
                                                              infoUserDataReal);
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
                                                                        image: AssetImage(
                                                                            "assets/mers.png"),
                                                                        fit: BoxFit
                                                                            .contain),
                                                                    tripDirectionDetails != null &&
                                                                            carTypePro !=
                                                                                "" &&
                                                                            carTypePro ==
                                                                                "Medium commercial-6-10 seats"
                                                                        ? "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}"
                                                                        : AppLocalizations.of(context)!
                                                                            .mediumCommercial,
                                                                    "6-10",
                                                                    context)),
                                                            Positioned(
                                                                right: -10.0,
                                                                top: -10.0,
                                                                child: IconButton(
                                                                    onPressed: () {
                                                                      Provider.of<SheetCarDesc>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .updateStateMed(
                                                                              0);
                                                                    },
                                                                    icon: opacityVan == true
                                                                        ? const Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                Color(0xFFFBC408),
                                                                            size:
                                                                                20,
                                                                          )
                                                                        : const Text(""))),
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
                                                                      ? const Color(
                                                                          0xFF00A3E0)
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
                                                        onTap: () {
                                                          changeAllProClickVetoBox();
                                                          checkAnyListTurCityOpen(
                                                              infoUserDataReal);
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Opacity(
                                                                opacity:
                                                                    opacityVeto ==
                                                                            true
                                                                        ? 1.0
                                                                        : 0.3,
                                                                child: _customWidget.carTypeBox(
                                                                    const Image(
                                                                        image: AssetImage(
                                                                            "assets/van.png"),
                                                                        fit: BoxFit
                                                                            .contain),
                                                                    tripDirectionDetails != null &&
                                                                            carTypePro !=
                                                                                "" &&
                                                                            carTypePro ==
                                                                                "Big commercial-11-19 seats"
                                                                        ? "${ApiSrvDir.calculateFares1(tripDirectionDetails!, carTypePro!, context)} ${currencyTypeCheck(context)}"
                                                                        : AppLocalizations.of(context)!
                                                                            .bigCommercial,
                                                                    "11-19",
                                                                    context)),
                                                            Positioned(
                                                                right: -10.0,
                                                                top: -10.0,
                                                                child: IconButton(
                                                                    onPressed: () => Provider.of<SheetCarDesc>(context, listen: false).updateStateBig(0),
                                                                    icon: opacityVeto == true
                                                                        ? const Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                Color(0xFFFBC408),
                                                                            size:
                                                                                20,
                                                                          )
                                                                        : const Text(""))),
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
                                                                      ? const Color(
                                                                          0xFF00A3E0)
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
                                          ),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  2 /
                                                  100),
                                        ),

                                        /// drop of botton
                                        Expanded(
                                          flex: 0,
                                          child: dropBottomCustom(
                                              context, dropBottomProvider),
                                        ),

                                        /// request button
                                        const Expanded(
                                          flex: 0,
                                          child: SizedBox(height: 3.0),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: Padding(
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
                                                    Provider.of<PositionCancelReq>(
                                                            context,
                                                            listen: false)
                                                        .updateValue(0.0);
                                                    Provider.of<PositionChang>(
                                                            context,
                                                            listen: false)
                                                        .changValue(-500.0);
                                                    // if (driverAvailable.isEmpty) {
                                                    //   if (kDebugMode) {
                                                    //     print('fuck');
                                                    //   }
                                                    //   setCloseTomeDriver();
                                                    // }
                                                    final int amount =
                                                        checkAnyAmount(
                                                            carTypePro!,
                                                            tripDirectionDetails!);
                                                    DataBaseSrv()
                                                        .saveRiderRequest(
                                                            context, amount);
                                                    state = "requesting";
                                                    countFullTimeRequest(
                                                        userProvider);
                                                    gotKeyOfDriver(
                                                        userProvider);
                                                    gotDriverInfo();
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
                                                    color:
                                                        tripDirectionDetails !=
                                                                null
                                                            ? const Color(
                                                                0xFFFBC408)
                                                            : const Color(
                                                                0xFF00A3E0),
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),

                            /// sheet Car desc
                            AnimatedPositioned(
                              child: customBottomSheet.showSheetCarInfoTaxi(
                                  context: context,
                                  image: const Image(
                                    image: AssetImage("assets/yellow.png"),
                                    fit: BoxFit.contain,
                                  ),
                                  title:
                                      AppLocalizations.of(context)!.regularTaxi,
                                  des: AppLocalizations.of(context)!.sedanCar,
                                  iconM: Icons.money,
                                  price: "",
                                  iconP: Icons.person,
                                  person: "4"),
                              duration: const Duration(microseconds: 200),
                              left: 0.0,
                              right: 0.0,
                              bottom: sheetCarDsc,
                            ),
                            AnimatedPositioned(
                              child: customBottomSheet.showSheetCarInfoMedeum(
                                  context: context,
                                  image: const Image(
                                      image: AssetImage("assets/mers.png")),
                                  title: AppLocalizations.of(context)!.medium,
                                  des: AppLocalizations.of(context)!.mediumCar,
                                  iconM: Icons.money,
                                  price: "....",
                                  iconP: Icons.person,
                                  person: "6-10"),
                              duration: const Duration(microseconds: 200),
                              left: 0.0,
                              right: 0.0,
                              bottom: sheetCarDscMed,
                            ),
                            AnimatedPositioned(
                              child: customBottomSheet.showSheetCarInfoBig(
                                  context: context,
                                  image: const Image(
                                      image: AssetImage("assets/van.png")),
                                  title: AppLocalizations.of(context)!
                                      .bigCommercial,
                                  des: AppLocalizations.of(context)!.bigCar,
                                  iconM: Icons.money,
                                  price: "....",
                                  iconP: Icons.person,
                                  person: "11-19"),
                              duration: const Duration(microseconds: 200),
                              left: 0.0,
                              right: 0.0,
                              bottom: sheetCarDscBig,
                            ),

                            ///cancel container
                            AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                right: 0.0,
                                left: 0.0,
                                bottom: postionCancel,
                                child: CancelTaxi().cancelTaxiRequest(
                                    context: context,
                                    userIdProvider: userProvider,
                                    voidCallback: () async {
                                      closeTimerSearch.cancel();
                                      state = "normal";
                                      locationPosition();
                                      restApp();
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
                                    voidCallback: () async {
                                      state = "normal";
                                      restApp();
                                      driverAvailable.clear();
                                      GeoFireMethods
                                          .listOfNearestDriverAvailable
                                          .clear();
                                      keyDriverAvailable.clear();
                                      await locationPosition();
                                      await geoFireInitialize();
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
                          backgroundColor: const Color(0xFF00A3E0),
                          child: IconButton(
                              onPressed: () {
                                Provider.of<DoubleValue>(context, listen: false)
                                    .value0Or1(1);
                                Provider.of<ChangeColor>(context, listen: false)
                                    .updateState(true);
                              },
                              icon: const Icon(
                                Icons.format_list_numbered_rtl_rounded,
                                color: Colors.white,
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
                                color: Color(0xFFFBC408),
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

  ///======Start got current loction + geoFire for add all drivers on map who are close to rider=========
  //this method for got current location after that run geofire method for got the drivers nearest
  Future<dynamic> locationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition, zoom: 14.0, tilt: 0.0, bearing: 0.0);

    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await _apiMethods.searchCoordinatesAddress(position, context);
  }

  // this method for display nearest driver available from rider in list by using geoFire
  Future<void> geoFireInitialize() async {
    final currentPosition =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    try {
      Geofire.queryAtLocation(
              currentPosition.latitude, currentPosition.longitude, geoFireRader)
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
              NearestDriverAvailable nearestDriverAvailable =
                  NearestDriverAvailable("", 0.0, 0.0);
              nearestDriverAvailable.key = map['key'];
              nearestDriverAvailable.latitude = map['latitude'];
              nearestDriverAvailable.longitude = map['longitude'];
              GeoFireMethods.removeDriverFromList(nearestDriverAvailable);
              // GeoFireMethods.removeDriverFromList(map["key"]);
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

  void updateAvailableDriverOnMap() async {
    if (updateDriverOnMap == true) {
      if (kDebugMode) {
        print('update drivers on Map');
      }
      // if (GeoFireMethods.listOfNearestDriverAvailable.isEmpty) return;
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
            // setState(() {
            //   driverPhoneOneOnMap = map["phoneNumber"].toString();
            // });
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
                    builder: (_) => callDriverOnMap(context, phone));
              },
              title: " $fNameIcon $lNameIcon",
              snippet:
                  ' ${AppLocalizations.of(context)!.callDriver} : $driverPhoneOneOnMap'),
          rotation: MathMethods.createRandomNumber(360),
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
      // setState(() {
      //   driversNearIcon = value;
      // });
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
      // setState(() {
      //   driversNearIcon1 = value;
      // });
      driversNearIcon1 = value;
    });
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
          onPressed: () {
            restApp();
            locationPosition();
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

  // this method for change all provider state when click taxiBox
  Future<void> changeAllProClickTaxiBox() async {
    geoFireRader = 4;
    markersSet.clear();
    GeoFireMethods.listOfNearestDriverAvailable.clear();
    geoFireInitialize();
    carOrderType = "Taxi-4 seats";
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Taxi-4 seats");
  }

  // this method will change all provider state when click on van box
  Future<void> changeAllProClickVanBox() async {
    geoFireRader = 15;
    markersSet.clear();
    GeoFireMethods.listOfNearestDriverAvailable.clear();
    geoFireInitialize();
    carOrderType = "Medium commercial-6-10 seats";
    Provider.of<LineTaxi>(context, listen: false).changelineVan(true);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Medium commercial-6-10 seats");
  }

  // this method will change all provider state when click on Veto box
  Future<void> changeAllProClickVetoBox() async {
    geoFireRader = 15;
    markersSet.clear();
    GeoFireMethods.listOfNearestDriverAvailable.clear();
    geoFireInitialize();
    carOrderType = "Big commercial-11-19 seats";
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Big commercial-11-19 seats");
  }

  // this method for check any city in turkey and open list of city tur
  Future<void> checkAnyListTurCityOpen(Users infoUserDataReal) async {
    switch (infoUserDataReal.country) {
      case 'İstanbul':
        final _res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => vetoVanPriceTurkeyJust(context));
        if (_res == 'data') {
          getPlaceDirection(context);
        }
        break;
      case 'Antalya':
        final _res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => antalyVeto(context));
        if (_res == 'data') {
          getPlaceDirection(context);
        }
        break;
      case 'Muğla':
        final _res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => bodrunVeto(context));
        if (_res == 'data') {
          getPlaceDirection(context);
        }
        break;
      case 'Bursa':
        final _res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => bursaVeto(context));
        if (_res == 'data') {
          getPlaceDirection(context);
        }
        break;
      case 'Sakarya':
        final _res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => sapancaVeto(context));
        if (_res == 'data') {
          getPlaceDirection(context);
        }
        break;
      case 'Trabzon':
        final _res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => trabzonVeto(context));
        if (_res == 'data') {
          getPlaceDirection(context);
        }
        break;
      case 'Çaykara':
        final _res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => uzungolVeto(context));
        if (_res == 'data') {
          getPlaceDirection(context);
        }
        break;
      default:
        null;
        break;
    }
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
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Container(
        margin: const EdgeInsets.only(left: 4.0, right: 4.0),
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height * 6 / 100,
        width: MediaQuery.of(context).size.width * 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: const Color(0xFFFBC408), width: 2)),
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

    final pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    final dropOfLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (context) =>
            CircularInductorCostem().circularInductorCostem(context));

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
    _logicGoogleMap.addPloyLine(
        details!, pickUpLatLng, dropOfLatLng, color, valPadding, context);
  }

  // this method for add all key driver in list for pushing to searchMethod
  void gotKeyOfDriver(UserIdProvider userProvider) {
    List<String> keyList = [];
    driverAvailable = GeoFireMethods.listOfNearestDriverAvailable;
    for (var i in driverAvailable) {
      keyList.add(i.key);
      // keyDriverAvailable.add(i.key);
    }
    keyDriverAvailable = LinkedHashSet<String>.from(keyList).toSet().toList();
    if (kDebugMode) {
      print('keynewList${keyDriverAvailable.length}');
    }
    searchNearestDriver(userProvider);
  }

// this method when rider will do order
  Future<void> searchNearestDriver(UserIdProvider userProvider) async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref().child("driver");
    if (keyDriverAvailable.isEmpty) {
      closeTimerSearch.cancel();
      Provider.of<PositionCancelReq>(context, listen: false)
          .updateValue(-400.0);
      Provider.of<PositionChang>(context, listen: false).changValue(0.0);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => sorryNoDriverDialog(context, userProvider));
      restApp();
      locationPosition();
      if (kDebugMode) {
        print('No driver stopped notify');
      }
    } else if (keyDriverAvailable.isNotEmpty) {
      if (kDebugMode) {
        print('Notify driver No : ${keyDriverAvailable.length}');
      }
      String idDriver = keyDriverAvailable[0];
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
                  keyDriverAvailable.removeAt(0);
                } else {
                  keyDriverAvailable.removeAt(0);
                  searchNearestDriver(userProvider);
                }
              }
            });
          } else {
            keyDriverAvailable.removeAt(0);
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

    ///todo delete send token
    // await _driverRef.child("token").once().then((value) async {
    //   final snapshot = value.snapshot.value;
    //   String token = snapshot.toString();
    //   SendNotification().sendNotificationToDriver(context, token);
    //1
    _driverRef.child("newRide").onValue.listen((event) {
      if (event.snapshot.value.toString() == "accepted") {
        _driverRef.child("newRide").onDisconnect();
        _timer.cancel();
        closeTimerSearch.cancel();
        // setState(() {
        //   waitDriver = "";
        //   rideRequestTimeOut = 25;
        //   after2MinTimeOut = 200;
        //   sound1 = true;
        //   sound2 = true;
        //   sound3 = true;
        // });
        waitDriver = "";
        rideRequestTimeOut = 25;
        after2MinTimeOut = 200;
        sound1 = true;
        sound2 = true;
        sound3 = true;
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

    rideStreamSubscription = reference.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        if (kDebugMode) {
          print('NO DRIVER INFO VAL NULL');
        }
        return;
      }
      if (kDebugMode) {
        print('HAS DRIVER INFO VAL != NULL');
      }
      Map<String, dynamic> map =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      if (map["carInfo"] != null) {
        // setState(() {
        //   carDriverInfo = map["carInfo"].toString();
        // });
        carDriverInfo = map["carInfo"].toString();
      }
      if (map["driverImage"] != null) {
        final newdriverImage = map["driverImage"].toString();
        driverImage = newdriverImage;
        // setState(() {
        //   driverImage = newdriverImage;
        // });
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
        LatLng driverCurrentLocation = LatLng(driverLatitude, driverLongitude);

        ///todo
        // setState(() {
        //   driverNewLocation = driverCurrentLocation;
        // });
        driverNewLocation = driverCurrentLocation;
        if (statusRide == "accepted") {
          soundAccepted();
          newstatusRide = AppLocalizations.of(context)!.accepted;
          markersSet
              .removeWhere((ele) => ele.markerId.value.contains("driver"));
          // setState(() {
          //   newstatusRide = AppLocalizations.of(context)!.accepted;
          //   markersSet
          //       .removeWhere((ele) => ele.markerId.value.contains("driver"));
          // });
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
          // setState(() {
          //   statusRide = "Trip Started";
          //   newstatusRide = AppLocalizations.of(context)!.started;
          // });
          if (driverNewLocation.latitude != 0.0) {
            markersSet.clear();
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
            setState(() {
              statusRide = "Trip Started";
              newstatusRide = AppLocalizations.of(context)!.started;
              markersSet.add(marker);
            });
            updateTorRidePickToDropOff(context);
            trickDriverCaronTrpe(driverNewLocation, marker);
          }
        } else if (statusRide == "ended") {
          setState(() {
            statusRide = "Trip finished";
            timeTrip = "";
            newstatusRide = AppLocalizations.of(context)!.finished;
            markersSet
                .removeWhere((ele) => ele.markerId.value.contains("myDriver"));
            updateDriverOnMap = true;
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
                // setState(() {
                //   driverId = map["driverId"].toString();
                //   Provider.of<RiderId>(context, listen: false)
                //       .updateStatus(driverId);
                // });
              }
              rideStreamSubscription.cancel();
            }
          }
        }
      }
      if (statusRide == "accepted") {
        Provider.of<PositionDriverInfoProvider>(context, listen: false)
            .updateState(0.0);
        Provider.of<PositionCancelReq>(context, listen: false)
            .updateValue(-400.0);
        Provider.of<CloseButtonProvider>(context, listen: false)
            .updateState(false);
        markersSet.clear();
        updateDriverOnMap = false;
        await Geofire.stopListener();
        await deleteGeoFireMarker();
        if (driverNewLocation.latitude != 0.0) {
          Marker marker = Marker(
            markerId: MarkerId("myDriver$driverId"),
            position: driverNewLocation,
            icon:
                carType == "Taxi-4 seats" ? driversNearIcon : driversNearIcon1,
            infoWindow: InfoWindow(
                title: " $driverName",
                snippet: AppLocalizations.of(context)!.onWay),
            rotation: MathMethods.createRandomNumber(360),
          );
          setState(() {
            markersSet.add(marker);
          });
          updateDriverToRidePickUp(driverNewLocation, context);
        }
      }
    });
  }

  Future<void> countFullTimeRequest(UserIdProvider userProvider) async {
    int _count = 200;
    closeTimerSearch =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      _count = _count - 1;
      if (_count <= 0) {
        closeTimerSearch.cancel();
        timer.cancel();
        if (waitDriver == "wait") {
          Provider.of<PositionCancelReq>(context, listen: false)
              .updateValue(-400.0);
          Provider.of<PositionChang>(context, listen: false).changValue(0.0);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => sorryNoDriverDialog(context, userProvider));
          restApp();
          locationPosition();
        } else {
          return;
        }
      }
    });
  }

// this method for update time driver arrive to rider in driver info container
  Future<void> updateDriverToRidePickUp(
      LatLng driverCurrentLocation, BuildContext context) async {
    final pickUpLoc =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    LatLng riderLoc = LatLng(pickUpLoc.latitude, pickUpLoc.longitude);
    if (isTimeRequstTrip == false) {
      isTimeRequstTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          driverCurrentLocation, riderLoc, context);
      final color = Colors.blueAccent.shade700;
      const double valPadding = 100.0;
      // addPloyLine(details!, riderLoc, driverCurrentLocation, color, valPadding);
      _logicGoogleMap.addPloyLine(details!, riderLoc, driverCurrentLocation,
          color, valPadding, context);
      markersSet.removeWhere((ele) => ele.markerId.value.contains("dropOfId"));
      setState(() {
        timeTrip = details.durationText.toString();
      });
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
    LatLng riderLocPickUp = LatLng(pickUpLoc.latitude, pickUpLoc.longitude);
    LatLng riderLocDropOff = LatLng(dropOffLoc.latitude, dropOffLoc.longitude);
    if (isTimeRequstTrip == false) {
      isTimeRequstTrip = true;
      final details = await ApiSrvDir.obtainPlaceDirectionDetails(
          riderLocPickUp, riderLocDropOff, context);
      final color = Colors.greenAccent.shade700;
      const double valPadding = 50;
      _logicGoogleMap.addPloyLine(details!, riderLocPickUp, riderLocDropOff,
          color, valPadding, context);
      setState(() {
        timeTrip = details.durationText.toString();
      });
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
    markersSet.add(marker);
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
    updateDriverOnMap = true;
    polylineSet.clear();
    markersSet.removeWhere((ele) => ele.markerId.value.contains("pickUpId"));
    markersSet.removeWhere((ele) => ele.markerId.value.contains("dropOfId"));
    // markersSet.clear();
    fNameIcon = "";
    lNameIcon = "";
    waitDriver = "wait";
    after2MinTimeOut = 200;
    rideRequestTimeOut = 25;
    tMarker.clear();
    circlesSet.clear();
    polylineCoordinates.clear();
    tripDirectionDetails = null;
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
    geoFireRader = 4;
    tourismCityName = "";
    tourismCityPrice = "";
    driverNewLocation = const LatLng(0.0, 0.0);
    sound1 = false;
    sound2 = false;
    sound3 = false;
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Taxi-4 seats");
    setState(() {});
  }

  ///================================End=======================================
}

// this method for add polyLine after got pick and drop
//   addPloyLine(DirectionDetails details, LatLng pickUpLatLng,
//       LatLng dropOfLatLng, Color colors, double valPadding) {
//     /// current placeName
//     final pickUpName =
//         Provider.of<AppData>(context, listen: false).pickUpLocation.placeName;
//
//     ///from api srv place drop of position
//     final dropOffName =
//         Provider.of<PlaceDetailsDropProvider>(context, listen: false)
//             .dropOfLocation
//             .placeName;
//
//     /// PolylinePoints method
//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> decodedPolylineResult =
//         polylinePoints.decodePolyline(details.enCodingPoints);
//     polylineCoordinates.clear();
//     if (decodedPolylineResult.isNotEmpty) {
//       for (var pointLatLng in decodedPolylineResult) {
//         polylineCoordinates
//             .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
//       }
//     }
//     polylineSet.clear();
//     setState(() {
//       Polyline polyline = Polyline(
//           polylineId: const PolylineId("polylineId"),
//           color: colors,
//           width: 5,
//           geodesic: true,
//           startCap: Cap.roundCap,
//           endCap: Cap.roundCap,
//           jointType: JointType.round,
//           points: polylineCoordinates);
//       polylineSet.add(polyline);
//     });
//     // Navigator.pop(context);
//     ///for fit line on map PolylinePoints
//     // LatLngBounds latLngBounds;
//     // if (pickUpLatLng.latitude > dropOfLatLng.latitude &&
//     //     pickUpLatLng.longitude > dropOfLatLng.longitude) {
//     //   latLngBounds =
//     //       LatLngBounds(southwest: dropOfLatLng, northeast: pickUpLatLng);
//     // } else if (pickUpLatLng.longitude > dropOfLatLng.longitude) {
//     //   latLngBounds = LatLngBounds(
//     //       southwest: LatLng(pickUpLatLng.latitude, dropOfLatLng.longitude),
//     //       northeast: LatLng(dropOfLatLng.latitude, pickUpLatLng.longitude));
//     // } else if (pickUpLatLng.latitude > dropOfLatLng.latitude) {
//     //   latLngBounds = LatLngBounds(
//     //       southwest: LatLng(dropOfLatLng.latitude, pickUpLatLng.longitude),
//     //       northeast: LatLng(pickUpLatLng.latitude, dropOfLatLng.longitude));
//     // } else {
//     //   latLngBounds =
//     //       LatLngBounds(southwest: dropOfLatLng, northeast: pickUpLatLng);
//     // }
//     // newGoogleMapController
//     //     ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 99.0));
//     double nLat, nLon, sLat, sLon;
//
//     if (dropOfLatLng.latitude <= pickUpLatLng.latitude) {
//       sLat = dropOfLatLng.latitude;
//       nLat = pickUpLatLng.latitude;
//     } else {
//       sLat = pickUpLatLng.latitude;
//       nLat = dropOfLatLng.latitude;
//     }
//     if (dropOfLatLng.longitude <= pickUpLatLng.longitude) {
//       sLon = dropOfLatLng.longitude;
//       nLon = pickUpLatLng.longitude;
//     } else {
//       sLon = pickUpLatLng.longitude;
//       nLon = dropOfLatLng.longitude;
//     }
//     LatLngBounds latLngBounds = LatLngBounds(
//       northeast: LatLng(nLat, nLon),
//       southwest: LatLng(sLat, sLon),
//     );
//
//     newGoogleMapController
//         ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, valPadding));
//
//     ///Marker
//     Marker markerPickUpLocation = Marker(
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
//         infoWindow: InfoWindow(
//             title: pickUpName,
//             snippet: AppLocalizations.of(context)!.myLocation),
//         position: LatLng(pickUpLatLng.latitude, pickUpLatLng.longitude),
//         markerId: const MarkerId("pickUpId"));
//
//     Marker markerDropOfLocation = Marker(
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueRed,
//         ),
//         infoWindow: InfoWindow(
//             title: dropOffName, snippet: AppLocalizations.of(context)!.dropOff),
//         position: LatLng(dropOfLatLng.latitude, dropOfLatLng.longitude),
//         markerId: const MarkerId("dropOfId"));
//
//     setState(() {
//       markersSet.add(markerPickUpLocation);
//       markersSet.add(markerDropOfLocation);
//     });
//
//     ///Circle
//     Circle pickUpLocCircle = Circle(
//         fillColor: Colors.white,
//         radius: 8.0,
//         center: pickUpLatLng,
//         strokeWidth: 1,
//         strokeColor: Colors.grey,
//         circleId: const CircleId("pickUpId"));
//
//     Circle dropOffLocCircle = Circle(
//         fillColor: Colors.white,
//         radius: 8.0,
//         center: dropOfLatLng,
//         strokeWidth: 1,
//         strokeColor: Colors.grey,
//         circleId: const CircleId("dropOfId"));
//     setState(() {
//       circlesSet.add(pickUpLocCircle);
//       circlesSet.add(dropOffLocCircle);
//     });
//   }

// this method for delete all taxi when on taxi accepted
