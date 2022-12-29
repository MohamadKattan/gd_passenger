import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gd_passenger/model/driverPreBook.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/carTypeBook_provider.dart';
import '../my_provider/city_provider.dart';
import '../my_provider/country_provider.dart';
import 'driverPerBooking_list.dart';

class AdvanceReservation extends StatefulWidget {
  const AdvanceReservation({Key? key}) : super(key: key);

  @override
  State<AdvanceReservation> createState() => _AdvanceReservationState();
}

class _AdvanceReservationState extends State<AdvanceReservation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  String valueCountry = "";
  String valueCity = "";
  String valueCarType = "";
  bool showCityDrop = false;
  bool showCarTypeDrop = false;
  bool showCountryDrop = true;
  bool indctorBool = false;
  List<String> countryList = [];
  List<String> turkeyCityList = [];
  List<String> saudiCityList = [];
  List<String> uasCityList = [];
  List<String> kwtCityList = [];
  List<String> qutrCityList = [];
  List<String> morCityList = [];
  List<String> carTypeList = [];

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A3E0),
        automaticallyImplyLeading: true,
        title: Text(
          AppLocalizations.of(context)!.advanceReservation,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              overflow: TextOverflow.fade),
        ),
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Opacity(
                opacity: 0.3,
                child: FadeTransition(
                  opacity: animation,
                  child: Image.asset(
                    'assets/reservtion.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),
              )),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.takeAdvanceReservation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.fade),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    height: 2.0,
                    width: 180.0,
                    color: const Color(0xFFFFD54F),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.exAdvanceReservation,
                      textScaleFactor: 1.3,
                      textHeightBehavior: const TextHeightBehavior(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          overflow: TextOverflow.fade),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                showCountryDrop == true
                    ? dropBottomCountry()
                    : showCityDrop == true
                        ? dropBottomCity()
                        : showCarTypeDrop == true
                            ? dropBottomCarType()
                            : const Text(''),
                // : Center(
                //     child: GestureDetector(
                //       onTap: ()=>startSearchDrivers(),
                //       child: Container(
                //       height: 50,
                //       width: 160,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(14.0),
                //         color: const Color(0xFFFFD54F),
                //       ),
                //       child: Center(
                //           child: Text(
                //               AppLocalizations.of(context)!.search,
                //               style: const TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 18,
                //                   fontWeight: FontWeight.bold),
                //               textAlign: TextAlign.center)),
                //   ),
                //     )),
                const SizedBox(height: 30),
              ],
            ),
          ),
          indctorBool == true ? customInductor() : const Text('')
        ],
      ),
    ));
  }

