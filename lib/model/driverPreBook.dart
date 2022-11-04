// this class for store data driver from preBook database

class DriverPreBook {
  late String carBrand;
  late String carColor;
  late String carInside;
  late String carModel;
  late String carOutSide;
  late String carOutSide1;
  late String carType;
  late String city;
  late String country;
  late String driverImage;
  late String firstName;
  late String idPlack;
  late String lastName;
  late String phoneNumber;
  late String userId;
  DriverPreBook(
      this.country,
      this.carType,
      this.city,
      this.userId,
      this.carModel,
      this.carColor,
      this.carBrand,
      this.lastName,
      this.firstName,
      this.phoneNumber,
      this.carOutSide,
      this.carOutSide1,
      this.carInside,
      this.driverImage,
      this.idPlack);
  DriverPreBook.fromMap(Map<String, dynamic> map) {
    country = map["country"];
    carType = map["carType"];
    city = map["city"];
    userId = map["userId"];
    carModel = map["carModel"];
    carColor = map["carColor"];
    carBrand = map["carBrand"];
    lastName = map["lastName"];
    firstName = map["firstName"];
    phoneNumber = map["phoneNumber"];
    carOutSide = map["carOutSide"];
    carOutSide1 = map["carOutSide1"];
    carInside = map["carInside"];
    driverImage = map["driverImage"];
    idPlack = map["idNo"];
  }
}
