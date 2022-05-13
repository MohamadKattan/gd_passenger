// this method for check currency type connect to country

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../my_provider/car_tupy_provider.dart';
import '../my_provider/info_user_database_provider.dart';

String currencyTypeCheck(BuildContext context) {
  final userInfo =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  final carTypePro =
      Provider.of<CarTypeProvider>(context, listen: false).carType;
  String _currencyType = "";
  if (userInfo?.country == "Turkey" && carTypePro == "Taxi-4 seats") {
    _currencyType = "TL";
  } else if (userInfo?.country == "Turkey" &&
      carTypePro == "Medium commercial-6-10 seats") {
    _currencyType = "\$";
  } else if (userInfo?.country == "Turkey" &&
      carTypePro == "Big commercial-11-19 seats") {
    _currencyType = "\$";
  } else if (userInfo?.country == "Morocco") {
    _currencyType == "MAD";
  } else if (userInfo?.country == "Sudan") {
    _currencyType == "SUP";
  } else if (userInfo?.country == "Saudi Arabia") {
    _currencyType == "SAR";
  } else if (userInfo?.country == "Qatar") {
    _currencyType == "QAR";
  } else if (userInfo?.country == "Libya") {
    _currencyType == "LYD";
  } else if (userInfo?.country == "Kuwait") {
    _currencyType == "KWD";
  } else if (userInfo?.country == "Iraq") {
    _currencyType == "\$";
  } else if (userInfo?.country == "United Arab Emirates") {
    _currencyType == "AED";
  }
  return _currencyType;
}
