// this class for send notification method

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/config.dart';
import 'package:provider/provider.dart';
import 'my_provider/info_user_database_provider.dart';
import 'my_provider/placeDetails_drop_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SendNotification{

  Future<void> sendNotificationToDriver(BuildContext context, String token) async {
 final placeName = Provider.of<PlaceDetailsDropProvider>(context,listen: false).dropOfLocation.placeName;
 final userIdRider = Provider.of<UserAllInfoDatabase>(context, listen: false).users?.userId;

    Map<String,String>header =
    {
      "Content-Type":"application/json",
      "Authorization":serverToken,
    };
    Map body=
        {
          "body":"DropOff:$placeName",
          "title":"New ride request",
        };
    Map dataMap =
        {
          "click_action":"FLUTTER_NOTIFICATION_CLICK",
          "id":"1",
          "status":"done",
          "ride_id":userIdRider,
        };
    Map sendNotificationMap =
        {
          "notification":body,
          "priority":"high",
          "data":dataMap,
          "to":token,
        };
    final url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  final res =   await http.post(
        url,
       headers: header,
       body: convert.jsonEncode(sendNotificationMap)
    );
  }
}