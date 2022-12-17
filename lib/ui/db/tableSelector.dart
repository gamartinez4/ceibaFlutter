import 'package:ceiba_flutter/models/dbModels/userDb.dart';

class TableSelector{

  String dataBaseName() => "usuarios.db";
  String dataBaseAlias() => "usuarios";
  String dataBaseCreateQuery() => "CREATE TABLE usuarios(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, email TEXT)";
  UserDb constructor(Map<String,dynamic> map)=>
      UserDb(
        id: map["id"], 
        name: map["name"], 
        phone: map["phone"],
        email: map["email"]
      );
}