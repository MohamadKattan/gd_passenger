// this class for got user id from auth current user useing to check if id exist to nav to homeScreen else to AuthScree

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/model/user.dart';
import 'package:gd_passenger/repo/auth_srv.dart';

class UserIdProvider extends ChangeNotifier{
   final AuthSev _authSev =AuthSev();
   late User _currentUserId;
   late Users users;
   User get getUser=> _currentUserId;
  Future <void> getUserIdProvider()async {
    _currentUserId=await _authSev.getCurrentUserId();
    notifyListeners();
  }

  updateUser(Users user1){
    users=user1;
    notifyListeners();
  }
}