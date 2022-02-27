// this class for userdata

class User {
  late String first_name;
  late String last_name;
  late String user_id;
  late String phone_number;
  late String image_profile;
  late String email;
  User(
      {required this.first_name,
      required this.last_name,
      required this.user_id,
      required this.image_profile,
      required this.phone_number,
      required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        user_id: map["user_id"],
        first_name: map["first_name"],
        last_name: map["last_name"],
        phone_number: map["phone_number"],
        image_profile: map["image_profile"],
        email: map["email"]);
  }
}
