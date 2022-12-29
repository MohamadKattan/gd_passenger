//this class for google map methods
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gd_passenger/repo/api_srv_geo.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'config.dart';
import 'model/address.dart';
import 'model/directions_details.dart';
import 'model/place_predictions.dart';
import 'my_provider/app_data.dart';
import 'my_provider/placeDetails_drop_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var uuid = const Uuid();

class LogicGoogleMap {
  final GetUrl _getUrl = GetUrl();
  final ApiSrvGeo _apiMethods = ApiSrvGeo();
  //instant current location on map before any request on map
  Completer<GoogleMapController> controllerGoogleMap = Completer();

// set location
  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(41.084253576036936, 28.89201922194848),
    zoom: 14.4746,
  );

  Future<dynamic> locationPosition(BuildContext context) async {
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

  Future<void> tourismCities(
      String tourismCityName, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) =>
            CircularInductorCostem().circularInductorCostem(context));
    final addressModle =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    if (tourismCityName.length > 1) {
      //apiFindPlace
      final autocompleteUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$tourismCityName&key=$mapKey&sessiontoken=${uuid.v4()}&location=${addressModle.latitude},${addressModle.longitude}&radius=${50.000}");
      final response = await _getUrl.getUrlMethod(autocompleteUrl);
      if (response == "failed") {
        return;
      } else {
        if (response["status"] == "OK") {
          final predictions = response["predictions"][0];

          String id, mainTile, secondTitle;
          id = predictions["place_id"];
          mainTile = predictions["structured_formatting"]["main_text"];
          secondTitle = predictions["structured_formatting"]["secondary_text"];
          PlacePredictions pre = PlacePredictions("", "", "");
          pre.placeId = id;
          pre.mainText = mainTile;
          pre.secondaryText = secondTitle;

          await Future.delayed(const Duration(milliseconds: 300))
              .whenComplete(() async {
            final placeDetailsUrl = Uri.parse(
                "https://maps.googleapis.com/maps/api/place/details/json?place_id=${pre.placeId}&key=$mapKey");
            final res = await _getUrl.getUrlMethod(placeDetailsUrl);
            if (res == "failed") {
              return;
            }
            if (res["status"] == "OK") {
              Address address = Address(
                  placeFormattedAddress: "",
                  placeName: "",
                  placeId: "",
                  latitude: 0.0,
                  longitude: 0.0);
              address.placeId = pre.placeId;
              address.placeName = res["result"]["name"];
              address.latitude = res["result"]["geometry"]["location"]["lat"];
              address.longitude = res["result"]["geometry"]["location"]["lng"];
              Provider.of<PlaceDetailsDropProvider>(context, listen: false)
                  .updateDropOfLocation(address);
              Navigator.pop(context);
              Navigator.pop(context, 'data');
            }
          });
        }
      }
    }
  }

  // this method for add polyLine after got pick and drop
  addPloyLine(
      DirectionDetails details,
      LatLng pickUpLatLng,
      LatLng dropOfLatLng,
      Color colors,
      double valPadding,
      BuildContext context) {
    /// current placeName
    final pickUpName =
        Provider.of<AppData>(context, listen: false).pickUpLocation.placeName;

    ///from api srv place drop of position
    final dropOffName =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation
            .placeName;

    /// PolylinePoints method
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylineResult =
        polylinePoints.decodePolyline(details.enCodingPoints);
    polylineCoordinates.clear();
    if (decodedPolylineResult.isNotEmpty) {
      for (var pointLatLng in decodedPolylineResult) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    polylineSet.clear();

    double nLat, nLon, sLat, sLon;

    if (dropOfLatLng.latitude <= pickUpLatLng.latitude) {
      sLat = dropOfLatLng.latitude;
      nLat = pickUpLatLng.latitude;
    } else {
      sLat = pickUpLatLng.latitude;
      nLat = dropOfLatLng.latitude;
    }
    if (dropOfLatLng.longitude <= pickUpLatLng.longitude) {
      sLon = dropOfLatLng.longitude;
      nLon = pickUpLatLng.longitude;
    } else {
      sLon = pickUpLatLng.longitude;
      nLon = dropOfLatLng.longitude;
    }
    LatLngBounds latLngBounds = LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    );

    newGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, valPadding));

    ///Marker
    Marker markerPickUpLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(
            title: pickUpName,
            snippet: AppLocalizations.of(context)!.myLocation),
        position: LatLng(pickUpLatLng.latitude, pickUpLatLng.longitude),
        markerId: const MarkerId("pickUpId"));

    Marker markerDropOfLocation = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
            title: dropOffName, snippet: AppLocalizations.of(context)!.dropOff),
        position: LatLng(dropOfLatLng.latitude, dropOfLatLng.longitude),
        markerId: const MarkerId("dropOfId"));

    // setState(() {
    //   markersSet.add(markerPickUpLocation);
    //   markersSet.add(markerDropOfLocation);
    // });

    ///Circle
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.white,
        radius: 8.0,
        center: pickUpLatLng,
        strokeWidth: 1,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 8.0,
        center: dropOfLatLng,
        strokeWidth: 1,
        strokeColor: Colors.grey,
        circleId: const CircleId("dropOfId"));
    // setState(() {
    //   circlesSet.add(pickUpLocCircle);
    //   circlesSet.add(dropOffLocCircle);
    // });
    ///
    // setState(() {
    //   Polyline polyline = Polyline(
    //       polylineId: const PolylineId("polylineId"),
    //       color: colors,
    //       width: 5,
    //       geodesic: true,
    //       startCap: Cap.roundCap,
    //       endCap: Cap.roundCap,
    //       jointType: JointType.round,
    //       points: polylineCoordinates);
    //   polylineSet.add(polyline);
    //   circlesSet.add(pickUpLocCircle);
    //   circlesSet.add(dropOffLocCircle);
    //   markersSet.add(markerPickUpLocation);
    //   markersSet.add(markerDropOfLocation);
    // });
    Polyline polyline = Polyline(
        polylineId: const PolylineId("polylineId"),
        color: colors,
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        points: polylineCoordinates);
    polylineSet.add(polyline);
    circlesSet.add(pickUpLocCircle);
    circlesSet.add(dropOffLocCircle);
    markersSet.add(markerPickUpLocation);
    markersSet.add(markerDropOfLocation);
  }
}
