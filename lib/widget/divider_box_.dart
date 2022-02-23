//custom widget class use in home scrren

import 'package:flutter/material.dart';

class CustomWidget {
  // divider
  Widget customDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.black12, boxShadow: [
        BoxShadow(
            blurRadius: 6.0,
            spreadRadius: 0.5,
            color: Colors.black54,
            offset: Offset(0.7, 0.7))
      ]),
    );
  }

// Home and work box in home screen
  Widget containerBox(Icon icon, String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 6.0,
              spreadRadius: 0.5,
              color: Colors.black54,
              offset: Offset(0.7, 0.7))
        ]),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Icon(
                  icon.icon,
                  color: Color(0xFFFFD54F),
                  size: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 25, color: Colors.black54),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // car type box taxi/van/veto
  Widget carTypeBox(
      Image image, String text, String text2, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 15 / 100,
      width: MediaQuery.of(context).size.height * 20 / 100,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Center(
            child: image,
          ),
          Center(
              child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          )),
          Center(
              child: Text(
                text2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
      ),
    );
  }
}
