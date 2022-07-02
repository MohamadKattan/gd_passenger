// this class for save data all trip driver

class TripHistory {
  late String pickAddress;
  late String dropAddress;
  late String trip;
  TripHistory(this.pickAddress, this.dropAddress,this.trip);

  TripHistory.fromMap(Map<String, dynamic> map) {
    pickAddress = map["pickAddress"];
    dropAddress = map["dropAddress"];
    trip = map["trip"];
  }
}
