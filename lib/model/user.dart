// this class for save datauser from user collection id/phone/image/firstname/lastname

class Users {
  String firstName;
  String lastName;
  String userId;
  String phoneNumber;
  String imageProfile;
  String email;
  String country;
  String status;
  bool update;
  String country0;
  Users(
      {required this.firstName,
      required this.lastName,
      required this.userId,
      required this.imageProfile,
      required this.phoneNumber,
      required this.email,
      required this.country,
      required this.status,
      required this.update,
      required this.country0});

  static Users fromMap(Map<String, dynamic> map) {
    return Users(
      firstName: map["firstName"],
      lastName: map["lastName"],
      userId: map["userId"],
      imageProfile: map["imageProfile"],
      phoneNumber: map["phoneNumber"],
      email: map["email"],
      country: map["country"],
      country0: map["country0"],
      status: map["status"],
      update: map["update"],
    );
  }
}
