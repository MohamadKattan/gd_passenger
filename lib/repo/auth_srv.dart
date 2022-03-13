
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/tools/tools.dart';
import 'package:gd_passenger/user_enter_face/auth_screen.dart';
import 'package:gd_passenger/user_enter_face/user_info_screen.dart';
import 'package:provider/provider.dart';

// this class for Auth by firebase-phone method
class AuthSev {
  final Tools _tools = Tools();
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  late User currentUser;
  final TextEditingController code = TextEditingController();
// this method for register by phone number
  Future<void> signUpWithPhone(String result, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: result,
          timeout: const Duration(seconds: 120),
          verificationCompleted: (PhoneAuthCredential credential) async {
            Navigator.pop(context);
            userCredential = await auth.signInWithCredential(credential);
            await getCurrentUserId();
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
            if (userCredential.user != null) {
              Provider.of<TrueFalse>(context, listen: false)
                  .changeStateBooling(false);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserInfoScreen()));
            } else {
              _tools.toastMsg("Some Thing went wrong");
              _tools.toastMsg("check you net work or phone Number");
              Provider.of<TrueFalse>(context, listen: false)
                  .changeStateBooling(false);
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
            _tools.toastMsg("Error${e.toString()}");
          },
          codeSent: (String verificationId, int? resendToken) {
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 80 / 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("type a code"),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextField(
                                controller: code,
                                maxLength: 15,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration: const InputDecoration(
                                  icon: Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Icon(
                                      Icons.vpn_key,
                                      color: Color(0xFFFFD54F),
                                    ),
                                  ),
                                  fillColor: Color(0xFFFFD54F),
                                  hintText: "Your Code",
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      GestureDetector(
                          onTap: () async {
                            if (code.text.isNotEmpty) {
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code.text.trim());
                              userCredential =
                                  await auth.signInWithCredential(credential);
                              await getCurrentUserId();
                              if (userCredential.user != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserInfoScreen()));
                              } else {
                                Provider.of<TrueFalse>(context, listen: false)
                                    .changeStateBooling(false);
                                _tools.toastMsg("Some thing went wrong");
                                Navigator.pop(context);
                              }
                            } else {
                              Provider.of<TrueFalse>(context, listen: false)
                                  .changeStateBooling(false);
                              _tools.toastMsg("Code field can't be empty");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _tools.timerAuth(context),
                              Container(
                                  height: 60,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFFD54F),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      "verify",
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  )),
                            ],
                          ))
                    ],
                  );
                });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            Provider.of<TrueFalse>(context, listen: false)
                .changeStateBooling(false);
           // _tools.toastMsg(verificationId);
            _tools.toastMsg("try again");
          });
    } catch (ex) {
      Provider.of<TrueFalse>(context, listen: false).changeStateBooling(false);
      _tools.toastMsg(ex.toString());
    }
  }

  //this method for got user id
  Future<User> getCurrentUserId()async{
      currentUser = auth.currentUser!;
      print("::::${currentUser.uid}");
      return currentUser;
  }

  Future<void> signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
        (route) => false);
    Provider.of<TrueFalse>(context, listen: false)
        .changeStateBooling(false);
       print("SignOut don");
  }
}
