import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
import 'package:gd_passenger/my_provider/placeDetails_drop_provider.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  cur =  Provider.of<AppData>(context,listen: false).pickUpLocation.placeId;
    final  dro =  Provider.of<PlaceDetailsDropProvider>(context,listen: false).dropOfLocation.placeId;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("$cur"),
            Text("$dro"),
          ],
        ),
      ),
    );
  }

}
