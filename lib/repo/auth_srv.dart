import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:gd_passenger/user_enter_face/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/user.dart';
import '../my_provider/info_user_database_provider.dart';
import '../user_enter_face/user_info_screen.dart';

// this class for Auth by firebase-phone method
/// we canceled for now
// class AuthSev {
//   final Tools _tools = Tools();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   late UserCredential userCredential;
//   late User currentUser;
//   final TextEditingController code = TextEditingController();
// // this method for register by phone number
//   Future<void> signUpWithPhone(String result, BuildContext context) async {
//     try {
//       await auth.verifyPhoneNumber(
//           phoneNumber: result,
//           timeout: const Duration(seconds: 120),
//           verificationCompleted: (PhoneAuthCredential credential) async {
//             Navigator.pop(context);
//             userCredential = await auth.signInWithCredential(credential);
//             await getCurrentUserId();
//             Provider.of<TrueFalse>(context, listen: false)
//                 .changeStateBooling(false);
//             if (userCredential.user != null) {
//               Provider.of<TrueFalse>(context, listen: false)
//                   .changeStateBooling(false);
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => UserInfoScreen()));
//             } else {
//               _tools.toastMsg(AppLocalizations.of(context)!.wrong);
//               _tools.toastMsg(AppLocalizations.of(context)!.checkPhone);
//               Provider.of<TrueFalse>(context, listen: false)
//                   .changeStateBooling(false);
//             }
//           },
//           verificationFailed: (FirebaseAuthException e) {
//             Provider.of<TrueFalse>(context, listen: false)
//                 .changeStateBooling(false);
//             _tools.toastMsg("Error${e.toString()}");
//           },
//           codeSent: (String verificationId, int? resendToken) {
//             Provider.of<TrueFalse>(context, listen: false)
//                 .changeStateBooling(false);
//             showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (context) {
//                   return AlertDialog(
//                     content: SizedBox(
//                       height: 80,
//                       width: MediaQuery.of(context).size.width * 80 / 100,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                            Text(AppLocalizations.of(context)!.typeCode),
//                           Expanded(
//                             flex: 1,
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: TextField(
//                                 controller: code,
//                                 maxLength: 15,
//                                 showCursor: true,
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w600),
//                                 cursorColor: const Color(0xFFFFD54F),
//                                 decoration:  InputDecoration(
//                                   icon: const Padding(
//                                     padding: EdgeInsets.only(top: 15.0),
//                                     child: Icon(
//                                       Icons.vpn_key,
//                                       color: Color(0xFFFFD54F),
//                                     ),
//                                   ),
//                                   fillColor:const Color(0xFFFFD54F),
//                                   hintText: AppLocalizations.of(context)!.yourCode,
//                                 ),
//                                 keyboardType: TextInputType.phone,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     actions: [
//                       GestureDetector(
//                           onTap: () async {
//                             if (code.text.isNotEmpty) {
//                               PhoneAuthCredential credential =
//                                   PhoneAuthProvider.credential(
//                                       verificationId: verificationId,
//                                       smsCode: code.text.trim());
//                               userCredential =
//                                   await auth.signInWithCredential(credential);
//                               await getCurrentUserId();
//                               if (userCredential.user != null) {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                          const   UserInfoScreen()));
//                               } else {
//                                 Provider.of<TrueFalse>(context, listen: false)
//                                     .changeStateBooling(false);
//                                 _tools.toastMsg(AppLocalizations.of(context)!.wrong);
//                                 Navigator.pop(context);
//                               }
//                             } else {
//                               Provider.of<TrueFalse>(context, listen: false)
//                                   .changeStateBooling(false);
//                               _tools.toastMsg(AppLocalizations.of(context)!.codeField);
//                             }
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               _tools.timerAuth(context),
//                               Container(
//                                   height: 60,
//                                   width: 140,
//                                   decoration: BoxDecoration(
//                                       color: const Color(0xFFFFD54F),
//                                       borderRadius: BorderRadius.circular(8)),
//                                   child:  Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Center(
//                                         child: Text(
//                                           AppLocalizations.of(context)!.verify,
//                                       style: const TextStyle(
//                                           fontSize: 25.0,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     )),
//                                   )),
//                             ],
//                           ))
//                     ],
//                   );
//                 });
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {
//             Provider.of<TrueFalse>(context, listen: false)
//                 .changeStateBooling(false);
//             // _tools.toastMsg(verificationId);
//             _tools.toastMsg(AppLocalizations.of(context)!.tryAgain);
//           });
//     } catch (ex) {
//       Provider.of<TrueFalse>(context, listen: false).changeStateBooling(false);
//       _tools.toastMsg(ex.toString());
//     }
//   }
//
//   //this method for got user id
//   Future<User> getCurrentUserId() async {
//     currentUser = auth.currentUser!;
//     return currentUser;
//   }
//
//   Future<void> signOut(BuildContext context) async {
//     await auth.signOut();
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => AuthScreen()),
//         (route) => false);
//     Provider.of<TrueFalse>(context, listen: false).changeStateBooling(false);
//   }
// }
class AuthSev {
  final Tools _tools = Tools();
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference refuser = FirebaseDatabase.instance.ref().child("users");
  late UserCredential userCredential;
  late User? currentUser;
  late final DataSnapshot snapshot;
  final TextEditingController codeText = TextEditingController();
  //this method for got user id
  Future<User?> createOrLoginWithEmail(
      String pass, BuildContext context, String email) async {
    Provider.of<TrueFalse>(context, listen: false).changeStateBooling(true);
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      await getCurrentUserId();
      if (userCredential.user!.uid.isNotEmpty) {
        currentUser = userCredential.user!;
        snapshot = await refuser.child(currentUser!.uid).get();
        if (snapshot.exists) {
          Map<String, dynamic> map = Map<String, dynamic>.from(snapshot.value as Map);
          Users _infoUser = Users.fromMap(map);
          Provider.of<UserAllInfoDatabase>(context, listen: false)
              .updateUser(_infoUser);
          Provider.of<TrueFalse>(context, listen: false)
              .changeStateBooling(false);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SplashScreen()));
        }
        else if (!snapshot.exists){
          refuser.child(currentUser!.uid).set({
            "userId": currentUser!.uid,
            "imageProfile": "",
            "firstName": "",
            "lastName": "",
            "email": email,
            "pass":pass,
            "phoneNumber": "",
            "country": "",
            "status": "info",
            "update": false
          }).whenComplete(() async {
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
            await Future.delayed(const Duration(milliseconds: 100));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserInfoScreen()));
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      if(e.code=="wrong-password"){
        _tools.toastMsg(AppLocalizations.of(context)!.passWrong);
        Provider.of<TrueFalse>(context, listen: false)
            .changeStateBooling(false);
      }
     else if (e.code == 'user-not-found') {
        try {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email, password: pass);
          await getCurrentUserId();
          currentUser = userCredential.user!;
          if (currentUser!.uid.isNotEmpty) {
            refuser.child(currentUser!.uid).set({
              "userId": currentUser!.uid,
              "imageProfile": "",
              "firstName": "",
              "lastName": "",
              "email": email,
              "pass":pass,
              "phoneNumber": "",
              "country": "",
              "status": "info",
              "update": false
            }).whenComplete(() async {
              Provider.of<TrueFalse>(context, listen: false)
                  .changeStateBooling(false);
              await Future.delayed(const Duration(milliseconds: 100));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoScreen()));
              Provider.of<TrueFalse>(context, listen: false)
                  .changeStateBooling(false);
            });
          }
        } on FirebaseAuthException catch (e) {
          e.toString();
          _tools.toastMsg(AppLocalizations.of(context)!.wrong);
        } catch (e) {
          _tools.toastMsg(AppLocalizations.of(context)!.wrong);
          Provider.of<TrueFalse>(context, listen: false)
              .changeStateBooling(false);
          e.toString();
        }
      }
    }
  }

  Future<User> getCurrentUserId() async {
    currentUser = auth.currentUser!;
    return currentUser!;
  }

  Future<void> deleteAccount(BuildContext context) async {
    User _user = auth.currentUser!;
   final delUser =  refuser.child(_user.uid);
    delUser.onDisconnect();
    await delUser.remove();
    _tools.toastMsg("deleted don");
    _tools.toastMsg("for finishing delete your account exit from app");
    await _user.delete();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(_)=>const AuthScreen()), (route) => false);
  }
}
