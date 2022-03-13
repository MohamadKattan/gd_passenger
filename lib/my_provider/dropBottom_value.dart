
//this class for listing to value change in dropBottom
import 'package:flutter/cupertino.dart';

class DropBottomValue extends ChangeNotifier {
  String valueDropBottom = "Cash";

  void updateValue(String val) {
    valueDropBottom = val;
    notifyListeners();
  }
}
