import 'package:ceiba_flutter/models/user.dart';
import 'package:ceiba_flutter/ui/db/tableSelector.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dbModels/userDb.dart';

class SqlDb{

  static Future<Database> _openDb({dynamic template}) async{
    return openDatabase(
      join(await getDatabasesPath(), template.dataBaseName()),
      onCreate: (db, version) => db.execute(template.dataBaseCreateQuery()),
      version: 1
    );
  }
  
  static Future<int> insert(dynamic object, {dynamic template}) async{
    Database database = await _openDb(template: template);
    return database.insert(template.dataBaseAlias(), object.toMap(),conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  static insertAll(List<dynamic> objects, {dynamic template}){
    return objects.forEach((element) => insert(element, template: template));
  }

  static Future<List<dynamic>> dbFullQuery( {dynamic template}) async {
    Database database = await _openDb(template: template);
    final List<Map<String,dynamic>> mapObject = await database.query(template.dataBaseAlias());
    return List<dynamic>.generate(mapObject.length, (i) => template.constructor(mapObject[i]));
  }
}