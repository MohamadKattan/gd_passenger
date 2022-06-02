// this widget to show popup if no drive available

import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/position_v_chnge.dart';
import '../my_provider/posotoion_cancel_request.dart';
import 'divider_box_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget sorryNoDriverDialog(BuildContext context, UserIdProvider userProvider) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 45 / 100,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Lottie.asset('assets/85557-empty.json',
                    fit: BoxFit.fill, height: 160, width: 160)),
            Text(
              AppLocalizations.of(context)!.sorry,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
            CustomWidget().customDivider(),
            SizedBox(height: MediaQuery.of(context).size.height * 3.5 / 100),
            GestureDetector(
              onTap: () {
                Provider.of<PositionCancelReq>(context, listen: false)
                    .updateValue(-400.0);
                Provider.of<PositionChang>(context, listen: false)
                    .changValue(0.0);
                DataBaseSrv().cancelRiderRequest(userProvider, context);
                Navigator.pop(context);
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
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
