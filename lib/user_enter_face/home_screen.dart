import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/google_map_methods.dart';
import 'package:gd_passenger/model/directions_details.dart';
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
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/repo/api_srv_dir.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/user_enter_face/search_screen.dart';
import 'package:gd_passenger/widget/bottom_sheet.dart';
import 'package:gd_passenger/widget/coustom_drawer.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:gd_passenger/widget/custom_drop_bottom.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:gd_passenger/widget/rider_cancel_rquest.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static CustomWidget _customWidget = CustomWidget();
  static CustomBottomSheet customBottomSheet = CustomBottomSheet();
  static LogicGoogleMap _logicGoogleMap = LogicGoogleMap();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
Set<Polyline> polylineSet = {};
List<LatLng> polylineCoordinates = [];
Set<Marker> markersSet = {};
Set<Circle> circlesSet = {};
DirectionDetails? tripDirectionDetails;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final value = Provider.of<DoubleValue>(context).value;
    final isTrue = Provider.of<TrueFalse>(context).isTrue;
    final taxiLine = Provider.of<LineTaxi>(context).islineTaxi;
    final vanLine = Provider.of<LineTaxi>(context).islineVan;
    final vetoLine = Provider.of<LineTaxi>(context).islineVeto;
    final opacityTaxi = Provider.of<OpacityChang>(context).isOpacityTaxi;
    final opacityVan = Provider.of<OpacityChang>(context).isOpacityVan;
    final opacityVeto = Provider.of<OpacityChang>(context).isOpacityVeto;
    final postionChang = Provider.of<PositionChang>(context).val;
    final carTypePro = Provider.of<CarTypeProvider>(context).carType;
    final postionCancel=Provider.of<PosotionCancelReq>(context).value;
    final dropBottomProvider = Provider.of<DropBottomValue>(context).valueDropBottom;
    final userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    return Scaffold(
        key: _globalKey,
        body: Builder(
          builder: (context) => SafeArea(
            child: Stack(
              children: [
                customDrawer(context),
                GestureDetector(
                  onTap: () {
                    Provider.of<DoubleValue>(context, listen: false)
                        .value0Or1(0);
                    Provider.of<TrueFalse>(context, listen: false)
                        .changeStateBooling(false);
                  },
                  child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: value),
                      duration: Duration(milliseconds: 400),
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
                                      HomeScreen._logicGoogleMap.kGooglePlex,
                                  myLocationButtonEnabled: true,
                                  myLocationEnabled: true,
                                  zoomGesturesEnabled: true,
                                  zoomControlsEnabled: true,
                                  liteModeEnabled: false,
                                  trafficEnabled: false,
                                  compassEnabled: true,
                                  buildingsEnabled: true,
                                  polylines: polylineSet,
                                  markers: markersSet,
                                  circles: circlesSet,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    HomeScreen
                                        ._logicGoogleMap.controllerGoogleMap
                                        .complete(controller);
                                    newGoogleMapController = controller;
                                    HomeScreen._logicGoogleMap
                                        .locationPosition(context);
                                  },
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  left: 0.0,
                                  child: GestureDetector(
                                    onTap: () => Provider.of<PositionChang>(
                                            context,
                                            listen: false)
                                        .changValue(0.0),
                                    child: Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_circle_up,
                                          size: 40,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedPositioned(
                                    duration: Duration(seconds: 1),
                                    right: 0.0,
                                    left: 0.0,
                                    bottom: postionChang,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              45 /
                                              100,
                                      decoration: BoxDecoration(
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
                                                            SearchScreen()));
                                                if (res == "dataDir") {
                                                  await getPlaceDerction(
                                                      context);
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: searchIconOrCancelBottom(
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
                                                                50 /
                                                                100),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_circle_down_outlined,
                                                        color: Colors.purple,
                                                        size: 35,
                                                      ),
                                                      onPressed: () {
                                                        Provider.of<PositionChang>(context, listen: false).changValue(-500.0);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                         tripDirectionDetails!=null?Text(""):
                                         Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                HomeScreen._customWidget
                                                    .containerBox(
                                                        Icon(Icons
                                                            .home_outlined),
                                                        "Home",
                                                        context),
                                                HomeScreen._customWidget
                                                    .containerBox(
                                                        Icon(
                                                            Icons.work_outline),
                                                        "Work",
                                                        context),
                                              ],
                                            ),
                                            HomeScreen._customWidget
                                                .customDivider(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        changeAllProClickTaxiBox(),
                                                    child: Stack(
                                                      children: [
                                                        Opacity(
                                                            opacity: opacityTaxi ==
                                                                    true
                                                                ? 1
                                                                : 0.3,
                                                            child: HomeScreen._customWidget.carTypeBox(
                                                                Image(
                                                                    image: AssetImage(
                                                                        "assets/smallTexi.png"),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                tripDirectionDetails !=
                                                                            null &&
                                                                        carTypePro !=
                                                                            "" &&
                                                                        carTypePro ==
                                                                            "Taxi"
                                                                    ? "${ApiSrvDir.calculateFares(tripDirectionDetails!, carTypePro!)} TL"
                                                                    : "Taxi",
                                                                context)),
                                                        Positioned(
                                                            right: -10.0,
                                                            top: -10.0,
                                                            child: IconButton(
                                                                onPressed: () => HomeScreen
                                                                    .customBottomSheet
                                                                    .showSheetCarInfo(
                                                                        context:
                                                                            context,
                                                                        image:
                                                                            Image(
                                                                          image:
                                                                              AssetImage("assets/smallTexi.png"),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                        title:
                                                                            "Regular Taxi",
                                                                        des:
                                                                            "sedan car: Hyundai,Renault,Fiat,Toyota etc...",
                                                                        iconM: Icons
                                                                            .money,
                                                                        price:
                                                                            "Start:15.00",
                                                                        iconP: Icons
                                                                            .person,
                                                                        person:
                                                                            "4"),
                                                                icon:
                                                                    opacityTaxi ==
                                                                            true
                                                                        ? Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                Colors.purple,
                                                                            size:
                                                                                20,
                                                                          )
                                                                        : Text(
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
                                                  GestureDetector(
                                                    onTap: () =>
                                                        changeAllProClickVanBox(),
                                                    child: Stack(
                                                      children: [
                                                        Opacity(
                                                            opacity: opacityVan ==
                                                                    true
                                                                ? 1
                                                                : 0.3,
                                                            child: HomeScreen._customWidget.carTypeBox(
                                                                Image(
                                                                    image: AssetImage(
                                                                        "assets/van.png"),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                tripDirectionDetails !=
                                                                            null &&
                                                                        carTypePro !=
                                                                            "" &&
                                                                        carTypePro ==
                                                                            "MediumCommercial"
                                                                    ? "${ApiSrvDir.calculateFares(tripDirectionDetails!, carTypePro!)} TL"
                                                                    : "MediumCommercial",
                                                                context)),
                                                        Positioned(
                                                            right: -10.0,
                                                            top: -10.0,
                                                            child: IconButton(
                                                                onPressed: () => HomeScreen.customBottomSheet.showSheetCarInfo(
                                                                    context:
                                                                        context,
                                                                    image: Image(
                                                                        image: AssetImage(
                                                                            "assets/van.png")),
                                                                    title:
                                                                        "Medium",
                                                                    des:
                                                                        "Medium commercial car",
                                                                    iconM: Icons
                                                                        .money,
                                                                    price:
                                                                        "20.0",
                                                                    iconP: Icons
                                                                        .person,
                                                                    person:
                                                                        "6-10"),
                                                                icon:
                                                                    opacityVan ==
                                                                            true
                                                                        ? Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                Colors.purple,
                                                                            size:
                                                                                20,
                                                                          )
                                                                        : Text(
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
                                                  GestureDetector(
                                                    onTap: () {
                                                      changeAllProClickVetoBox();
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Opacity(
                                                            opacity: opacityVeto ==
                                                                    true
                                                                ? 1.0
                                                                : 0.3,
                                                            child: HomeScreen._customWidget.carTypeBox(
                                                                Image(
                                                                    image: AssetImage(
                                                                        "assets/veto.png"),
                                                                    fit: BoxFit
                                                                        .contain),
                                                                tripDirectionDetails !=
                                                                            null &&
                                                                        carTypePro !=
                                                                            "" &&
                                                                        carTypePro ==
                                                                            "Big Commercial"
                                                                    ? "${ApiSrvDir.calculateFares(tripDirectionDetails!, carTypePro!)} TL"
                                                                    : "Big Commercial",
                                                                context)),
                                                        Positioned(
                                                            right: -10.0,
                                                            top: -10.0,
                                                            child: IconButton(
                                                                onPressed: () => HomeScreen.customBottomSheet.showSheetCarInfo(
                                                                    context:
                                                                        context,
                                                                    image: Image(
                                                                        image: AssetImage(
                                                                            "assets/veto.png")),
                                                                    title:
                                                                        "Big commercial",
                                                                    des:
                                                                        "Big commercial car: veto etc...",
                                                                    iconM: Icons
                                                                        .money,
                                                                    price:
                                                                        "25.0",
                                                                    iconP: Icons
                                                                        .person,
                                                                    person:
                                                                        "11-19"),
                                                                icon:
                                                                    opacityVeto ==
                                                                            true
                                                                        ? Icon(
                                                                            Icons.info_outline,
                                                                            color:
                                                                                Colors.purple,
                                                                            size:
                                                                                20,
                                                                          )
                                                                        : Text(
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
                                                ]),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CustomDropBottom().DropBottomCustom(
                                                context, dropBottomProvider),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                  onTap: (){
                                                    DataBaseSrv().currentOnlineUserInfo();
                                                    Provider.of<PosotionCancelReq>(context,listen: false).updateValue(0.0);
                                                    Provider.of<PositionChang>(context, listen: false).changValue(- 500.0);
                                                  },
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            6.5 /
                                                            100,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            70 /
                                                            100,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFFFD54F),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      "Request a Taxi",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    )),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                AnimatedPositioned(
                                  duration: Duration(seconds: 1),
                                  right: 0.0,
                                  left: 0.0,
                                  bottom: postionCancel,
                                  child: CancelTaxi().cancelTaxiRequest(
                                      context: context,
                                      voidCallback: ()=>null),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                isTrue == false
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFFFFD54F),
                          child: IconButton(
                              onPressed: () {
                                Provider.of<DoubleValue>(context, listen: false)
                                    .value0Or1(1);
                                Provider.of<TrueFalse>(context, listen: false)
                                    .changeStateBooling(true);
                              },
                              icon: Icon(
                                Icons.format_list_numbered_rtl_rounded,
                                color: Colors.black54,
                                size: 25,
                              )),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () {
                                Provider.of<DoubleValue>(context, listen: false)
                                    .value0Or1(0);
                                Provider.of<TrueFalse>(context, listen: false)
                                    .changeStateBooling(false);
                              },
                              icon: Icon(
                                Icons.format_list_numbered_rtl_rounded,
                                color: Colors.black54,
                                size: 25,
                              )),
                        ),
                      ),
              ],
            ),
          ),
        ));
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
      decodedPolylineResult.forEach((PointLatLng pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      ///property PolylinePoints
      Polyline polyline = Polyline(
          polylineId: PolylineId("polylineId"),
          color: Colors.red,
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
        infoWindow:
            InfoWindow(title: initialPos.placeName, snippet: "My Location"),
        position: LatLng(pickUpLatling.latitude, pickUpLatling.longitude),
        markerId: MarkerId("pickUpId"));

    Marker markerDropOfLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "Drop off Location"),
        position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
        markerId: MarkerId("dropOfId"));

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
        circleId: CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 14.0,
        center: dropOfLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: CircleId("dropOfId"));
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
    print("this is details enCodingPoints:::::: ${details.enCodingPoints}");
  }

  // this method for clean
  void restApp() {
    setState(() {
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      polylineCoordinates.clear();
      tripDirectionDetails = null;
    });
    HomeScreen._logicGoogleMap.locationPosition(context);
  }

  // this method for switch text where to OR toll passes
  changeTextWhereToOrTollpasses(DirectionDetails? tripDirectionDetails) {
    if (tripDirectionDetails != null) {
      return Expanded(
          child: Text(
        "Not:if found toll passes arn\'t include!",
        style:
            TextStyle(color: Colors.white, backgroundColor: Colors.redAccent),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ));
    } else {
      return Text(
        "Where to ?",
        style: TextStyle(
            color: Colors.black38, fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  // this method for switch if cancel bottom or search icon
  searchIconOrCancelBottom(DirectionDetails? tripDirectionDetails) {
    if (tripDirectionDetails != null) {
      return IconButton(
          onPressed: () => restApp(),
          icon: Icon(
            Icons.cancel,
            color: Colors.redAccent,
            size: 35,
          ));
    } else {
      return Icon(
        Icons.search,
        color: Colors.black54,
        size: 35,
      );
    }
  }

  // this method for change all provider state when click taxiBox
  void changeAllProClickTaxiBox() {
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false).updateCarType("Taxi");
  }

  // this method will change all provider state when click on van box
  void changeAllProClickVanBox() {
    Provider.of<LineTaxi>(context, listen: false).changelineVan(true);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("MediumCommercial");
  }

  // this method will change all provider state when click on Veto box
  void changeAllProClickVetoBox() {
    Provider.of<LineTaxi>(context, listen: false).changelineVeto(true);
    Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
    Provider.of<LineTaxi>(context, listen: false).changelineTaxi(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(true);
    Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
    Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(false);
    Provider.of<CarTypeProvider>(context, listen: false)
        .updateCarType("Big Commercial");
  }
}
