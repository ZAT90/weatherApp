import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:splashbloc/models/citydbModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseCity extends ChangeNotifier{
  static final DatabaseCity _instance = new DatabaseCity.internal();
  factory DatabaseCity() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDbCities();
    return _db;
  }

  DatabaseCity.internal();

  initDbCities() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "weatherCities.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    debugPrint('table has been created');
    await db.execute('CREATE TABLE cities (id INTEGER PRIMARY KEY,city TEXT)');
  }

  Future<int> saveData(CityDbModel cityDbModel)async {
      var dbClient = await db;
      int res = await dbClient.insert("cities", cityDbModel.toMap());
      debugPrint('data has been saved to table');
      debugPrint('res length: $res');
      return res;
    }
  
    Future<void> deleteData(CityDbModel cityDbModel) async {
      // Get a reference to the database.
      final dbClient = await db;
  
      // Update the given Dog.
      await dbClient.delete(
        'cities',
        // Ensure that the Dog has a matching id.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [cityDbModel.id],
      );
      debugPrint('data has been deleted lah');
    }
  
    Future<List<CityDbModel>> getAllCountries() async {
      var dbClient = await db;
      String sql;
      sql = "SELECT * FROM cities";
  
      var result = await dbClient.rawQuery(sql);
      if (result.length == 0) return null;
  
      List<CityDbModel> list = result.map((item) {
        return CityDbModel.fromMap(item);
      }).toList();
  
      print('all country results'+result.toString());
      this.notifyListeners();
      return list;
    }
  }
  

