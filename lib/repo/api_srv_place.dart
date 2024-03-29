// this class for api place details for drop of location from  result list place im search page

import 'package:flutter/material.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/address.dart';
import 'package:gd_passenger/my_provider/placeDetails_drop_provider.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:provider/provider.dart';
import '../widget/custom_widgets.dart';

class DropPlaceDetails {
  final GetUrl _getUrl = GetUrl();

  Future<void> getPlaceAddressDetails(
      String placeId, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => CustomWidgets().circularInductorCostem(context));
    final placeDetailsUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey");

    final res = await _getUrl.getUrlMethod(placeDetailsUrl);
    Navigator.pop(context);
    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeFormattedAddress = "";
      address.placeId = placeId;
      address.placeName = res["result"]["name"];
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<PlaceDetailsDropProvider>(context, listen: false)
          .updateDropOfLocation(address);

      // Provider.of<LineTaxi>(context, listen: false).changelineTaxi(true);
      // Provider.of<LineTaxi>(context, listen: false).changelineVan(false);
      // Provider.of<LineTaxi>(context, listen: false).changelineVeto(false);
      // Provider.of<OpacityChang>(context, listen: false).changOpacityTaxi(true);
      // Provider.of<OpacityChang>(context, listen: false).changOpacityVan(false);
      // Provider.of<OpacityChang>(context, listen: false).changOpacityVeto(false);
      // Provider.of<CarTypeProvider>(context, listen: false)
      //     .updateCarType("Taxi-4 seats");
      Navigator.pop(context, "dataDir");
    }
  }
}
