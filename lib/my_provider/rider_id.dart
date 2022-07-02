import 'package:flutter/cupertino.dart';

class RiderId extends ChangeNotifier {
  String id = "";

  void updateStatus(String riderId) {
    id = riderId;
    notifyListeners();
  }
}
