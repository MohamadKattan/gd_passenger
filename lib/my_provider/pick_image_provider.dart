
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';


class PickImageProvide extends ChangeNotifier{
  late XFile? imageProvider = null;

  listingToPickImage(XFile picked){
    imageProvider = picked;
    notifyListeners();
  }
}