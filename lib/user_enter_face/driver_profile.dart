import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gd_passenger/model/driverPreBook.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../my_provider/carTypeBook_provider.dart';
import '../tools/tools.dart';

class DriverProfile extends StatelessWidget {
  final List<DriverPreBook> driverProfilePre;
  final int index;
  const DriverProfile(this.driverProfilePre, this.index, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF00A3E0),
              title: Text(AppLocalizations.of(context)!.profileDriver),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listOfImageCar(context, driverProfilePre, index),
                  Center(
                    child: Container(
                      height: 2.0,
                      width: 180.0,
                      color: const Color(0xFFFFD54F),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.driverName +
                              '  ' +
                              driverProfilePre[index].firstName +
                              " " +
                              driverProfilePre[index].lastName,
                          style: const TextStyle(
                              color: Color(0xFF00A3E0), fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            imageUrl: driverProfilePre[index].driverImage,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.countryCity +
                          ' : ' +
                          driverProfilePre[index].country +
                          "/" +
                          driverProfilePre[index].city,
                      style: const TextStyle(
                          color: Color(0xFF00A3E0), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.carType +
                          ' : ' +
                          _carType(context),
                      style: const TextStyle(
                          color: Color(0xFF00A3E0), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.phone +
                          ' : ' +
                          driverProfilePre[index].phoneNumber,
                      style: const TextStyle(
                          color: Color(0xFF00A3E0), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.carPlCK +
                          ' : ' +
                          driverProfilePre[index].idPlack,
                      style: const TextStyle(
                          color: Color(0xFF00A3E0), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              _callDriver(context, driverProfilePre, index)),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        width: 180,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: const Color(0xFFFFD54F)),
                        child: Center(
                          child: Text(AppLocalizations.of(context)!.callDriver,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

// this widget for list of car image
  Widget listOfImageCar(
      BuildContext context, List<DriverPreBook> driverProfilePre, int index) {
    List<String> _driverCarImages = [
      driverProfilePre[index].carOutSide,
      driverProfilePre[index].carOutSide1,
      driverProfilePre[index].carInside
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 40 / 100,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 1.0,
              enlargeCenterPage: true,
            ),
            items: _driverCarImages
                .map((item) => Center(
                        child: Image.network(
                      item,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 35 / 100,
                    )))
                .toList(),
          ),
        ),
      ),
    );
  }

  String _carType(BuildContext context) {
    String carClass = Provider.of<CarTypeBook>(context, listen: false).carType;
    String _result = "";
    switch (carClass) {
      case 'Medium commercial-6-10 seats':
        _result = AppLocalizations.of(context)!.middleCar;
        break;
      case 'Big commercial-11-19 seats':
        _result = AppLocalizations.of(context)!.bigCar1;
        break;
      default:
        _result = AppLocalizations.of(context)!.middleCar;
        break;
    }
    return _result;
  }

// for call driver
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
                  await canLaunch("tel:${driverPreBookList[index].phoneNumber}")
                      ? launch("tel:${driverPreBookList[index].phoneNumber}")
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
                  await canLaunch(
                          "https://wa.me/${driverPreBookList[index].phoneNumber}")
                      ? launch(
                          "https://wa.me/${driverPreBookList[index].phoneNumber}")
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
}
