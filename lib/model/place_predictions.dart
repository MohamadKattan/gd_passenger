// this class for respons data from json apiPlace

class PlacePredictions {
  late String place_id;
  late String main_text;
  late String secondary_text;
  PlacePredictions(this.main_text, this.secondary_text, this.place_id);
  PlacePredictions.fromJson(Map<String, dynamic> json) {
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }
}
