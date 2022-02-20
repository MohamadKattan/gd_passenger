
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gd_passenger/google_map_methods.dart';
import 'package:gd_passenger/my_provider/double_value.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/widget/coustom_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = Provider.of<DoubleValue>(context).value;
    late var isTrue = Provider.of<TrueFalse>(context).isTrue;
    var userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    return Scaffold(
        body: Builder(
      builder: (context) => SafeArea(
        child: Stack(
          children: [
            customDrawer(context),
            TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: value),
                duration: Duration(milliseconds: 800),
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
                )
          ],
        ),
      ),
    ));
  }
}

