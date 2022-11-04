// auth screen
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/repo/auth_srv.dart';
import 'package:gd_passenger/user_enter_face/how_use.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config.dart';
import 'forgot_pass.dart';

GlobalKey globalKey = GlobalKey();

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  // static String result = "";
  // static String? resultCodeCon = "+90";
  static AuthSev authSev = AuthSev();
  static final CircularInductorCostem _inductorCostem =
      CircularInductorCostem();

  @override
  Widget build(BuildContext context) {
    bool myTimerProvider = Provider.of<TrueFalse>(context).isTrue;
    MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFF00A3E0),
            key: globalKey,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/splash.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.logInToTaxi,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            overflow: TextOverflow.fade),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.newAccount,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              overflow: TextOverflow.fade),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: Container(
                          height: 55,
                          margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: TextField(
                            controller: email,
                            showCursor: true,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            cursorColor: const Color(0xFFFFD54F),
                            decoration: InputDecoration(
                              fillColor: const Color(0xFFFFD54F),
                              hintText: AppLocalizations.of(context)!.email,
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 55,
                          margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: TextField(
                            controller: password,
                            showCursor: true,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            cursorColor: const Color(0xFFFFD54F),
                            decoration: InputDecoration(
                              fillColor: const Color(0xFFFFD54F),
                              hintText: AppLocalizations.of(context)!.passWord,
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.key,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(''),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ForgotPass())),
                              child: Text(
                                AppLocalizations.of(context)!.forgotPass,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    overflow: TextOverflow.fade),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            if (email.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.fixed,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                  content: Text(AppLocalizations.of(context)!
                                      .emailRequired),
                                ),
                              );
                            } else if (password.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.fixed,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                  content: Text(
                                      AppLocalizations.of(context)!.passWordR),
                                ),
                              );
                            } else if (password.text.length < 8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.fixed,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                  content: Text(AppLocalizations.of(context)!
                                      .passWordShort),
                                ),
                              );
                            } else {
                              ///stop for now
                              // result = "$resultCodeCon${phoneNumber.text}";
                              await authSev.createOrLoginWithEmail(
                                  password.text.trim(),
                                  context,
                                  email.text.trim());
                              FocusScope.of(context).requestFocus(FocusNode());
                              password.clear();
                              email.clear();
                            }
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                                color: const Color(0xFFFBC408),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(0.10, 0.7),
                                      spreadRadius: 0.9)
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                            child: Lottie.asset(
                                'assets/91310-mobile-device-tech.json',
                                height: 150,
                                width: 150)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left: 0.0,
                    top: 0.0,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const HowToUse())),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Image.asset("assets/infoIcon.png",
                                height: 55, width: 55),
                            Text(AppLocalizations.of(context)!.st2,
                                style: const TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )),
                myTimerProvider == true
                    ? Opacity(
                        opacity: 0.9,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: (const BoxDecoration(
                            color: Colors.black,
                          )),
                          child:
                              _inductorCostem.circularInductorCostem(context),
                        ),
                      )
                    : const Text("")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
