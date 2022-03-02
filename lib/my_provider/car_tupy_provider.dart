// this class for listing to type car for use when request start to know price car if small or another

import 'package:flutter/cupertino.dart';

class CarTypeProvider extends ChangeNotifier{

  String?carType = "";

  void updateCarType(String? type){
    carType=type;
    notifyListeners();
  }
}