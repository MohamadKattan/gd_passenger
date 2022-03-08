import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/model/user.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:gd_passenger/tools/pick_image.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


TextEditingController firstname = TextEditingController();
TextEditingController lastname = TextEditingController();
TextEditingController email = TextEditingController();
PickImage pickImage = PickImage();
Tools tools = Tools();
DataBaseSrv srv = DataBaseSrv();
String mapKey= "AIzaSyBt7etvZRY_OrzFcCsawNb22jqSzE2mRDg";
GoogleMapController? newGoogleMapController;

// Future<void> checkIfRegisterBefore(
//     String resultPhone, BuildContext context) async {
//
//   try {
//
//     Provider.of<TrueFalse>(context, listen: false).changeStateBooling(false);
//     DatabaseReference ref = FirebaseDatabase.instance
//         .ref()
//         .child("users")
//         .child("");
//     TransactionResult result = await ref.runTransaction((Object? user) {
//       Map<String, dynamic> _user = Map<String, dynamic>.from(user as Map);
//       Users infoUser = Users.fromMap(_user);
//       if (resultPhone == infoUser.phone_number.toString()) {
//         print(infoUser.first_name);
//         Provider.of<UserIdProvider>(context, listen: false)
//             .updateUser(infoUser);
//
//         Provider.of<TrueFalse>(context, listen: false)
//             .changeStateBooling(false);
//         // Navigator.push(
//         //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
//       } else if (resultPhone != infoUser.phone_number) {
//         // authSev.signUpWithPhone(resultPhone, context);
//         FocusScope.of(context).requestFocus(FocusNode());
//         Provider.of<TrueFalse>(context, listen: false)
//             .changeStateBooling(true);
//       }
//       return Transaction.success(_user);
//     });
//     return null;
//   } catch (ex) {
//     Tools().toastMsg(ex.toString());
//   }
//
// }