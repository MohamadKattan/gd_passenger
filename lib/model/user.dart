// this class for save datauser from user collection id/phone/image/firstname/lastname

class Users {
  String first_name;
  String last_name;
  String user_id;
  String phone_number;
  String image_profile;
  String email;
  Users(
      {required this.first_name,
      required this.last_name,
      required this.user_id,
      required this.image_profile,
      required this.phone_number,
      required this.email});

  static Users fromMap(Map<String, dynamic> map) {
    return Users(
        first_name: map["first_name"],
        last_name: map["last_name"],
        user_id: map["user_id"],
        image_profile: map["image_profile"],
        phone_number: map["phone_number"],
        email: map["email"]);
  }
}
