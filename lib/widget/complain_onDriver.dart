// this widget if rider want to complained on driver

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tools/tools.dart';

Widget complainOnDriver(BuildContext context){
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 20 / 100,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius:BorderRadius.circular(4.0),color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            const Text(
              "If you have any Issue",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async{
                // if (!await launch(url)) throw 'Could not launch $url';
                await canLaunch("https://wa.me/+905384643348")
                    ? launch("https://wa.me/+905384643348")
                    : Tools().toastMsg('Support not available now try again');
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 20 / 100,
                  height: MediaQuery.of(context).size.height * 5 / 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.greenAccent.shade700),
                  child: const Center(
                      child: Text(
                        "Call as",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}