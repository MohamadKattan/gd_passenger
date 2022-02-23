import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gd_passenger/google_map_methods.dart';
import 'package:gd_passenger/my_provider/double_value.dart';
import 'package:gd_passenger/my_provider/lineTaxiProvider.dart';
import 'package:gd_passenger/my_provider/opictyProvider.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/widget/bottom_sheet.dart';
import 'package:gd_passenger/widget/coustom_drawer.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static CustomWidget _customWidget = CustomWidget();
  static CustomBottomSheet customBottomSheet = CustomBottomSheet();

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
    final userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    return Scaffold(
        body: Builder(
      builder: (context) => SafeArea(
        child: Stack(
          children: [
            customDrawer(context),
            TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: value),
                duration: Duration(milliseconds: 900),
                builder: (_, double val, __) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..setEntry(0, 3, 300 * val)
                      ..rotateY((pi / 6) * val),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              controllerGoogleMap.complete(controller);
                              newGoogleMapController = controller;
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
                                height: 35,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0)),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_circle_up,
                                    size: 40,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 0.0,
                              left: 0.0,
                              bottom: postionChang,
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    50 /
                                    100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 6.0,
                                          spreadRadius: 0.5,
                                          color: Colors.black54,
                                          offset: Offset(0.7, 0.7))
                                    ],
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () => customBottomSheet
                                          .showSheetWhereto(context),
                                      child: Container(
                                        color: Colors.transparent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                100,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.black54,
                                                size: 35,
                                              ),
                                            ),
                                            Text(
                                              "Where to ?",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  50 /
                                                  100,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons
                                                  .arrow_circle_down_outlined),
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _customWidget.containerBox(
                                            Icon(Icons.home_outlined),
                                            "Home",
                                            context),
                                        _customWidget.containerBox(
                                            Icon(Icons.work_outline),
                                            "Work",
                                            context),
                                      ],
                                    ),
                                    _customWidget.customDivider(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineTaxi(true);
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineVan(false);
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineVeto(false);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityTaxi(true);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityVan(false);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityVeto(false);
                                            print("don");
                                          },
                                          onLongPress: () => customBottomSheet
                                              .showSheetCarInfo(
                                                  context: context,
                                                  image: Image(
                                                    image: AssetImage(
                                                        "assets/smallTexi.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                  title: "Regular Taxi",
                                                  des:
                                                      "sedan car: Hyundai,Renault,Fiat,Toyota etc...",
                                                  iconM: Icons.money,
                                                  price: "15.0",
                                                  iconP: Icons.person,
                                                  person: "4"),
                                          child: Column(
                                            children: [
                                              Opacity(
                                                  opacity: opacityTaxi == true
                                                      ? 1
                                                      : 0.3,
                                                  child: _customWidget.carTypeBox(
                                                      Image(
                                                          image: AssetImage(
                                                              "assets/smallTexi.png"),
                                                          height: 55,
                                                          width: 90,
                                                          fit: BoxFit.contain),
                                                      "Taxi",
                                                      "",
                                                      context)),
                                              Container(
                                                height: 4,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: taxiLine == true
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineVan(true);
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineTaxi(false);
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineVeto(false);

                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityVan(true);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityTaxi(false);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityVeto(false);
                                          },
                                          onLongPress: () => customBottomSheet
                                              .showSheetCarInfo(
                                                  context: context,
                                                  image: Image(
                                                      image: AssetImage(
                                                          "assets/van.png")),
                                                  title: "Medium",
                                                  des: "Medium commercial car",
                                                  iconM: Icons.money,
                                                  price: "20.0",
                                                  iconP: Icons.person,
                                                  person: "6-10"),
                                          child: Column(
                                            children: [
                                              Opacity(
                                                  opacity: opacityVan == true
                                                      ? 1
                                                      : 0.3,
                                                  child: _customWidget.carTypeBox(
                                                      Image(
                                                          image: AssetImage(
                                                              "assets/van.png"),
                                                          height: 50,
                                                          width: 90,
                                                          fit: BoxFit.contain),
                                                      "Medium ",
                                                      "commercial",
                                                      context)),
                                              Container(
                                                height: 4,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: vanLine == true
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineVeto(true);
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineVan(false);
                                            Provider.of<LineTaxi>(context,
                                                    listen: false)
                                                .changelineTaxi(false);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityVeto(true);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityVan(false);
                                            Provider.of<OpacityChang>(context,
                                                    listen: false)
                                                .changOpacityTaxi(false);
                                          },
                                          onLongPress: () => customBottomSheet
                                              .showSheetCarInfo(
                                                  context: context,
                                                  image: Image(
                                                      image: AssetImage(
                                                          "assets/veto.png")),
                                                  title: "Big commercial",
                                                  des:
                                                      "Big commercial car: veto etc...",
                                                  iconM: Icons.money,
                                                  price: "25.0",
                                                  iconP: Icons.person,
                                                  person: "11-19"),
                                          child: Column(
                                            children: [
                                              Opacity(
                                                  opacity: opacityVeto == true
                                                      ? 1.0
                                                      : 0.3,
                                                  child: _customWidget.carTypeBox(
                                                      Image(
                                                          image: AssetImage(
                                                              "assets/veto.png"),
                                                          height: 50,
                                                          width: 90,
                                                          fit: BoxFit.contain),
                                                      "Medium",
                                                      "commercial",
                                                      context)),
                                              Container(
                                                height: 4,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: vetoLine == true
                                                      ? Colors.black
                                                      : Colors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                }),
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
}
