//this class will use direction api between current location and drop of location

import 'package:flutter/cupertino.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/directions_details.dart';
import 'package:gd_passenger/my_provider/derictionDetails_provide.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../my_provider/info_user_database_provider.dart';

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

    /// new add
    return directionDetails;
  }

  //this method for caulc total price

  // static int calculateFares(
  //     DirectionDetails directionDetails, String carTypePro) {
  //   double timeTravleFare = (directionDetails.durationVale / 60) * 0.05;
  //   double distanceTravleFare = (directionDetails.distanceVale / 1000) * 0.40;
  //   double fareAmont = timeTravleFare + distanceTravleFare;
  //   final culculFinal = carTypePro == "Taxi-4 seats"
  //       ? fareAmont * 13 + 0.70 * 13.00
  //       : carTypePro == "Medium commercial-6-10 seats"
  //           ? fareAmont * 13 + 1.5 * 13.00
  //           : carTypePro == "Big commercial-11-19 seats"
  //               ? fareAmont * 13 + 2 * 13.00
  //               : 0;
  //   return culculFinal.truncate();
  // }
  ///todo old code
//   static int calculateFares1(DirectionDetails directionDetails,
//       String carTypePro, BuildContext context) {
//     final contryName =
//         Provider.of<UserAllInfoDatabase>(context, listen: false).users.country;
//     late double culculFinal;
//     double timeTravleFare = (directionDetails.durationVale / 60) * 0.20;
//     double distanceTravleFare = (directionDetails.distanceVale / 1000) * 0.60;
//     double fareAmont = timeTravleFare + distanceTravleFare;
//     if (carTypePro == "Taxi-4 seats" && contryName == "Turkey") {
//       culculFinal = fareAmont * 13 + 0.70 * 13.00;
//     } else if (carTypePro == "Taxi-4 seats" && contryName == "Morocco") {
//       culculFinal = fareAmont * 10 + 0.70 * 10.00;
//     } else if (carTypePro == "Taxi-4 seats" && contryName == "Sudan") {
//       culculFinal = fareAmont * 450 + 0.70 * 450;
//     } else if (carTypePro == "Taxi-4 seats" && contryName == "Saudi Arabia") {
//       culculFinal = fareAmont + 1.85 * 3.75 + 2.70 * 3.75;
//     } else if (carTypePro == "Taxi-4 seats" && contryName == "Qatar") {
//       culculFinal = fareAmont - 0.25 * 3.64 + 2.75 * 3.75;
//     } else if (carTypePro == "Taxi-4 seats" && contryName == "Libya") {
//       culculFinal = fareAmont - 0.30 * 4.80 + 1 * 4.80;
//     } else if (carTypePro == "Taxi-4 seats" && contryName == "Kuwait") {
//       culculFinal = fareAmont + 1.65 * 0.32 + 4.88 * 0.32;
//     } else if (carTypePro == "Taxi-4 seats" && contryName == "Iraq") {
//       culculFinal = fareAmont + 1.20 + 2.73;
//     } else if (carTypePro == "Taxi-4 seats" &&
//         contryName == "United Arab Emirates") {
//       culculFinal = fareAmont - 0.30 * 3.67 + 3.30 * 3.67;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Turkey"||contry=="Turkey") {
//       if (tourismCityName == "istanbul") {
//         culculFinal = 100;
//       } else if (tourismCityName == "bursa") {
//         culculFinal = 220;
//       } else if (tourismCityName == "izmit") {
//         culculFinal = 150;
//       } else if (tourismCityName == "sapanca") {
//         culculFinal = 180;
//       } else if (tourismCityName == "Bolu abant") {
//         culculFinal = 300;
//       } else if (tourismCityName == "şile") {
//         culculFinal = 170;
//       } else if (tourismCityName == "yalova") {
//         culculFinal = 170;
//       } else {
//         culculFinal = 100;
//       }
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Morocco") {
//       culculFinal = fareAmont + 0.20 * 10 + 1.50 * 10.00;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Sudan") {
//       culculFinal = fareAmont * 450 + 1.50 * 450;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Saudi Arabia") {
//       culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 3.70 * 3.75;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Qatar") {
//       culculFinal = fareAmont * 3.64 + 4.75 * 3.75;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Libya") {
//       culculFinal = fareAmont * 4.80 + 3 * 4.80;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Kuwait") {
//       culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 5.88 * 0.32;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "Iraq") {
//       culculFinal = fareAmont + 0.20 + 1.20 + 4.73;
//     } else if (carTypePro == "Medium commercial-6-10 seats" &&
//         contryName == "United Arab Emirates") {
//       culculFinal = fareAmont * 3.67 + 5.30 * 3.67;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Turkey"||contry=="Turkey") {
//       if (tourismCityName == "istanbul") {
//         culculFinal = 100;
//       } else if (tourismCityName == "bursa") {
//         culculFinal = 220;
//       } else if (tourismCityName == "izmit") {
//         culculFinal = 150;
//       } else if (tourismCityName == "sapanca") {
//         culculFinal = 180;
//       } else if (tourismCityName == "Bolu abant") {
//         culculFinal = 300;
//       } else if (tourismCityName == "şile") {
//         culculFinal = 170;
//       } else if (tourismCityName == "yalova") {
//         culculFinal = 170;
//       } else {
//         culculFinal = 100;
//       }
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Morocco") {
//       culculFinal = fareAmont + 0.20 * 10 + 2 * 10.00;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Sudan") {
//       culculFinal = fareAmont * 450 + 2 * 450;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Saudi Arabia") {
//       culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 4.70 * 3.75;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Qatar") {
//       culculFinal = fareAmont * 3.64 + 5.75 * 3.64;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Libya") {
//       culculFinal = fareAmont * 4.80 + 4 * 4.80;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Kuwait") {
//       culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 6.88 * 0.32;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "Iraq") {
//       culculFinal = fareAmont + 0.20 + 1.20 + 5.73;
//     } else if (carTypePro == "Big commercial-11-19 seats" &&
//         contryName == "United Arab Emirates") {
//       culculFinal = fareAmont * 3.67 + 6.30 * 3.67;
//     } else {
//       culculFinal = 200.0;
//     }
//     return culculFinal.truncate();
//   }

  static int calculateFares1(DirectionDetails directionDetails,
      String carTypePro, BuildContext context) {
    final userInfo =
        Provider.of<UserAllInfoDatabase>(context, listen: false).users;
    late double culculFinal=0.0;
    double timeTravleFare = (directionDetails.durationVale / 60) * 0.20;
    double distanceTravleFare = (directionDetails.distanceVale / 1000) * 0.60;
    double fareAmont = timeTravleFare + distanceTravleFare;
    if (carTypePro == "Taxi-4 seats" && userInfo.country0 == "Turkey") {
      culculFinal = fareAmont * 13 + 0.70 * 13.00;
    }
    else if (carTypePro == "Taxi-4 seats" && userInfo.country0 == "Morocco") {
      culculFinal = fareAmont * 10 + 0.70 * 10.00;
    } else if (carTypePro == "Taxi-4 seats" && userInfo.country0 == "Sudan") {
      culculFinal = fareAmont * 450 + 0.70 * 450;
    } else if (carTypePro == "Taxi-4 seats" &&
        userInfo.country0 == "Saudi Arabia") {
      culculFinal = fareAmont + 1.85 * 3.75 + 2.70 * 3.75;
    } else if (carTypePro == "Taxi-4 seats" && userInfo.country0 == "Qatar") {
      culculFinal = fareAmont - 0.25 * 3.64 + 2.75 * 3.75;
    } else if (carTypePro == "Taxi-4 seats" && userInfo.country0 == "Libya") {
      culculFinal = fareAmont - 0.30 * 4.80 + 1 * 4.80;
    } else if (carTypePro == "Taxi-4 seats" && userInfo.country0 == "Kuwait") {
      culculFinal = fareAmont + 1.65 * 0.32 + 4.88 * 0.32;
    } else if (carTypePro == "Taxi-4 seats" && userInfo.country0 == "Iraq") {
      culculFinal = fareAmont + 1.20 + 2.73;
    } else if (carTypePro == "Taxi-4 seats" &&
        userInfo.country0 == "United Arab Emirates") {
      culculFinal = fareAmont - 0.30 * 3.67 + 3.30 * 3.67;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Turkey") {
      switch (userInfo.country) {
        case 'İstanbul':
          switch (tourismCityName) {
            case 'istanbul':
              culculFinal = 100;
              break;
            case 'bursa':
              culculFinal = 220;
              break;
            case 'izmit':
              culculFinal = 150;
              break;
            case 'sapanca':
              culculFinal = 180;
              break;
            case 'Bolu abant':
              culculFinal = 300;
              break;
            case 'şile':
              culculFinal = 170;
              break;
            case 'yalova':
              culculFinal = 170;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Antalya':
          switch (tourismCityName) {
            case 'Antalya':
              culculFinal = 100;
              break;
            case 'Manavgat':
              culculFinal = 130;
              break;
            case 'Marmaris':
              culculFinal = 250;
              break;
            case 'Bodrum':
              culculFinal = 400;
              break;
            case 'Izmir':
              culculFinal = 500;
              break;
            case 'Alanya':
              culculFinal = 160;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Muğla':
          switch (tourismCityName) {
            case 'Bodrum':
              culculFinal = 100;
              break;
            case 'Izmir':
              culculFinal = 300;
              break;
            case 'Marmaris':
              culculFinal = 250;
              break;
            case 'sapanca':
              culculFinal = 180;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Bursa':
          switch (tourismCityName) {
            case 'Bursa':
              culculFinal = 100;
              break;
            case 'Yalova':
              culculFinal = 140;
              break;
            case 'istanbul':
              culculFinal = 240;
              break;
            case 'sapanca':
              culculFinal = 180;
              break;
            case 'Bolu abant':
              culculFinal = 300;
              break;
            case 'izmite':
              culculFinal = 190;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Sakarya':
          switch (tourismCityName) {
            case 'spanca':
              culculFinal = 90;
              break;
            case 'bursa':
              culculFinal = 200;
              break;
            case 'izmit':
              culculFinal = 100;
              break;
            case 'istanbul':
              culculFinal = 180;
              break;
            case 'Bolu abant':
              culculFinal = 200;
              break;
            case 'yalova':
              culculFinal = 150;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Trabzon':
          switch (tourismCityName) {
            case 'Trabzon':
              culculFinal = 100;
              break;
            case 'Uzun gol':
              culculFinal = 130;
              break;
            case 'Ayder':
              culculFinal = 170;
              break;
            case 'Rize':
              culculFinal = 160;
              break;
            case 'Giresun':
              culculFinal = 160;
              break;
            case 'ondu':
              culculFinal = 200;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Çaykara':
          switch (tourismCityName) {
            case 'Uzungöl':
              culculFinal = 80;
              break;
            case 'Trabzon':
              culculFinal = 190;
              break;
            case 'Ayder':
              culculFinal = 170;
              break;
            case 'Rize':
              culculFinal = 140;
              break;
            case 'ondu':
              culculFinal = 220;
              break;
            default:
              100;
              break;
          }
          break;
        default:
          null;
          break;
      }
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Morocco") {
      culculFinal = fareAmont + 0.20 * 10 + 1.50 * 10.00;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Sudan") {
      culculFinal = fareAmont * 450 + 1.50 * 450;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Saudi Arabia") {
      culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 3.70 * 3.75;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Qatar") {
      culculFinal = fareAmont * 3.64 + 4.75 * 3.75;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Libya") {
      culculFinal = fareAmont * 4.80 + 3 * 4.80;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Kuwait") {
      culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 5.88 * 0.32;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "Iraq") {
      culculFinal = fareAmont + 0.20 + 1.20 + 4.73;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        userInfo.country0 == "United Arab Emirates") {
      culculFinal = fareAmont * 3.67 + 5.30 * 3.67;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Turkey") {
      switch (userInfo.country) {
        case 'İstanbul':
          switch (tourismCityName) {
            case 'istanbul':
              culculFinal = 100;
              break;
            case 'bursa':
              culculFinal = 220;
              break;
            case 'izmit':
              culculFinal = 150;
              break;
            case 'sapanca':
              culculFinal = 180;
              break;
            case 'Bolu abant':
              culculFinal = 300;
              break;
            case 'şile':
              culculFinal = 170;
              break;
            case 'yalova':
              culculFinal = 170;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Antalya':
          switch (tourismCityName) {
            case 'Antalya':
              culculFinal = 100;
              break;
            case 'Manavgat':
              culculFinal = 130;
              break;
            case 'Marmaris':
              culculFinal = 250;
              break;
            case 'Bodrum':
              culculFinal = 400;
              break;
            case 'Izmir':
              culculFinal = 500;
              break;
            case 'Alanya':
              culculFinal = 160;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Muğla':
          switch (tourismCityName) {
            case 'Bodrum':
              culculFinal = 100;
              break;
            case 'Izmir':
              culculFinal = 300;
              break;
            case 'Marmaris':
              culculFinal = 250;
              break;
            case 'sapanca':
              culculFinal = 180;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Bursa':
          switch (tourismCityName) {
            case 'Bursa':
              culculFinal = 100;
              break;
            case 'Yalova':
              culculFinal = 140;
              break;
            case 'istanbul':
              culculFinal = 240;
              break;
            case 'sapanca':
              culculFinal = 180;
              break;
            case 'Bolu abant':
              culculFinal = 300;
              break;
            case 'izmite':
              culculFinal = 190;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Sakarya':
          switch (tourismCityName) {
            case 'spanca':
              culculFinal = 90;
              break;
            case 'bursa':
              culculFinal = 200;
              break;
            case 'izmit':
              culculFinal = 100;
              break;
            case 'istanbul':
              culculFinal = 180;
              break;
            case 'Bolu abant':
              culculFinal = 200;
              break;
            case 'yalova':
              culculFinal = 150;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Trabzon':
          switch (tourismCityName) {
            case 'Trabzon':
              culculFinal = 100;
              break;
            case 'Uzun gol':
              culculFinal = 130;
              break;
            case 'Ayder':
              culculFinal = 170;
              break;
            case 'Rize':
              culculFinal = 160;
              break;
            case 'Giresun':
              culculFinal = 160;
              break;
            case 'ondu':
              culculFinal = 200;
              break;
            default:
              100;
              break;
          }
          break;
        case 'Çaykara':
          switch (tourismCityName) {
            case 'Uzungöl':
              culculFinal = 80;
              break;
            case 'Trabzon':
              culculFinal = 190;
              break;
            case 'Ayder':
              culculFinal = 170;
              break;
            case 'Rize':
              culculFinal = 140;
              break;
            case 'ondu':
              culculFinal = 220;
              break;
            default:
              100;
              break;
          }
          break;
        default:
          null;
          break;
      }
    }
    else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Morocco") {
      culculFinal = fareAmont + 0.20 * 10 + 2 * 10.00;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Sudan") {
      culculFinal = fareAmont * 450 + 2 * 450;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Saudi Arabia") {
      culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 4.70 * 3.75;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Qatar") {
      culculFinal = fareAmont * 3.64 + 5.75 * 3.64;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Libya") {
      culculFinal = fareAmont * 4.80 + 4 * 4.80;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Kuwait") {
      culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 6.88 * 0.32;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "Iraq") {
      culculFinal = fareAmont + 0.20 + 1.20 + 5.73;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        userInfo.country0 == "United Arab Emirates") {
      culculFinal = fareAmont * 3.67 + 6.30 * 3.67;
    } else {
      culculFinal = 200.0;
    }
    return culculFinal.truncate();
  }
}
