import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:splashbloc/models/countrydbModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseCountry {
  static final DatabaseCountry _instance = new DatabaseCountry.internal();
  factory DatabaseCountry() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDbCountries();
    return _db;
  }

  DatabaseCountry.internal();

  initDbCountries() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "weatherCountries.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    debugPrint('table has been created');
    await db.execute('CREATE TABLE countries (id INTEGER PRIMARY KEY,country TEXT)');
  }

  Future<int> saveData(CountryDbModel countryDbModel)async {
      var dbClient = await db;
      int res = await dbClient.insert("countries", countryDbModel.toMap());
      debugPrint('data has been saved to table');
      debugPrint('res length: $res');
      return res;
    }
  
    Future<void> deleteData(CountryDbModel countryDbModel) async {
      // Get a reference to the database.
      final dbClient = await db;
  
      // Update the given Dog.
      await dbClient.delete(
        'countries',
        // Ensure that the Dog has a matching id.
        where: "id = ?",
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [countryDbModel.id],
      );
      debugPrint('data has been deleted lah');
    }
  
    Future<List<CountryDbModel>> getAllCountries() async {
      var dbClient = await db;
      String sql;
      sql = "SELECT * FROM countries";
  
      var result = await dbClient.rawQuery(sql);
      if (result.length == 0) return null;
  
      List<CountryDbModel> list = result.map((item) {
        return CountryDbModel.fromMap(item);
      }).toList();
  
      print('all country results'+result.toString());
      return list;
    }
  }
  

