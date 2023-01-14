// this class for method get url by http

import 'package:flutter/material.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GetUrl {
  Future getUrlMethod(Uri url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var itemCount = jsonResponse;
        return itemCount;
      } else {
        Tools().toastMsg("Error !! ${response.statusCode.toString()} ",Colors.red);
        return "failed";
      }
    } catch (ex) {
      return "failed";
    }
  }
}
