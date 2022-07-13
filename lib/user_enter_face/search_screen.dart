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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var uuid = const Uuid();

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController whereEdit = TextEditingController();
  CustomWidget customWidget = CustomWidget();
  List<PlacePredictions> placePredictionsList = [];
  final GetUrl _getUrl = GetUrl();
  @override
  Widget build(BuildContext context) {
    final addressModle = Provider.of<AppData>(context).pickUpLocation;
    return WillPopScope(
    onWillPop: ()async=>true,
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.close),
              backgroundColor:const Color(0xFFFFD54F),
                onPressed: ()=>Navigator.pop(context)),
              body: SingleChildScrollView(
                  child: Column(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
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
                    style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
                    cursorColor: const Color(0xFFFFD54F),
                    decoration:  InputDecoration(
                  fillColor: const Color(0xFFFFD54F),
                  border: InputBorder.none,
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 35,
                  ),
                  iconColor: Colors.white,
                  hintText: AppLocalizations.of(context)!.whereTo,
                  contentPadding: const EdgeInsets.all(10.0),
                  hintStyle: const TextStyle(
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
              placePredictionsList.isNotEmpty
                  ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return PredictionsTitle(
                          predictions: placePredictionsList[index]);
                    },
                    separatorBuilder: (context, index) =>
                        customWidget.customDivider(),
                    itemCount: placePredictionsList.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                    )
                  : Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                      child: Lottie.asset('assets/lf30_editor_jobovyne.json',
                          height: 350, width: 350)),
                    )
            ],
          ))),
        ),
      ),
    );
  }

// place api
  void finedPlace(
      String placeName, Address addressModle, BuildContext context) async {
    if (placeName.length > 1) {
      final autocompleteUrl = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=${uuid.v4()}&location=${addressModle.latitude},${addressModle.longitude}&radius=${50.000}");
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
            predictions.placeId, context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            const Icon(
              Icons.location_on_outlined,
              size: 25,
              color: Color(0xFFFFD56F),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(predictions.mainText,
                      style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis)),
                  Container(
                    child: Text(predictions.secondaryText,
                        style: const TextStyle(
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
    );
  }
}
