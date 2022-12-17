import 'package:ceiba_flutter/models/user.dart';
import 'package:ceiba_flutter/ui/db/tableSelector.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dbModels/userDb.dart';

class SqlDb{

  static dynamic tableSelector;

  static setTemplate(dynamic template){
    tableSelector = template;
  }

  static Future<Database> _openDb() async{
    return openDatabase(
      join(await getDatabasesPath(), tableSelector.dataBaseName()),
      onCreate: (db, version) => db.execute(tableSelector.dataBaseCreateQuery()),
      version: 1
    );
  }
  
  static Future<int> insert(dynamic object) async{
    Database database = await _openDb();
    return database.insert(tableSelector.dataBaseAlias(), object.toMap(),conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  static insertAll(List<dynamic> objects){
    return objects.forEach((element) => insert(element));
  }

  static Future<List<dynamic>> dbFullQuery() async {
    Database database = await _openDb();
    final List<Map<String,dynamic>> mapObject = await database.query(tableSelector.dataBaseAlias());
    return List<dynamic>.generate(mapObject.length, (i) => tableSelector.constructor(mapObject[i]));
  }
}