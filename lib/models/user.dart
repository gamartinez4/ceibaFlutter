import 'dart:convert';

class User {
  int id;
  String name;
  String phone;
  String email;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
  );
}
