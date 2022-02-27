import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gd_passenger/user_enter_face/language_screen.dart';
import 'package:gd_passenger/user_enter_face/profile_screen.dart';

Widget customDrawer(BuildContext context) {
  return SingleChildScrollView(
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 30 / 100,
            child: DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.black12,
                        size: 35,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "User",
                      style: TextStyle(color: Colors.black45, fontSize: 25),
                    ),
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
              ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen())),
                leading:
                    const Icon(Icons.car_rental_sharp, color: Colors.black45),
                title: const Text(
                  "My Bookings",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen())),
                leading: const Icon(Icons.person, color: Colors.black45),
                title: const Text(
                  "My profile",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListTile(
                onTap: () => const Text(""),
                leading: const Icon(Icons.mail, color: Colors.black45),
                title: const Text(
                  "Call us",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LanguageScreen())),
                leading: const Icon(Icons.language, color: Colors.black45),
                title: const Text(
                  "Language",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              ListTile(
                onTap: () {
                  SystemNavigator.pop();
                },
                leading: const Icon(Icons.exit_to_app, color: Colors.black45),
                title: const Text(
                  "Exit",
                  style: TextStyle(color: Colors.black45),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
