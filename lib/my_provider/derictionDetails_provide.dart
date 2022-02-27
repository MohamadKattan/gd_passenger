// this class for listing to dirction api

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/model/directions_details.dart';

class DerictionDetails extends ChangeNotifier{
  DirectionDetails directionDetails = DirectionDetails(
      distanceText: "",
      durationText: "",
      distanceVale: 0,
      durationVale: 0,
      enCodingPoints: "");

  void updateDerictionDetails(DirectionDetails details){
    directionDetails = details;
    notifyListeners();
  }
}