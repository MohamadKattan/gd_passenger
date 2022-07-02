// this dailog for call driver what app or normal call

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../tools/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget callDriver(BuildContext context) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 20 / 100,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0), color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.callDriver,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                await canLaunch("tel:$driverPhone")
                    ? launch("tel:$driverPhone")
                    : Tools().toastMsg(AppLocalizations.of(context)!.wrong);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call, color: Colors.greenAccent.shade700),
                    Text(AppLocalizations.of(context)!.normalCall,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await canLaunch("https://wa.me/$driverPhone")
                    ? launch("https://wa.me/$driverPhone")
                    : Tools().toastMsg(AppLocalizations.of(context)!.wrong);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call, color: Colors.greenAccent.shade700),
                    Text(AppLocalizations.of(context)!.whatsApp,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
