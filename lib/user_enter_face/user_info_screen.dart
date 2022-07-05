// add name photo after auth
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/my_provider/pick_image_provider.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../my_provider/userinfo_sheet_provider.dart';
import '../repo/api_srv_geo.dart';

class UserInfoScreen extends StatefulWidget {

  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  XFile imageFile =XFile("");
   final ImagePicker _picker = ImagePicker();
   final CircularInductorCostem _inductorCostem =
  CircularInductorCostem();
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    final picked = Provider.of<PickImageProvide>(context).imageProvider;
    bool providerTrue = Provider.of<TrueFalse>(context).isTrue;
    final valSheet = Provider.of<UserInfoSheet>(context).valSheet;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Builder(
          builder:(_)=> SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Text(AppLocalizations.of(context)!.profile,
                            style: const TextStyle(
                                fontSize: 30, color: Colors.black54)),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: ()=>
                            Provider.of<UserInfoSheet>(context,listen: false).updateState(0),
                          child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xFFFFD54F)),
                              child: picked == null
                                  ? const Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 25,
                                      color: Colors.white,
                                    )
                                  : Image(
                                      image: FileImage(File(imageFile.path)),
                                      fit: BoxFit.fill,
                                    )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: firstname,
                            maxLength: 20,
                            showCursor: true,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            cursorColor: const Color(0xFFFFD54F),
                            decoration: InputDecoration(
                              fillColor: const Color(0xFFFFD54F),
                              label:
                                  Text(AppLocalizations.of(context)!.firstName),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: lastname,
                            maxLength: 20,
                            showCursor: true,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            cursorColor: const Color(0xFFFFD54F),
                            decoration: InputDecoration(
                              fillColor: const Color(0xFFFFD54F),
                              label: Text(AppLocalizations.of(context)!.lastName),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        const SizedBox(height: 60),
                        GestureDetector(
                          onTap: () {
                            if (picked == null) {
                              tools.toastMsg(
                                  AppLocalizations.of(context)!.imageRequired);
                            }
                            else {
                              checkBeforeSet(
                                  context,
                                  userProvider.getUser.uid,
                                  phoneNumber.text.trim(),
                                 imageFile);
                            }
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.save,
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
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    right: 0.0,
                    left: 0.0,
                    bottom: valSheet,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      height: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.pickPhoto,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              getImage(context, ImageSource.camera);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.60,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 6.0,
                                          spreadRadius: 0.5,
                                          color: Colors.black54,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.camera, color: Color(0xFFFFD54F)),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(AppLocalizations.of(context)!.camera),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getImage(context, ImageSource.gallery);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.60,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 6.0,
                                          spreadRadius: 0.5,
                                          color: Colors.black54,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.image, color: Color(0xFFFFD54F)),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(AppLocalizations.of(context)!.gallery),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                providerTrue
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
                    : const Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? _file = await _picker.pickImage(
          source: source, maxWidth: 150.0, maxHeight: 150.0, imageQuality: 80);
      setState(() {
        imageFile = _file!;
      });
      Provider.of<PickImageProvide>(context, listen: false)
          .listingToPickImage(imageFile);
      Provider.of<UserInfoSheet>(context,listen: false).updateState(-400);
    } catch (e) {
      print("image ${e.toString()}");
      tools.toastMsg(AppLocalizations.of(context)!.imageRequired);
      tools.toastMsg(e.toString());
    }
  }

  checkBeforeSet(
      BuildContext context, String uid, String phoneNumber, XFile? imageFile) {
    if (firstname.text.isEmpty) {
      tools.toastMsg(AppLocalizations.of(context)!.nameRequired);
    } else if (lastname.text.isEmpty) {
      tools.toastMsg(AppLocalizations.of(context)!.lastRequired);
    } else {
     ApiSrvGeo().getContry();
      Provider.of<TrueFalse>(context, listen: false).changeStateBooling(true);
      srv.setImageToStorage(
          firstname, lastname, uid, context, phoneNumber, imageFile!, email);
    }
  }

  // void showSheetCamerOrGallary({required BuildContext context}) async {
  //   await showSlidingBottomSheet(context, builder: (context) {
  //     return SlidingSheetDialog(
  //       elevation: 8,
  //       cornerRadius: 16,
  //       snapSpec: const SnapSpec(
  //         snap: true,
  //         initialSnap: 0.400,
  //         snappings: [0.4, 0.7, 0.400],
  //         positioning: SnapPositioning.relativeToAvailableSpace,
  //       ),
  //       builder: (context, state) {
  //         return
  //           SizedBox(
  //           height: 400,
  //           child: Material(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Center(
  //                     child: Text(
  //                       AppLocalizations.of(context)!.pickPhoto,
  //                       style: const TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black54),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     getImage(context, ImageSource.camera);
  //                   },
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Container(
  //                       height: 60,
  //                       width: MediaQuery.of(context).size.width * 0.60,
  //                       decoration: const BoxDecoration(
  //                           color: Colors.white,
  //                           boxShadow: [
  //                             BoxShadow(
  //                                 blurRadius: 6.0,
  //                                 spreadRadius: 0.5,
  //                                 color: Colors.black54,
  //                                 offset: Offset(0.7, 0.7))
  //                           ]),
  //                       child: Center(
  //                           child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           const Icon(Icons.camera, color: Color(0xFFFFD54F)),
  //                           const SizedBox(
  //                             width: 5.0,
  //                           ),
  //                           Text(AppLocalizations.of(context)!.camera),
  //                         ],
  //                       )),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     getImage(context, ImageSource.gallery);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Container(
  //                       height: 60,
  //                       width: MediaQuery.of(context).size.width * 0.60,
  //                       decoration: const BoxDecoration(
  //                           color: Colors.white,
  //                           boxShadow: [
  //                             BoxShadow(
  //                                 blurRadius: 6.0,
  //                                 spreadRadius: 0.5,
  //                                 color: Colors.black54,
  //                                 offset: Offset(0.7, 0.7))
  //                           ]),
  //                       child: Center(
  //                           child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           const Icon(Icons.image, color: Color(0xFFFFD54F)),
  //                           const SizedBox(
  //                             width: 5.0,
  //                           ),
  //                           Text(AppLocalizations.of(context)!.gallery),
  //                         ],
  //                       )),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }
}
