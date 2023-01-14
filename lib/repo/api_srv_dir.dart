//this class will use direction api between current location and drop of location

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/directions_details.dart';
import 'package:gd_passenger/my_provider/derictionDetails_provide.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../my_provider/info_user_database_provider.dart';
import '../my_provider/timeTrip_statusRide.dart';

class ApiSrvDir {
// got time/km/point
  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPostion, LatLng finalPostion, BuildContext context) async {
    DirectionDetails directionDetails = DirectionDetails(
      distanceText: "",
      durationText: "",
      distanceVale: 0,
      durationVale: 0,
      enCodingPoints: "",
    );
    final directionUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPostion.latitude},${initialPostion.longitude}&destination=${finalPostion.latitude},${finalPostion.longitude}&key=${mapKey}");

    final res = await GetUrl().getUrlMethod(directionUrl);
    if (res == "failed") {
      return null;
    }
    if (res["status"] == "OK") {
      directionDetails.enCodingPoints =
          res["routes"][0]["overview_polyline"]["points"];
      directionDetails.durationText =
          res["routes"][0]["legs"][0]["duration"]["text"];
      directionDetails.durationVale =
          res["routes"][0]["legs"][0]["duration"]["value"];
      directionDetails.distanceText =
          res["routes"][0]["legs"][0]["distance"]["text"];
      directionDetails.distanceVale =
          res["routes"][0]["legs"][0]["distance"]["value"];

      Provider.of<DirectionDetailsPro>(context, listen: false)
          .updateDirectionDetails(directionDetails);

      return directionDetails;
    }
    return directionDetails;
  }

  //this method for calc total price
  static int calculateFares1(DirectionDetails directionDetails,
      String carTypePro, BuildContext context) {
    final userInfo =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    late double culculFinal = 0.0;
    double timeTravleFare = (directionDetails.durationVale / 60) * 0.20;
    double distanceTravleFare = (directionDetails.distanceVale / 1000) * 0.60;
    double fareAmont = timeTravleFare + distanceTravleFare;
    if (carTypePro.contains("Taxi-4 seats")) {
      if (userInfo.country0.contains('T')) {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('TL');
      } else if (userInfo.country0.contains("Morocco")) {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('MAD');
      } else if (userInfo.country0.contains("Sudan")) {
        culculFinal = fareAmont * 450 + 0.70 * 450;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('SUP');
      } else if (userInfo.country0.contains("Saudi Arabia")) {
        culculFinal = fareAmont + 1.85 * 3.75 + 2.70 * 3.75;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('SAR');
      } else if (userInfo.country0.contains("Qatar")) {
        culculFinal = fareAmont - 0.25 * 3.64 + 2.75 * 3.75;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('QAR');
      } else if (userInfo.country0.contains("Libya")) {
        culculFinal = fareAmont - 0.30 * 4.80 + 1 * 4.80;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('LYD');
      } else if (userInfo.country0.contains("Kuwait")) {
        culculFinal = fareAmont + 1.65 * 0.32 + 4.88 * 0.32;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('KWD');
      } else if (userInfo.country0.contains("Iraq")) {
        culculFinal = fareAmont + 1.20 + 2.73;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('\$');
      } else if (userInfo.country0.contains("United Arab Emirates")) {
        culculFinal = fareAmont - 0.30 * 3.67 + 3.30 * 3.67;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('AED');
      } else {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('');
      }
    }
    else if (carTypePro.contains("Medium commercial-6-10 seats")) {
      if (userInfo.country0.contains('T')) {
        switch (userInfo.country) {
          case 'İstanbul':
            switch (tourismCityName) {
              case 'istanbul':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'bursa':
                culculFinal = 220;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'izmit':
                culculFinal = 150;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'sapanca':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bolu abant':
                culculFinal = 300;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'şile':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'yalova':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Antalya':
            switch (tourismCityName) {
              case 'Antalya':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Manavgat':
                culculFinal = 130;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Marmaris':
                culculFinal = 250;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bodrum':
                culculFinal = 400;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Izmir':
                culculFinal = 500;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Alanya':
                culculFinal = 160;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Muğla':
            switch (tourismCityName) {
              case 'Bodrum':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Izmir':
                culculFinal = 300;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Marmaris':
                culculFinal = 250;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'sapanca':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Bursa':
            switch (tourismCityName) {
              case 'Bursa':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Yalova':
                culculFinal = 140;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'istanbul':
                culculFinal = 240;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'sapanca':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bolu abant':
                culculFinal = 300;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'izmite':
                culculFinal = 190;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Sakarya':
            switch (tourismCityName) {
              case 'spanca':
                culculFinal = 90;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'bursa':
                culculFinal = 200;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'izmit':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'istanbul':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bolu abant':
                culculFinal = 200;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'yalova':
                culculFinal = 150;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Trabzon':
            switch (tourismCityName) {
              case 'Trabzon':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Uzun gol':
                culculFinal = 130;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Ayder':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Rize':
                culculFinal = 160;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Giresun':
                culculFinal = 160;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'ondu':
                culculFinal = 200;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Çaykara':
            switch (tourismCityName) {
              case 'Uzungöl':
                culculFinal = 80;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Trabzon':
                culculFinal = 190;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Ayder':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Rize':
                culculFinal = 140;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'ondu':
                culculFinal = 220;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          default:
            culculFinal = fareAmont * 13 + 0.70 * 14.00;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateCurrencyType('TL');
            break;
        }
      } else if (userInfo.country0.contains("Morocco")) {
        culculFinal = fareAmont + 0.20 * 10 + 1.50 * 10.00;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('MAD');
      } else if (userInfo.country0.contains("Sudan")) {
        culculFinal = fareAmont * 450 + 1.50 * 450;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('SUP');
      } else if (userInfo.country0.contains("Saudi Arabia")) {
        culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 3.70 * 3.75;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('SAR');
      } else if (userInfo.country0.contains("Qatar")) {
        culculFinal = fareAmont * 3.64 + 4.75 * 3.75;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('QAR');
      } else if (userInfo.country0.contains("Libya")) {
        culculFinal = fareAmont * 4.80 + 3 * 4.80;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('LYD');
      } else if (userInfo.country0.contains("Kuwait")) {
        culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 5.88 * 0.32;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('KWD');
      } else if (userInfo.country0.contains("Iraq")) {
        culculFinal = fareAmont + 0.20 + 1.20 + 4.73;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('\$');
      } else if (userInfo.country0.contains("United Arab Emirates")) {
        culculFinal = fareAmont * 3.67 + 5.30 * 3.67;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('AED');
      } else {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('');
      }
    }
    else if (carTypePro.contains("Big commercial-11-19 seats")) {
      if (userInfo.country0.contains("T")) {
        switch (userInfo.country) {
          case 'İstanbul':
            switch (tourismCityName) {
              case 'istanbul':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'bursa':
                culculFinal = 220;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'izmit':
                culculFinal = 150;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'sapanca':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bolu abant':
                culculFinal = 300;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'şile':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'yalova':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 19 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Antalya':
            switch (tourismCityName) {
              case 'Antalya':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Manavgat':
                culculFinal = 130;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Marmaris':
                culculFinal = 250;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bodrum':
                culculFinal = 400;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Izmir':
                culculFinal = 500;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Alanya':
                culculFinal = 160;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Muğla':
            switch (tourismCityName) {
              case 'Bodrum':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Izmir':
                culculFinal = 300;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Marmaris':
                culculFinal = 250;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'sapanca':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Bursa':
            switch (tourismCityName) {
              case 'Bursa':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Yalova':
                culculFinal = 140;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'istanbul':
                culculFinal = 240;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'sapanca':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bolu abant':
                culculFinal = 300;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'izmite':
                culculFinal = 190;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Sakarya':
            switch (tourismCityName) {
              case 'spanca':
                culculFinal = 90;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'bursa':
                culculFinal = 200;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'izmit':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'istanbul':
                culculFinal = 180;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Bolu abant':
                culculFinal = 200;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'yalova':
                culculFinal = 150;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Trabzon':
            switch (tourismCityName) {
              case 'Trabzon':
                culculFinal = 100;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Uzun gol':
                culculFinal = 130;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Ayder':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Rize':
                culculFinal = 160;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Giresun':
                culculFinal = 160;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'ondu':
                culculFinal = 200;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          case 'Çaykara':
            switch (tourismCityName) {
              case 'Uzungöl':
                culculFinal = 80;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Trabzon':
                culculFinal = 190;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Ayder':
                culculFinal = 170;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'Rize':
                culculFinal = 140;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              case 'ondu':
                culculFinal = 220;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('\$');
                break;
              default:
                culculFinal = fareAmont * 15 + 0.70 * 10.00;
                Provider.of<TimeTripStatusRide>(context, listen: false)
                    .updateCurrencyType('TL');
                break;
            }
            break;
          default:
            culculFinal = fareAmont * 15 + 0.70 * 10.00;
            Provider.of<TimeTripStatusRide>(context, listen: false)
                .updateCurrencyType('TL');
            break;
        }
      } else if (userInfo.country0.contains("Morocco")) {
        culculFinal = fareAmont + 0.20 * 10 + 2 * 10.00;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('MAD');
      } else if (userInfo.country0.contains("Sudan")) {
        culculFinal = fareAmont * 450 + 2 * 450;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('SUP');
      } else if (userInfo.country0.contains("Saudi Arabia")) {
        culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 4.70 * 3.75;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('SAR');
      } else if (userInfo.country0.contains("Qatar")) {
        culculFinal = fareAmont * 3.64 + 5.75 * 3.64;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('QAR');
      } else if (userInfo.country0.contains("Libya")) {
        culculFinal = fareAmont * 4.80 + 4 * 4.80;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('LYD');
      } else if (userInfo.country0.contains("Kuwait")) {
        culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 6.88 * 0.32;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('KWD');
      } else if (userInfo.country0.contains("Iraq")) {
        culculFinal = fareAmont + 0.20 + 1.20 + 5.73;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('\$');
      } else if (userInfo.country0.contains("United Arab Emirates")) {
        culculFinal = fareAmont * 3.67 + 6.30 * 3.67;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('AED');
      } else {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
        Provider.of<TimeTripStatusRide>(context, listen: false)
            .updateCurrencyType('');
      }
    }
    else {
      culculFinal = fareAmont * 10 + 0.70 * 10.00;
      Provider.of<TimeTripStatusRide>(context, listen: false)
          .updateCurrencyType('');
    }
    return culculFinal.truncate();
  }
}
