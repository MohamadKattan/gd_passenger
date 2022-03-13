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
import 'package:sliding_sheet/sliding_sheet.dart';

class UserInfoScreen extends StatelessWidget {
  static late XFile? imageFile;
  static final ImagePicker _picker = ImagePicker();
  static final CircularInductorCostem _inductorCostem = CircularInductorCostem();

  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    final picked = Provider.of<PickImageProvide>(context).ImageProvider;
    bool providerTrue = Provider.of<TrueFalse>(context).isTrue;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const Text("Profile",
                        style: TextStyle(fontSize: 30, color: Colors.black54)),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => showSheetCamerOrGallary(context: context),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xFFFFD54F)),
                        child:
                          picked==null?const Icon(
                            Icons.add_a_photo_outlined,
                            size: 25,
                            color: Colors.white,
                          ):Image(image: FileImage(File(picked.path)),fit: BoxFit.fill,)
                      ),
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
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFFFD54F),
                          label: Text("First name"),
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
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFFFD54F),
                          label: Text("Last name"),
                        ),
                        keyboardType: TextInputType.name,
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
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFFFD54F),
                          label: Text("Email"),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 60),
                    GestureDetector(
                      onTap: () {
                        if (picked == null) {
                          tools.toastMsg("image profile is required");
                        } else {
                          checkBeforeSet(
                              context,
                              userProvider.getUser.uid,
                              userProvider.getUser.phoneNumber.toString(),
                              imageFile!);
                        }
                      },
                      child: Container(
                        child: const Center(
                            child: Text(
                          "Save",
                          style: TextStyle(
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
              providerTrue
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
    );
  }

  Future<void> getImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? _file = await _picker.pickImage(
          source: source, maxWidth: 40.0, maxHeight: 40.0, imageQuality: 30);
      imageFile = _file!;
      Provider.of<PickImageProvide>(context, listen: false)
          .listingToPickImage(imageFile!);
    } catch (e) {
      tools.toastMsg("image profile is required");
      tools.toastMsg(e.toString());
    }
  }

  checkBeforeSet(
      BuildContext context, String uid, String phoneNumber, XFile? imageFile) {

    if (firstname.text.isEmpty) {
      tools.toastMsg("First name is required");
    }
   else if (lastname.text.isEmpty) {
      tools.toastMsg("Last name is required");
    }
  else  if (email.text.isEmpty) {
      tools.toastMsg("Email is required");
    }
    else if (!email.text.contains("@") && !email.text.endsWith(".com")) {
       tools.toastMsg("check your email address some thing wrong");
     }
    else {
      Provider.of<TrueFalse>(context, listen: false).changeStateBooling(true);
      srv.setImageToStorage(
          firstname, lastname, uid, context, phoneNumber, imageFile!, email);
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
}
