import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/driverPreBook.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../my_provider/buttom_color_pro.dart';
import '../my_provider/double_value.dart';
import '../tools/tools.dart';
import 'driver_profile.dart';

class DriverPreBooking extends StatelessWidget {
  const DriverPreBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.listOfDrivers,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              backgroundColor: const Color(0xFF00A3E0),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      driverPreBookList.clear();
                      Provider.of<DoubleValue>(context, listen: false)
                          .value0Or1(0);
                      Provider.of<ChangeColor>(context, listen: false)
                          .updateState(false);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(builder: (_) => const HomeScreen()),
                      //     (route) => false);
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 24,
                    ))
              ],
            ),
            body: driverPreBookList.isEmpty
                ? listIsEmpty(context)
                : ListView.builder(
                    itemCount: driverPreBookList.length,
                    itemBuilder: (_, index) {
                      return listOfDrivers(context, index, driverPreBookList);
                    })));
  }

  // this widget if no driver in preBooking
  Widget listIsEmpty(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Lottie.asset('assets/85557-empty.json',
                  fit: BoxFit.contain, height: 160, width: 160)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.sorry,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF00A3E0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget listOfDrivers(
      BuildContext context, int index, List<DriverPreBook> driverPreBookList) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DriverProfile(driverPreBookList, index))),
      child: Container(
          margin: const EdgeInsets.all(12.0),
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(width: 1.0, color: const Color(0xFF00A3E0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          imageUrl: driverPreBookList[index].driverImage,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(width: 2.0, color: Colors.grey)),
                        child: SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: ratDriverRead,
                          size: 10.0,
                          color: Colors.yellow.shade700,
                          borderColor: Colors.yellow.shade700,
                          spacing: 0.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      flex: 0,
                      child: Text(
                        driverPreBookList[index].firstName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => Container(
                          width: 90.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                                color: const Color(0xFFFFD54F), width: 1.0),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        imageUrl: driverPreBookList[index].driverImage,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Expanded(
                        flex: 0,
                        child: Text(
                          driverPreBookList[index].country +
                              '-' +
                              driverPreBookList[index].city,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF00A3E0)),
                        )),
                    Expanded(
                        flex: 0,
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DriverProfile(
                                            driverPreBookList, index))),
                                child: const Icon(
                                  Icons.info,
                                  color: Color(0xFFFFD54F),
                                  size: 24,
                                )),
                            const SizedBox(width: 12.0),
                            GestureDetector(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) => _callDriver(
                                        context, driverPreBookList, index)),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.greenAccent.shade700,
                                  size: 24,
                                )),
                          ],
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _callDriver(
      BuildContext context, List<DriverPreBook> driverPreBookList, int index) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0)),
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
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.red))
                ],
              ),
              GestureDetector(
                onTap: () async {
                  String _url = "tel:${driverPreBookList[index].phoneNumber}";
                  await Tools().lunchUrl(context, _url);
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
                  String _url =
                      "https://wa.me/${driverPreBookList[index].phoneNumber}";
                  await Tools().lunchUrl(context, _url);
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
}
