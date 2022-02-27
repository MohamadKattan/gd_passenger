
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';


class PickImageProvide extends ChangeNotifier{
  late XFile?ImageProvider=null  ;

  listingToPickImage(XFile picked){
    ImageProvider = picked;
    notifyListeners();
  }
}