// this dropBottom for choose country
  Widget dropBottomCountry() {
    String val1 = AppLocalizations.of(context)!.choseCountry;
    List<String> newCountryList = [
      AppLocalizations.of(context)!.choseCountry,
      AppLocalizations.of(context)!.turkey,
      AppLocalizations.of(context)!.sak,
      AppLocalizations.of(context)!.uas,
      AppLocalizations.of(context)!.kwt,
      AppLocalizations.of(context)!.qutar,
      AppLocalizations.of(context)!.morocco
    ];
    countryList = newCountryList;
    return Container(
      padding: const EdgeInsets.all(4.0),
      height: MediaQuery.of(context).size.height * 6 / 100,
      width: MediaQuery.of(context).size.width * 90 / 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.white, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: valueCountry == "" ? val1 : valueCountry,
            isExpanded: true,
            dropdownColor: Colors.white,
            iconSize: 30.0,
            iconEnabledColor: Colors.white,
            items: countryList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    const Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(value,
                        style: const TextStyle(
                            color: Color(0xFF00A3E0),
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                valueCountry = val!;
              });
              switchCountryValue(val!);
            }),
      ),
    );
  }

  // this method for set value country to be == in value database
  void switchCountryValue(String val) {
    if (val == AppLocalizations.of(context)!.turkey) {
      showCountryDrop = false;
      showCityDrop = true;
      Provider.of<CountryProvider>(context, listen: false)
          .updateState('Turkey');
    } else if (val == AppLocalizations.of(context)!.sak) {
      showCountryDrop = false;
      showCityDrop = true;
      Provider.of<CountryProvider>(context, listen: false)
          .updateState('Saudi Arabia');
    } else if (val == AppLocalizations.of(context)!.uas) {
      showCountryDrop = false;
      showCityDrop = true;
      Provider.of<CountryProvider>(context, listen: false)
          .updateState('United Arab Emirates');
    } else if (val == AppLocalizations.of(context)!.kwt) {
      showCountryDrop = false;
      showCityDrop = true;
      Provider.of<CountryProvider>(context, listen: false)
          .updateState('Kuwait');
    } else if (val == AppLocalizations.of(context)!.qutar) {
      showCountryDrop = false;
      showCityDrop = true;
      Provider.of<CountryProvider>(context, listen: false).updateState('Qatar');
    } else if (val == AppLocalizations.of(context)!.morocco) {
      showCountryDrop = false;
      showCityDrop = true;
      Provider.of<CountryProvider>(context, listen: false)
          .updateState('Morocco');
    } else {
      showCountryDrop = true;
      showCityDrop = false;
      Provider.of<CountryProvider>(context, listen: false)
          .updateState('Choose Country');
    }
  }

  // this for show any list of city after chose country
  List<String> listOfCity() {
    List<String> resultLest = [];
    String countryValPro =
        Provider.of<CountryProvider>(context, listen: false).country;
    if (countryValPro == 'Turkey') {
      setState(() {
        showCountryDrop = false;
        showCityDrop = false;
        showCarTypeDrop = true;
        resultLest = turkeyCityList;
      });
    } else if (countryValPro == 'Saudi Arabia') {
      setState(() {
        resultLest = saudiCityList;
      });
    } else if (countryValPro == 'United Arab Emirates') {
      setState(() {
        resultLest = uasCityList;
      });
    } else if (countryValPro == 'Kuwait') {
      setState(() {
        resultLest = kwtCityList;
      });
    } else if (countryValPro == 'Qatar') {
      setState(() {
        resultLest = qutrCityList;
      });
    } else if (countryValPro == 'Morocco') {
      setState(() {
        resultLest = morCityList;
      });
    } else {
      resultLest = turkeyCityList;
    }
    return resultLest;
  }

  // this dropBottom for choose city
  Widget dropBottomCity() {
    String val1 = AppLocalizations.of(context)!.choosesCity;
    List<String> newTurkCity = [
      AppLocalizations.of(context)!.choosesCity,
      AppLocalizations.of(context)!.istanbulCity,
      AppLocalizations.of(context)!.bursaCity,
      AppLocalizations.of(context)!.trapzonCity,
      AppLocalizations.of(context)!.antalyaCity,
      AppLocalizations.of(context)!.bodrumCity,
      AppLocalizations.of(context)!.sapancaCity,
    ];
    List<String> newSaudiCity = [
      AppLocalizations.of(context)!.choosesCity,
      AppLocalizations.of(context)!.makkah,
      AppLocalizations.of(context)!.alMadinah,
      AppLocalizations.of(context)!.rayad,
      AppLocalizations.of(context)!.jdah,
    ];
    List<String> newUasCity = [
      AppLocalizations.of(context)!.choosesCity,
      AppLocalizations.of(context)!.abodoubi,
      AppLocalizations.of(context)!.dubai,
    ];
    List<String> newKwtCity = [
      AppLocalizations.of(context)!.choosesCity,
      AppLocalizations.of(context)!.kuwaitCity,
      AppLocalizations.of(context)!.alAhmadi,
    ];
    List<String> newQutarCity = [
      AppLocalizations.of(context)!.choosesCity,
      AppLocalizations.of(context)!.douha,
    ];
    List<String> newMorcooCity = [
      AppLocalizations.of(context)!.choosesCity,
      AppLocalizations.of(context)!.morRibat,
      AppLocalizations.of(context)!.morDar,
      AppLocalizations.of(context)!.morFas,
      AppLocalizations.of(context)!.morMarksgh,
    ];
    turkeyCityList = newTurkCity;
    saudiCityList = newSaudiCity;
    uasCityList = newUasCity;
    kwtCityList = newKwtCity;
    qutrCityList = newQutarCity;
    morCityList = newMorcooCity;

    return Container(
      padding: const EdgeInsets.all(4.0),
      height: MediaQuery.of(context).size.height * 6 / 100,
      width: MediaQuery.of(context).size.width * 90 / 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.white, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: valueCity == "" ? val1 : valueCity,
            isExpanded: true,
            dropdownColor: Colors.white,
            iconSize: 30.0,
            iconEnabledColor: Colors.white,
            items: listOfCity().map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_city_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(value,
                        style: const TextStyle(
                            color: Color(0xFF00A3E0),
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                valueCity = val!;
              });
              switchCityValue(val!);
            }),
      ),
    );
  }

  // this method for set value city to be == in value database
  void switchCityValue(String val) {
    if (val == turkeyCityList[1]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('İstanbul');
    } else if (val == turkeyCityList[2]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Bursa');
    } else if (val == turkeyCityList[3]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Antalya');
    } else if (val == turkeyCityList[4]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Trabzon');
    } else if (val == turkeyCityList[5]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Bodrum');
    } else if (val == turkeyCityList[6]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('sapanca');
    } else if (val == saudiCityList[1]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Makkah Province');
    } else if (val == saudiCityList[2]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Al Madinah Province');
    } else if (val == saudiCityList[3]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Riyadh Province');
    } else if (val == saudiCityList[4]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Makkah Province');
    } else if (val == uasCityList[1]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Abu Dhabi');
    } else if (val == uasCityList[2]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Dubai');
    } else if (val == kwtCityList[1]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Al Asimah Governate');
    } else if (val == kwtCityList[2]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Al Ahmadi Governorate');
    } else if (val == qutrCityList[1]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Doha');
    } else if (val == morCityList[1]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Rabat');
    } else if (val == morCityList[2]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Casablanca-Settat');
    } else if (val == morCityList[3]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false).updateState('Tangier');
    } else if (val == morCityList[4]) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CityProvider>(context, listen: false)
          .updateState('Marrakesh');
    } else {
      showCountryDrop = false;
      showCityDrop = true;
      showCarTypeDrop = false;
      Provider.of<CityProvider>(context, listen: false).updateState('null');
    }
  }

  // this dropBottom for choose country
  Widget dropBottomCarType() {
    String val1 = AppLocalizations.of(context)!.chooseCarType;
    List<String> newCarTypeList = [
      AppLocalizations.of(context)!.chooseCarType,
      AppLocalizations.of(context)!.middleCar,
      AppLocalizations.of(context)!.bigCar1,
    ];
    carTypeList = newCarTypeList;
    return Container(
      padding: const EdgeInsets.all(4.0),
      height: MediaQuery.of(context).size.height * 6 / 100,
      width: MediaQuery.of(context).size.width * 90 / 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.white, width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: valueCarType == "" ? val1 : valueCarType,
            isExpanded: true,
            dropdownColor: Colors.white,
            iconSize: 30.0,
            iconEnabledColor: Colors.white,
            items: carTypeList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    const Expanded(
                      flex: 0,
                      child: Icon(
                        Icons.car_crash,
                        color: Color(0xFF00A3E0),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      flex: 0,
                      child: Text(value,
                          style: const TextStyle(
                              color: Color(0xFF00A3E0),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                valueCarType = val!;
              });
              switchCarType(val!);
            }),
      ),
    );
  }

  // this method for switch car type to == in database
  Future<void> switchCarType(String val) async {
    if (val == AppLocalizations.of(context)!.middleCar) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      indctorBool = true;
      Provider.of<CarTypeBook>(context, listen: false)
          .updateState('Medium commercial-6-10 seats');
      await startSearchDrivers().whenComplete(() {
        setState(() {
          indctorBool = false;
          showCarTypeDrop = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const DriverPreBooking()));
      });
    } else if (val == AppLocalizations.of(context)!.bigCar1) {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      indctorBool = true;
      Provider.of<CarTypeBook>(context, listen: false)
          .updateState('Big commercial-11-19 seats');
      await startSearchDrivers().whenComplete(() {
        setState(() {
          indctorBool = false;
          showCarTypeDrop = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const DriverPreBooking()));
      });
    } else {
      showCountryDrop = false;
      showCityDrop = false;
      showCarTypeDrop = true;
      Provider.of<CarTypeBook>(context, listen: false)
          .updateState('Choose the type of car');
    }
  }

