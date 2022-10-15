import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tools/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
Widget callDriverOnMap(BuildContext context,String driverPhoneOnMap) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), color: const Color(0xFF00A3E0)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  AppLocalizations.of(context)!.callDriver,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.close,color: Colors.red))
              ],
            ),
            GestureDetector(
              onTap: () async {
                await canLaunch("tel:$driverPhoneOnMap")
                    ? launch("tel:$driverPhoneOnMap")
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
                    const SizedBox(width: 8.0),
                    Text(AppLocalizations.of(context)!.normalCall,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await canLaunch("https://wa.me/$driverPhoneOnMap")
                    ? launch("https://wa.me/$driverPhoneOnMap")
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
                    const SizedBox(width: 8.0),
                    Text(AppLocalizations.of(context)!.whatsApp,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
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