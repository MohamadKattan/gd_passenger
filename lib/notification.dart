// this class for send notification method

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/config.dart';
import 'package:provider/provider.dart';
import 'my_provider/app_data.dart';
import 'my_provider/placeDetails_drop_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendNotification {
  Future<void> sendNotificationToDriver(
      BuildContext context, String token) async {
    final placeNameDrop =
        Provider.of<PlaceDetailsDropProvider>(context, listen: false)
            .dropOfLocation
            .placeName;
    String? placeNamePickup =
        Provider.of<AppData>(context, listen: false).pickUpLocation.placeName;
    // final userIdRider =
    //     Provider.of<UserAllInfoDatabase>(context, listen: false).users.userId;
    // "android": {
    // "notification": {
    // "channel_id": "high_importance_channel"
    // }
    // }

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": serverToken,
    };
    // "android_channel_id": "high_importance_channel"
    Map body = {
      "body":
          "${AppLocalizations.of(context)!.from} : ${placeNamePickup ?? "PickUp"} \n${AppLocalizations.of(context)!.to}  : $placeNameDrop",
      "title": AppLocalizations.of(context)!.sendReq,
      "sound": "notify.wav",

    };
    // "ride_id": userIdRider,
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
    };
    Map sendNotificationMap = {
      "to": token,
      "priority": "high",
      "data": dataMap,
      "notification": body,
      "android": {
        "notification": {"channel_id": "high_importance_channel"}
      }
    };
    final url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    await http.post(url,
        headers: header, body: convert.jsonEncode(sendNotificationMap));
  }
}
