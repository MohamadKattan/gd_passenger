// this class for listing double val for close open  drawer
import 'package:flutter/material.dart';

class DoubleValue extends ChangeNotifier {
  double value = 0;
  value0Or1(double val) {
    value = val;
    notifyListeners();
  }
}
