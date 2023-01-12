// this class for container user cancel his request a taxi
import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/posotoion_cancel_request.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../my_provider/true_false.dart';

class CancelTaxi {
  Widget cancelTaxiRequest(
      {required BuildContext context,
      required UserIdProvider userIdProvider,
      required VoidCallback voidCallback}) {
    return Consumer<TrueFalse>(
      builder: (BuildContext context, value, Widget? child) {
        return value.showRiderCancelRequest
            ? Container(
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    color: Colors.white),
                child: Column(
                  children: [
                    Center(
                        child: Lottie.asset('assets/71796-searching-taxi.json',
                            height: 150, width: 150, fit: BoxFit.cover)),
                    Text(
                      AppLocalizations.of(context)!.searching,
                      style: const TextStyle(color: Colors.black45),
                    ),
                    GestureDetector(
                        onTap: () async {
                          Provider.of<PositionCancelReq>(context, listen: false)
                              .updateValue(-400.0);
                          Provider.of<PositionChang>(context, listen: false)
                              .changValue(0.0);
                          await DataBaseSrv()
                              .cancelRiderRequest(userIdProvider, context);
                          voidCallback();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 40.0, right: 40.0, top: 12, bottom: 12.0),
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.redAccent.shade700),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}
