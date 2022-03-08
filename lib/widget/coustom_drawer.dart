
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/my_provider/buttom_color_pro.dart';
import 'package:gd_passenger/my_provider/double_value.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:gd_passenger/user_enter_face/language_screen.dart';
import 'package:gd_passenger/user_enter_face/profile_screen.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget customDrawer(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Provider.of<DoubleValue>(context, listen: false).value0Or1(0);
      Provider.of<ChangeColor>(context, listen: false).updateState(false);
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFFFFD54F),
          Color(0xFFFFD55F),
          Color(0xFFFFD56F),
          Color(0xFFFFD57F),
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 20 / 100,
            child: DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    showImage(context),
                    SizedBox(
                      height: 8.0,
                    ),
                    showUserName(context),
                    showUserPhone(context),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 4.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child:
                    GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen())),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.car_rental_sharp, color: Colors.black45,size: 30,),
                    ),
                    SizedBox(width: 8.0),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: const Text(
                          "My Bookings",
                          style: TextStyle(color: Colors.black45,fontSize: 16.0),
                        ))
                  ]),
                )),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileScreen())),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.person, color: Colors.black45,size: 30),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Text(
                          "My profile",
                          style: TextStyle(color: Colors.black45,fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GestureDetector(
                    onTap: () => null,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.mail, color: Colors.black45,size: 30,),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        const Text(
                          "Call us",
                          style: TextStyle(color: Colors.black45,fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LanguageScreen())),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.language, color: Colors.black45,size: 30,),
                      ),
                      SizedBox(width: 8.0),
                      const Text(
                        "Language",
                        style: TextStyle(color: Colors.black45,fontSize: 16.0),
                      ),
                    ],
                  ),
                )),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GestureDetector(
                    onTap: () => SystemNavigator.pop(),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.exit_to_app, color: Colors.black45,size: 30.0,),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text("Exit",style: TextStyle(color: Colors.black45,fontSize: 16.0),),
                      ],
                    ),
                  ),
                ),
              ),
              CustomWidget().customDivider(),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget showImage(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime?.image_profile != null
      ? Expanded(
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            imageUrl: "${userInfoRealTime?.image_profile}",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.person),
          ),
        )
      : Expanded(
          flex: 0,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black12,
              size: 35,
            ),
          ),
        );
}

Widget showUserName(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime?.first_name != null
      ? Text("Hi ${userInfoRealTime?.first_name}")
      : Expanded(child: Text("Welcome back"));
}

Widget showUserPhone(BuildContext context) {
  final userInfoRealTime =
      Provider.of<UserAllInfoDatabase>(context, listen: false).users;
  return userInfoRealTime?.phone_number != null
      ? Text("${userInfoRealTime?.phone_number}")
      : Text("");
}
