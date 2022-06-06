// this widget for dialog collect money after finish trip

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/dropBottom_value.dart';
import 'divider_box_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget collectMoney(BuildContext context, int totalAmount) {
  final dropBottomProvider =
      Provider.of<DropBottomValue>(context).valueDropBottom;
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 45 / 100,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Lottie.asset('assets/51765-cash.json',
                    height: 90, width: 90)),
            Text(
              AppLocalizations.of(context)!.amountTrip,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.paymentMethod +
                      "  " +
                      dropBottomProvider,
                  style:
                      const TextStyle(color: Colors.black87, fontSize: 16.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.total + "\$$totalAmount",
                  style:
                      const TextStyle(color: Colors.black87, fontSize: 16.0)),
            ),
            CustomWidget().customDivider(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, "close");
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 30 / 100,
                    height: MediaQuery.of(context).size.height * 8 / 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.greenAccent.shade700),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
