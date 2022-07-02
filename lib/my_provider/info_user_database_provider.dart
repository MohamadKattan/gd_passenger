/* this class for got all info user from database realTime collection"users" for using when user will request a taxi
and set in rider request collection
*/
import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/model/user.dart';

class UserAllInfoDatabase extends ChangeNotifier {
  Users users = Users(
      firstName: "",
      lastName: "",
      imageProfile: "",
      phoneNumber: "",
      userId: "",
      email: "",
      status: "",
      country: "",
      update: false);
  void updateUser(Users users1) {
    users = users1;
    notifyListeners();
  }
}
