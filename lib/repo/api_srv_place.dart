// this class for api place details for drop of location from  result list place im search page

import 'package:flutter/material.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/address.dart';
import 'package:gd_passenger/my_provider/placeDetails_drop_provider.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:provider/provider.dart';

class DropPlaceDetails {
  GetUrl _getUrl = GetUrl();
  CircularInductorCostem _costem = CircularInductorCostem();

  void getPlaceAddressDetails(String placeId,BuildContext context) async {
    showDialog(
        context: context,
        builder:(context)=> _costem.circularInductorCostem(context)
    );
    final placeDetailsUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=${mapKey}");

    final res = await _getUrl.getUrlMethod(placeDetailsUrl);
    Navigator.pop(context);
    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = new Address(
          placeFormattedAddress: "",
          placeName: "",
          placeId: "",
          latitude: 0.0,
          longitude: 0.0);
      address.placeId = placeId;
      address.placeName = res["result"]["name"];
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<PlaceDetailsDropProvider>(context, listen: false)
          .updateDropOfLocation(address);
      print("Drop location  nNNn is :::: ${address.placeName}");
      print("Drop location  nNNn is :::: ${address.placeName}");
      print("Drop location  nNNn is :::: ${address.placeName}");
      Navigator.pop(context,"dataDir");
    }
  }
}
