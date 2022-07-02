// this class for response data from json apiPlace

class PlacePredictions {
  late String placeId;
  late String mainText;
  late String secondaryText;
  PlacePredictions(this.mainText, this.secondaryText, this.placeId);

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    placeId = json["place_id"];
    mainText = json["structured_formatting"]["main_text"];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}
