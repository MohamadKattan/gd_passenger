
import 'package:flutter/material.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/my_provider/pick_image_provider.dart';
import 'package:gd_passenger/my_provider/true_false.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);
 static late XFile imageFile;
 static final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserIdProvider>(context, listen: false);
    userProvider.getUserIdProvider();
    bool ProviderTrue = Provider.of<TrueFalse>(context).isTrue;
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
                    SizedBox(height: 60),
                    Text("Profile",
                        style: TextStyle(fontSize: 30, color: Colors.black54)),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => getImage(context),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFFFD54F),
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: firstname,
                        maxLength: 15,
                        showCursor: true,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        cursorColor: Color(0xFFFFD54F),
                        decoration: InputDecoration(
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
                        maxLength: 15,
                        showCursor: true,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        cursorColor: Color(0xFFFFD54F),
                        decoration: InputDecoration(
                          fillColor: Color(0xFFFFD54F),
                          label: Text("Last name"),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(height: 60),
                    GestureDetector(
                      onTap: ()=>checkBeforeSet(context,userProvider.getUser.uid,userProvider.getUser.phoneNumber.toString(),imageFile),
                      child: Container(
                        child: Center(
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
                            color: Color(0xFFFFD54F),
                            borderRadius: BorderRadius.circular(4.0),
                            boxShadow: [
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
              ProviderTrue?Opacity(
                opacity: 0.9,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFFFFD54F),),
                      SizedBox(height: 15,),
                      Text("Wait ...",style: TextStyle(color: Colors.white,fontSize: 20),)
                    ],
                  ),
                  decoration: (BoxDecoration(
                    color: Colors.black,
                  )),
                ),
              ):Text("")
            ],
          ),
        ),
      ),
    );
  }
  Future<void> getImage(BuildContext context) async {
    try {
      final XFile? _file = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 40.0,
          maxHeight: 40.0,
          imageQuality: 50);
      imageFile = _file!;
      Provider.of<PickImageProvide>(context, listen: false)
          .listingToPickImage(imageFile);
    } catch (e) {}
  }

  checkBeforeSet(BuildContext context, String uid, String phoneNumber, XFile imageFile) {
    if(firstname.text.isEmpty){
      tools.toastMsg("First name is squared");
    }
    else if(lastname.text.isEmpty){
      tools.toastMsg("Last name is squared");
    }else{
      Provider.of<TrueFalse>(context, listen: false)
          .changeStateBooling(true);
      srv.setImageToStorage(firstname,lastname,uid,context,phoneNumber,imageFile);
    }
  }
}
