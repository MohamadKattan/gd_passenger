// this class for container user cancel his request a taxi

import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/posotoion_cancel_request.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancelTaxi {
  Widget cancelTaxiRequest(
      {required BuildContext context,
      required UserIdProvider userIdProvider,
      required VoidCallback voidCallback}) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: MediaQuery.of(context).size.height * 42 / 100,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  color: Colors.black54,
                  offset: Offset(0.7, 0.7))
            ],
            color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height *
                  3 /
                  100),
              Center(
                  child: Lottie.asset('assets/71796-searching-taxi.json',
                      height: 150, width: 250, fit: BoxFit.contain)),
               Text(
                AppLocalizations.of(context)!.searching ,
                style:const TextStyle(color: Colors.black45),
              ),
              GestureDetector(
                  onTap: () async {
                    Provider.of<PositionCancelReq>(context, listen: false)
                        .updateValue(-400.0);
                    Provider.of<PositionChang>(context, listen: false)
                        .changValue(0.0);
                  await  DataBaseSrv().cancelRiderRequest(userIdProvider, context);
                    voidCallback();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      height: 40.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                color: Colors.black54,
                                offset: Offset(0.7, 0.7))
                          ],
                          color: Colors.redAccent[700]),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
