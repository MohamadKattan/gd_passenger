import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/directions_details.dart';

class GoogleMapSet extends ChangeNotifier {
  DirectionDetails? tripDirectionDetail;
  List<LatLng> polylineCoordinate = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  late BitmapDescriptor driversNearIcon;
  late BitmapDescriptor driversNearIcon1;
  // this method for add marker on map
  updateMarkerOnMap(Marker state) {
    markersSet.add(state);
    notifyListeners();
  }

  // this method for delete all drivers marker on map when driver accepted or driver who accepted after finish his trip
  deleteDriverOnMap(String state) {
    markersSet.removeWhere((element) => element.markerId.value.contains(state));
    notifyListeners();
  }

  // this method for add polylineCoordinate
  updatePolylineCoordinateMap(LatLng state) {
    polylineCoordinate.add(state);
    notifyListeners();
  }

// this method for add polyline on map
  updatePolylineOnMap(Polyline state) {
    polylineSet.add(state);
    notifyListeners();
  }

// this method for add circle on map start point end Pont
  updateCirclesOnMap(Circle state) {
    circlesSet.add(state);
    notifyListeners();
  }

  updateTripDirectionDetail(DirectionDetails? state) {
    tripDirectionDetail = state;
    notifyListeners();
  }

  // this method for set icon for taxi
  updateBitmapIconShapeTaxi(BitmapDescriptor state) {
    driversNearIcon = state;
    notifyListeners();
  }

  // this method for set icon for veto
  updateBitmapIconShapeVeto(BitmapDescriptor state) {
    driversNearIcon1 = state;
    notifyListeners();
  }
}
