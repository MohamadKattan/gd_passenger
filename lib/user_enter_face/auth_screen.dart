// auth screen
import 'package:country_list_pick/country_list_pick.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/repo/auth_srv.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config.dart';

GlobalKey globalKey = GlobalKey();

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static String result = "";
  static String? resultCodeCon = "+90";
  static AuthSev authSev = AuthSev();
  static final CircularInductorCostem _inductorCostem = CircularInductorCostem();

  @override
  Widget build(BuildContext context) {
    bool myTimerProvider = Provider.of<TrueFalse>(context).isTrue;
    MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async=>false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Scaffold(
            key: globalKey,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                       Text(
                        AppLocalizations.of(context)!.logInToTaxi,
                        style:const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            overflow: TextOverflow.fade),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                       Text(
                        AppLocalizations.of(context)!.newAccount,
                        textAlign: TextAlign.center,
                        style:const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black26,
                            overflow: TextOverflow.fade),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                       Text(
                         AppLocalizations.of(context)!.enterNumber ,
                         textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            overflow: TextOverflow.fade),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CountryListPick(
                                  appBar: AppBar(
                                    backgroundColor: Colors.amber[200],
                                    title:  Text(AppLocalizations.of(context)!.pickCountry),
                                  ),
                                  theme: CountryTheme(
                                    isShowFlag: true,
                                    isShowTitle: false,
                                    isShowCode: true,
                                    isDownIcon: true,
                                    showEnglishName: false,
                                    labelColor: Colors.black54,
                                    alphabetSelectedBackgroundColor:
                                        const Color(0xFFFFD54F),
                                    alphabetTextColor: Colors.deepOrange,
                                    alphabetSelectedTextColor: Colors.deepPurple,
                                  ),
                                  initialSelection: resultCodeCon,
                                  onChanged: (CountryCode? code) {
                                    resultCodeCon = code?.dialCode;
                                  },
                                  useUiOverlay: true,
                                  useSafeArea: false),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: phoneNumber,
                                maxLength: 15,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration:  InputDecoration(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: Color(0xFFFFD54F),
                                    ),
                                  ),
                                  fillColor:const Color(0xFFFFD54F),
                                  label: Text(AppLocalizations.of(context)!.number),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: email,
                          maxLength: 40,
                          showCursor: true,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          cursorColor: const Color(0xFFFFD54F),
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFFFD54F),
                            label: Text(AppLocalizations.of(context)!.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(AppLocalizations.of(context)!.verificationCode),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: GestureDetector(
                          onTap: () async {
                            if (phoneNumber.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                  behavior: SnackBarBehavior.fixed,
                                  backgroundColor: Colors.red,
                                  duration:const Duration(seconds: 3),
                                  content: Text(AppLocalizations.of(context)!.numberEmpty),
                                ),
                              );
                            }
                           else if (email.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.fixed,
                                  backgroundColor: Colors.red,
                                  duration:const Duration(seconds: 3),
                                  content: Text(AppLocalizations.of(context)!.emailRequired),
                                ),
                              );
                            }
                            else {
                              result = "$resultCodeCon${phoneNumber.text}";
                              await authSev.createOrLoginWithEmail(result, context,email.text.trim());
                              FocusScope.of(context).requestFocus(FocusNode());

                            }
                          },
                          child: Container(
                            child:  Center(
                                child: Text(
                                  AppLocalizations.of(context)!.signUp,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                            width: 180,
                            height: 60,
                            decoration: BoxDecoration(
                                color: const Color(0xFFFFD54F),
                                borderRadius: BorderRadius.circular(4.0),
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
                myTimerProvider==true
                    ? Opacity(
                        opacity: 0.9,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: (const BoxDecoration(
                            color: Colors.black,
                          )),
                          child: _inductorCostem.circularInductorCostem(context),
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
