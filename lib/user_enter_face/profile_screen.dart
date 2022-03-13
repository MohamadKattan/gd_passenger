import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/model/user.dart';
import 'package:gd_passenger/my_provider/indector_profile_screen.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/widget/custom_circuler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import '../my_provider/pick_image_provider.dart';
import '../tools/tools.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static final TextEditingController name = TextEditingController();
  static final TextEditingController lastName = TextEditingController();
  static final TextEditingController email = TextEditingController();
  static final ImagePicker _picker = ImagePicker();
  static late XFile imageFile;
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserAllInfoDatabase>(context).users;
    bool isTrue =  Provider.of<InductorProfileScreen>(context).isTrue;
   final imageProvider= Provider.of<PickImageProvide>(context).ImageProvider;
    return SafeArea(
      child: Scaffold(
        body:
        Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  GestureDetector(
                      onTap: () => showSheetCamerOrGallary(context: context),
                      child: showImage(context)),
                  SizedBox(height: MediaQuery.of(context).size.height * 15 / 100),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 16.0),
                      controller: name,
                      maxLength: 40,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.edit, size: 30.0),
                        hintText: "${userInfo?.firstName}",
                        hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 16.0),
                      controller: lastName,
                      maxLength: 40,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.edit, size: 30.0),
                        hintText: "${userInfo?.lastName}",
                        hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 16.0),
                      controller: email,
                      maxLength: 40,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.edit, size: 30.0),
                        hintText: "${userInfo?.email}",
                        hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: (){
                        if(imageProvider==null){
                          Tools().toastMsg("Up date your image first");
                        }else{
                          Provider.of<InductorProfileScreen>(context,listen: false).updateState(true);
                          startUpdateInfoUser(
                              userInfo!, name, lastName, email, imageFile,context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD54F),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        height: MediaQuery.of(context).size.height * 10 / 100,
                        width: MediaQuery.of(context).size.width * 80 / 100,
                        child: const Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.black,
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
            ),
           isTrue==true?CircularInductorCostem().circularInductorCostem(context):const Text(""),
          ],
        ),
      ),
    );
  }

  Future<void> getImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? _file = await _picker.pickImage(
          source: source, maxWidth: 40.0, maxHeight: 40.0, imageQuality: 30);
      imageFile = _file!;
      Provider.of<PickImageProvide>(context,listen: false).listingToPickImage(imageFile);
    } catch (e) {
      Tools().toastMsg("image profile is required");
      Tools().toastMsg(e.toString());
    }
  }

  void showSheetCamerOrGallary({required BuildContext context}) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snap: true,
          initialSnap: 0.400,
          snappings: [0.4, 0.7, 0.400],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Container(
            height: 400,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Pick a photo",
                        style: TextStyle(
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
                        decoration:
                            const BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              color: Colors.black54,
                              offset: Offset(0.7, 0.7))
                        ]),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera, color: Color(0xFFFFD54F)),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text("Camera"),
                          ],
                        )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage(context, ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.60,
                        decoration:
                            const BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              color: Colors.black54,
                              offset: Offset(0.7, 0.7))
                        ]),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image, color: Color(0xFFFFD54F)),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text("gallery"),
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget showImage(BuildContext context) {
    final userInfoRealTime =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    return userInfoRealTime?.imageProfile != null
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
                imageUrl: "${userInfoRealTime?.imageProfile}",
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
              const Positioned(
                  left: 60.0,
                  right: 0.0,
                  bottom: 85.0,
                  top: 85.0,
                  child: Icon(Icons.add_a_photo_outlined,
                      size: 35, color: Colors.redAccent)),
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
      XFile imageFile,
      BuildContext context
      ) async {

    firebase_storage.Reference refStorage = firebase_storage.FirebaseStorage.instance.ref();
    await refStorage
        .child("users")
        .child(userInfo.userId)
        .putFile(File(imageFile.path));

       String url = await refStorage.child("users").child(userInfo.userId).getDownloadURL();


    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("users").child(userInfo.userId);
    await ref.update({
      "imageProfile": url.isEmpty?userInfo.imageProfile:url.toString(),
      "firstName": name.text.isEmpty?userInfo.firstName:name.text,
      "lastName": lastName.text.isEmpty?userInfo.lastName:lastName.text,
      "email": email.text.isEmpty?userInfo.email:email.text.trim(),
    }).whenComplete((){
      Provider.of<InductorProfileScreen>(context,listen: false).updateState(false);
    });
  }
}
