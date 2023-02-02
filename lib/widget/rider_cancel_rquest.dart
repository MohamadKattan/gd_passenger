// this class for container user cancel his request a taxi
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/position_v_chnge.dart';
import 'package:gd_passenger/my_provider/posotoion_cancel_request.dart';
import 'package:gd_passenger/my_provider/user_id_provider.dart';
import 'package:gd_passenger/repo/data_base_srv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../my_provider/true_false.dart';
import '../tools/tools.dart';

class CancelTaxi {
  var imageList = <String>[
    'assets/71796-searching-taxi.json',
    'assets/birthday.json',
    'assets/bluetaxi.json'
  ];
  Widget cancelTaxiRequest({
    required BuildContext context,
    required UserIdProvider userIdProvider,
  }) {
    return Consumer<TrueFalse>(
      builder: (BuildContext context, value, Widget? child) {
        return value.showRiderCancelRequest
            ? Container(
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Color(0xFF00A3E0),
                    Color(0xFF00A3E0),
                    Colors.white,
                  ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 150.0,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(milliseconds: 4040),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 2000),
                        autoPlayCurve: Curves.bounceOut,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: imageList.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Lottie.asset(i);
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 65,
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                blurRadius: 7.0,
                                color: Color(0xFFFBC408),
                                offset: Offset(0, 0),
                              ),
                            ],
                            fontWeight: FontWeight.w700),
                        child: AnimatedTextKit(
                          pause: const Duration(milliseconds: 4000),
                          repeatForever: true,
                          animatedTexts: [
                            TyperAnimatedText(
                                AppLocalizations.of(context)!.searching,
                                speed: const Duration(milliseconds: 40)),
                            ScaleAnimatedText(AppLocalizations.of(context)!.wow,
                                textStyle: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 60,
                                )),
                            ColorizeAnimatedText(
                              AppLocalizations.of(context)!.followUs,
                              textAlign: TextAlign.center,
                              colors: [
                                Colors.white60,
                                Colors.black,
                              ],
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            ColorizeAnimatedText(
                              AppLocalizations.of(context)!.dis10,
                              textAlign: TextAlign.center,
                              colors: [
                                Colors.white60,
                                Colors.black,
                              ],
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          Provider.of<PositionCancelReq>(context, listen: false)
                              .updateValue(-400.0);
                          Provider.of<PositionChang>(context, listen: false)
                              .changValue(0.0);
                          await DataBaseSrv()
                              .cancelRiderRequest(userIdProvider, context);
                          Tools().restApp(context);
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
