// this class for trabzon list

import 'package:flutter/material.dart';
import 'package:gd_passenger/google_map_methods.dart';
import '../config.dart';
import 'divider_box_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget trabzonVeto(BuildContext context) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 60 / 100,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0), color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xFF00A3E0),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14.0),
                      topLeft: Radius.circular(14.0))),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.torzimTrip,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.pricesList,
                    style: const TextStyle(
                      color: Color(0xFF00A3E0),
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    )),
              ],
            ),
            CustomWidget().customDivider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  tourismCityName = "Trabzon";
                  tourismCityPrice = "100";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
                },
                child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.0, color: const Color(0xFFFBC408)),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!.trapzonMain,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A3E0),
                                fontSize: 16.0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "\$100",
                              style: TextStyle(
                                  color: Color(0xFF00A3E0), fontSize: 20.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  tourismCityName = "Uzun gol";
                  tourismCityPrice = "130";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
                },
                child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          width: 2.0, color: const Color(0xFFFBC408)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!.trapzonUzu,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A3E0),
                                fontSize: 16.0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "\$130",
                              style: TextStyle(
                                  color: Color(0xFF00A3E0), fontSize: 20.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  tourismCityName = "Ayder";
                  tourismCityPrice = "170";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
                },
                child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          width: 2.0, color: const Color(0xFFFBC408)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!.trapzonAyd,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A3E0),
                                fontSize: 16.0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "\$170",
                              style: TextStyle(
                                  color: Color(0xFF00A3E0), fontSize: 20.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  tourismCityName = "Rize";
                  tourismCityPrice = "160";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
                },
                child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          width: 2.0, color: const Color(0xFFFBC408)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!.trapzonRiz,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A3E0),
                                fontSize: 16.0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "\$160",
                              style: TextStyle(
                                  color: Color(0xFF00A3E0), fontSize: 20.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  tourismCityName = "Giresun";
                  tourismCityPrice = "160";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
                },
                child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          width: 2.0, color: const Color(0xFFFBC408)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!.trapzonGir,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A3E0),
                                fontSize: 16.0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "\$160",
                            style: TextStyle(
                                color: Color(0xFF00A3E0), fontSize: 20.0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  tourismCityName = "ondu";
                  tourismCityPrice = "200";
                  LogicGoogleMap().tourismCities(tourismCityName, context);
                },
                child: Container(
                    width: double.infinity,
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          width: 2.0, color: const Color(0xFFFBC408)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!.trapzonOndu,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00A3E0),
                                fontSize: 16.0),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "\$200",
                              style: TextStyle(
                                color: Color(0xFF00A3E0),
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
