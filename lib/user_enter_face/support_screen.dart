import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../tools/tools.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A3E0),
        title: Text(
          AppLocalizations.of(context)!.support,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Text(AppLocalizations.of(context)!.supportInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {
              String _url = 'mailto:vba@garantitaxi.com';
              await Tools().lunchUrl(context, _url);
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  border:
                      Border.all(width: 2.0, color: const Color(0xFF00A3E0))),
              child: Row(
                children: const [
                  Icon(Icons.mail, size: 35, color: Color(0xFF00A3E0)),
                  SizedBox(width: 18.0),
                  Text(
                    "vba@garantitaxi.com",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A3E0)),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              String _url = "https://wa.me/+905057743644";
              await Tools().lunchUrl(context, _url);
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  border:
                      Border.all(width: 2.0, color: const Color(0xFF00A3E0))),
              child: Row(
                children: const [
                  Icon(Icons.phone, size: 35, color: Color(0xFF00A3E0)),
                  SizedBox(width: 18.0),
                  Text(
                    "+905057743644",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A3E0)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
