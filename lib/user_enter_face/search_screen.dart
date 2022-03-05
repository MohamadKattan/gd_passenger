import 'package:flutter/material.dart';
import 'package:gd_passenger/config.dart';
import 'package:gd_passenger/model/address.dart';
import 'package:gd_passenger/model/place_predictions.dart';
import 'package:gd_passenger/my_provider/app_data.dart';
import 'package:gd_passenger/repo/api_srv_place.dart';
import 'package:gd_passenger/tools/get_url.dart';
import 'package:gd_passenger/widget/divider_box_.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController whereEdit = TextEditingController();
  CustomWidget customWidget = CustomWidget();
  List<PlacePredictions> placePredictionsList = [];
  GetUrl _getUrl = GetUrl();
  @override
  Widget build(BuildContext context) {
    final addressModle = Provider.of<AppData>(context).pickUpLocation;
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Container(
                    child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 10.0),
                child: TextField(
                  maxLength: 25,
                  onChanged: (val) {
                    finedPlace(val, addressModle, context);
                  },
                  controller: whereEdit,
                  showCursor: true,
                  mouseCursor: MouseCursor.uncontrolled,
                  autofocus: true,
                  cursorWidth: 4.0,
                  enabled: true,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                  cursorColor: Color(0xFFFFD54F),
                  decoration: InputDecoration(
                    fillColor: Color(0xFFFFD54F),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    ),
                    iconColor: Colors.white,
                    hintText: "Where to?",
                    contentPadding: EdgeInsets.all(10.0),
                    hintStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0),
                    hoverColor: Color(0xFFFFD54F),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            placePredictionsList.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return PredictionsTitle(
                              predictions: placePredictionsList[index]);
                        },
                        separatorBuilder: (context, index) =>
                            customWidget.customDivider(),
                        itemCount: placePredictionsList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                        child: Lottie.asset('assets/lf30_editor_jobovyne.json',
                            height: 350, width: 350)),
                  )
          ],
        )))),
      ),
    );
  }

// place api
  void finedPlace(
      String placeName, Address addressModle, BuildContext context) async {
    if (placeName.length > 1) {
      final autocompleteUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&key=${mapKey}&sessiontoken=${uuid.v4()}&location=${addressModle.latitude},${addressModle.longitude}&radius=${50.000}");
      final response = await _getUrl.getUrlMethod(autocompleteUrl);
      if (response == "failed") {
        return;
      } else {
        if (response["status"] == "OK") {
          final predictions = response["predictions"];
          final predictionsList = (predictions as List)
              .map((e) => PlacePredictions.fromJson(e))
              .toList();
          setState(() {
            placePredictionsList = predictionsList;
          });
        }
      }
    }
  }
}

// list of result searching
class PredictionsTitle extends StatelessWidget {
  final PlacePredictions predictions;

  const PredictionsTitle({Key? key, required this.predictions})
      : super(key: key);
  static DropPlaceDetails dropPlaceDetails = DropPlaceDetails();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: GestureDetector(
        onTap: () => dropPlaceDetails.getPlaceAddressDetails(
            predictions.place_id, context),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Icon(
                Icons.location_on_outlined,
                size: 25,
                color: Color(0xFFFFD56F),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(predictions.main_text,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis)),
                    Container(
                      child: Text(predictions.secondary_text,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                              overflow: TextOverflow.ellipsis)),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