// this method for start get drivers from database
  Future<void> startSearchDrivers() async {
    driverPreBookList.clear();
    String _country =
        Provider.of<CountryProvider>(context, listen: false).country;
    String _carType = Provider.of<CarTypeBook>(context, listen: false).carType;
    String _city = Provider.of<CityProvider>(context, listen: false).city;
    final _ref = FirebaseDatabase.instance.ref();
    final snap = await _ref.child('prebook').get();
    try {
      if (snap.exists) {
        Map<String, dynamic> map = Map<String, dynamic>.from(snap.value as Map);
        for (var i in map.values) {
          Map<String, dynamic> newMap = Map<String, dynamic>.from(i as Map);
          DriverPreBook _driverPreBook = DriverPreBook.fromMap(newMap);
          if (_driverPreBook.country == _country) {
            if (_driverPreBook.city == _city) {
              if (_driverPreBook.carType == _carType) {
                driverPreBookList.add(_driverPreBook);
              }
            }
          }
        }
      } else {
        if (kDebugMode) {
          print('snap preBook null');
        }
      }
    } catch (ex) {
      if (kDebugMode) {
        print("preBooking${ex.toString()}");
      }
    }
  }

  Widget customInductor() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.black45,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD54F))),
          const SizedBox(height: 15),
          Text(AppLocalizations.of(context)!.search,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
