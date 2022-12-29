import 'dart:io';
import 'package:flutter/cupertino.dart';

class PickImageProvide extends ChangeNotifier {
  late File? imageProvider;

  listingToPickImage(File picked) {
    imageProvider = picked;
    notifyListeners();
  }
}
