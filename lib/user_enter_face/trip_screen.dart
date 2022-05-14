import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/app_data.dart';
import '../my_provider/placeDetails_drop_provider.dart';
import '../repo/api_srv_dir.dart';
import '../tools/mao_tool_kit.dart';
import '../widget/custom_circuler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({Key? key}) : super(key: key);

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
    tilt: 45,
    bearing: 45,
  );

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  Completer<GoogleMapController> controllerGoogleMap = Completer();
  late GoogleMapController newRideControllerGoogleMap;
  Set<Polyline> polylineSet = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  late BitmapDescriptor anmiatedMarkerIcon;
  late BitmapDescriptor pickUpIcon;
  late BitmapDescriptor dropOffIcon;
  late LatLng? myDriverPosition;
  bool isRequestDirection = false;
  bool isInductor = false;

  @override
  void initState() {
    isInductor = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    createPickUpRideIcon();
    createDropOffIcon();
    createDriverNearIcon();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: const TripScreen().kGooglePlex,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      markers: markersSet,
                      polylines: polylineSet,
                      circles: circlesSet,
                      onMapCreated: (GoogleMapController controller) async {
                        controllerGoogleMap.complete(controller);
                        newRideControllerGoogleMap = controller;
                        await getPlaceDirection(context);
                        getRideLiveLocationUpdate();
                      },
                    ),
                  ),

                  isInductor == true
                      ? CircularInductorCostem().circularInductorCostem(context)
                      : const Text(""),
                ],
              ))),
    );
  }

//================================Start=========================================

  /*1..this them main logic for draw direction on marker+ polyline connect
   with class api show loc driver to ride when driver accepted order*/
  Future<void> getPlaceDirection(
      BuildContext context) async {
    final myCurrentPostion=Provider.of<AppData>(context, listen: false)
        .pickUpLocation;
    final mydropOff = Provider.of<PlaceDetailsDropProvider>(context,listen: false)
        .dropOfLocation;
   final dropOfLatling=
   LatLng(myCurrentPostion.latitude, myCurrentPostion.longitude);
    final drop = LatLng(mydropOff.latitude, mydropOff.longitude);
    ///from api dir
    final details = await ApiSrvDir.obtainPlaceDirectionDetails(
        driverNewLocation,drop , context);

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

    ///Marker
    Marker markerPickUpLocation = Marker(
        icon: pickUpIcon,
        position: LatLng(driverNewLocation.latitude, driverNewLocation.longitude),
        markerId: const MarkerId("Start point"),
        infoWindow: const InfoWindow(title: "Driver start point"));

    Marker markerDropOfLocation = Marker(
        icon: dropOffIcon,
        position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
        markerId: const MarkerId("dropOfId"),
        infoWindow: InfoWindow(
            title: statusRide == "accepted"
                ? "My location"
                : "Target : Rider dropOff location"));

    setState(() {
      markersSet.add(markerPickUpLocation);
      markersSet.add(markerDropOfLocation);
    });

    ///Circle
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.white,
        radius: 4.0,
        center: driverNewLocation,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 4.0,
        center: dropOfLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("dropOfId"));
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
    const _timer = Duration(seconds: 1);
    int count = 4;
    Timer.periodic(_timer, (timer) {
      count = count - 1;
      if (count == 0) {
        timer.cancel();
        count = 4;
        isInductor = false;
      }
    });
  }

// contact to method getPlaceDirection
  void createPickUpRideIcon() {
    ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(context, size: const Size(1.0, 1.0));
    BitmapDescriptor.fromAssetImage(
        imageConfiguration, "assets/100currentlocationicon.png")
        .then((value) {
      setState(() {
        pickUpIcon = value;
      });
    });
  }

// contact to method getPlaceDirection
  void createDropOffIcon() {
    ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(context, size: const Size(0.1, 1.0));
    BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        statusRide == "accepted"
            ? "assets/100passengerlocationicon.png"
            : "assets/100flagblackwhite.png")
        .then((value) {
      setState(() {
        dropOffIcon = value;
      });
    });
  }

  // 2..this method for live location when updating on map and set to realtime
  void getRideLiveLocationUpdate() {

          LatLng oldLat = const LatLng(0, 0);
          myDriverPosition = driverNewLocation;
          LatLng mPosition = LatLng(driverNewLocation.latitude, driverNewLocation.longitude);

          ///...
          final rot = MapToolKit.getMarkerRotation(oldLat.latitude,
              oldLat.longitude, myDriverPosition?.latitude, myDriverPosition?.longitude);
          Marker anmiatedMarker = Marker(
            markerId: const MarkerId("animating"),
            infoWindow: const InfoWindow(title: "Current Driver Location"),
            position: mPosition,
            icon: anmiatedMarkerIcon,
            rotation: rot,
          );

          ///...
          setState(() {
            CameraPosition cameraPosition = CameraPosition(
                target: mPosition, zoom:16.50,tilt: 80.0,bearing: 45.0);
            newRideControllerGoogleMap
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            markersSet.removeWhere((ele) => ele.markerId.value == "animating");
            markersSet.add(anmiatedMarker);
          });

          ///...
          oldLat = mPosition;
          updateRideDetails();
  }

// 3..this method for icon car
  void createDriverNearIcon() {
    ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(context, size: const Size(0.6, 0.6));
    BitmapDescriptor.fromAssetImage(
        imageConfiguration, "assets/100navigation.png")
        .then((value) {
      setState(() {
        anmiatedMarkerIcon = value;
      });
    });
  }

/*4..this method for update rider info to driver first when driver go to rider
* pickUp location after that when driver arrived info will changed to dropOff
* location where rider want to go + time trip */
  void updateRideDetails() async {
    final posLatLin = LatLng(myDriverPosition!.latitude, myDriverPosition!.longitude);
    final myCurrentPostion=Provider.of<AppData>(context, listen: false)
        .pickUpLocation;
    final mydropOff = Provider.of<PlaceDetailsDropProvider>(context,listen: false)
        .dropOfLocation;
    final pickup = LatLng(myCurrentPostion.latitude, myCurrentPostion.longitude);
    final drop = LatLng(mydropOff.latitude, mydropOff.longitude);
    LatLng desertionLatLng;
    if (isRequestDirection == false) {
      isRequestDirection = true;
      if (myDriverPosition == null) {
        return;
      }
      if (statusRide == "accepted") {
        desertionLatLng = pickup;
      } else {
        desertionLatLng = drop;
        await ApiSrvDir.obtainPlaceDirectionDetails(
            posLatLin, desertionLatLng, context);
        isRequestDirection = false;
      }
    }
  }

  //================================End=========================================

}
