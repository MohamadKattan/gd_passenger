
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';


class PickImageProvide extends ChangeNotifier{
  late File? imageProvider;

  listingToPickImage(File picked){
    imageProvider = picked;
    notifyListeners();
  }
}