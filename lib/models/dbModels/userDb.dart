import 'dart:convert';

class UserDb {
  int id;
  String name;
  String phone;
  String email;

  UserDb({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email
    };
  }

  @override
  String toString(){
    return 'UserDb{id: $id, name: $name, phone: $phone, email: $email}';
  }

}
