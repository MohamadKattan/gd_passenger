import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/model/user.dart';
import 'package:gd_passenger/my_provider/indector_profile_screen.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/user_enter_face/splash_screen.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../my_provider/profile_sheet.dart';
import '../repo/auth_srv.dart';
import '../tools/tools.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static final TextEditingController name = TextEditingController();
  static final TextEditingController lastName = TextEditingController();
  static final TextEditingController email = TextEditingController();
  static final ImagePicker _picker = ImagePicker();
  // static late XFile? imageFile;
  static File? _imageFile;
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserAllInfoDatabase>(context).users;
    bool isTrue = Provider.of<InductorProfileScreen>(context).isTrue;
    // final imageProvider = Provider.of<PickImageProvide>(context).imageProvider;
    final sheetVal = Provider.of<ProfileSheet>(context).valSheet;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile,
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF00A3E0),
      ),
      body: Builder(
        builder: (_) => SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      GestureDetector(
                          onTap: () =>
                              Provider.of<ProfileSheet>(context, listen: false)
                                  .updateState(0),
                          child: showImage(context)),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 10 / 100),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                                width: 2.0, color: const Color(0xFF00A3E0))),
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16.0),
                          controller: name,
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.edit, size: 30.0),
                            hintText: userInfo.firstName,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                                width: 2.0, color: const Color(0xFF00A3E0))),
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16.0),
                          controller: lastName,
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.edit, size: 30.0),
                            hintText: userInfo.lastName,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                                width: 2.0, color: const Color(0xFF00A3E0))),
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16.0),
                          controller: email,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.edit, size: 30.0),
                            hintText: userInfo.email,
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () {
                                if (_imageFile == null) {
                                  Tools().toastMsg(
                                      AppLocalizations.of(context)!.upImage);
                                } else {
                                  Provider.of<InductorProfileScreen>(context,
                                          listen: false)
                                      .updateState(true);
                                  startUpdateInfoUser(userInfo, name, lastName,
                                      email, context, _imageFile!);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A3E0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                height: 60,
                                width: 140,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.update,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () {
                                fakeDelete(userInfo, context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.shade700,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                height: 60,
                                width: 140,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.del,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  right: 0.0,
                  left: 0.0,
                  bottom: sheetVal,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0)),
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
                                  const Icon(Icons.camera,
                                      color: Color(0xFFFFD54F)),
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
                                  const Icon(Icons.image,
                                      color: Color(0xFFFFD54F)),
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
              isTrue == true
                  ? CircularInductorCostem().circularInductorCostem(context)
                  : const Text(""),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getImage(BuildContext context, ImageSource source) async {
    try {
      final _file = await _picker.pickImage(
          source: source, maxWidth: 60.0, maxHeight: 60.0, imageQuality: 80);
      if (_file == null) return;
      _imageFile = File(_file.path);
      // Provider.of<PickImageProvide>(context, listen: false)
      //     .listingToPickImage(imageFile);
      Provider.of<ProfileSheet>(context, listen: false).updateState(-400);
    } catch (e) {
      Tools().toastMsg(AppLocalizations.of(context)!.imageRequired);
    }
  }

  Widget showImage(BuildContext context) {
    final userInfoRealTime =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    return userInfoRealTime.imageProfile != ""
        ? Stack(
            children: [
              CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                imageUrl: userInfoRealTime.imageProfile,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
              const Positioned(
                  left: 60.0,
                  right: 0.0,
                  bottom: 85.0,
                  top: 85.0,
                  child: Icon(Icons.add_a_photo_outlined,
                      size: 35, color: Colors.white)),
            ],
          )
        : const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black12,
              size: 35,
            ),
          );
  }

  Future<void> startUpdateInfoUser(
      Users userInfo,
      TextEditingController name,
      TextEditingController lastName,
      TextEditingController email,
      BuildContext context,
      File imageFile) async {
    firebase_storage.Reference refStorage =
        firebase_storage.FirebaseStorage.instance.ref();
    await refStorage
        .child("users")
        .child(userInfo.userId)
        .putFile(File(imageFile.path));

    String url =
        await refStorage.child("users").child(userInfo.userId).getDownloadURL();

    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("users").child(userInfo.userId);
    await ref.update({
      "imageProfile": url.isEmpty ? userInfo.imageProfile : url.toString(),
      "firstName": name.text.isEmpty ? userInfo.firstName : name.text,
      "lastName": lastName.text.isEmpty ? userInfo.lastName : lastName.text,
      "email": email.text.isEmpty ? userInfo.email : email.text.trim(),
    }).whenComplete(() {
      Provider.of<InductorProfileScreen>(context, listen: false)
          .updateState(false);
    });
  }

  Future<void> fakeDelete(Users userInfo, BuildContext context) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("users").child(userInfo.userId);
    await ref.update({
      "status": "info",
    }).whenComplete(() {
      Provider.of<InductorProfileScreen>(context, listen: false)
          .updateState(false);
      AuthSev().singOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false);
    });
  }
}
