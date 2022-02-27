//this class will use direction api between current location and drop of location

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/directions_details.dart';
import 'package:gd_passenger/my_provider/derictionDetails_provide.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ApiSrvDir {

static Future<DirectionDetails?>obtainPlaceDirectionDetails(LatLng initialPostion, LatLng finalPostion,BuildContext context) async {

    final directionUrl = Uri.parse("https://maps.googleapis.com/maps/api/directions/json?origin=${initialPostion.latitude},${initialPostion.longitude}&destination=${finalPostion.latitude},${finalPostion.longitude}&key=${mapKey}");

    final res = await GetUrl().getUrlMethod(directionUrl);
    if (res == "failed") {
      return null ;
    }
    if(res["status"]=="OK"){
      DirectionDetails directionDetails = DirectionDetails(
          distanceText: "",
          durationText: "",
          distanceVale: 0,
          durationVale: 0,
          enCodingPoints: "");

      directionDetails.enCodingPoints=res["routes"][0]["overview_polyline"]["points"];
      directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
      directionDetails.durationVale = res["routes"][0]["legs"][0]["duration"]["value"];
      directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
      directionDetails.distanceVale = res["routes"][0]["legs"][0]["distance"]["value"];
      Provider.of<DerictionDetails>(context,listen: false).updateDerictionDetails(directionDetails);

      return directionDetails;
    }
  }
}