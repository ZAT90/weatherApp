import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  Localemain _main;
  Localemain get main => _main;

  void initAll() {
    _main = Localemain(Map<String, String>.from(_data['main']));
  }
}

class Localemain {
  final Map<String, String> _data;
  Localemain(this._data);

  String get sample => _data["sample"];
  String get save => _data["save"];
  String get pressure => _data["pressure"];
  String get humidity => _data["humidity"];
  String get wind_speed => _data["wind_speed"];
  String get description => _data["description"];
  String get today => _data["today"];
  String get upcoming_forecast => _data["upcoming_forecast"];
  String get curr_location => _data["curr_location"];
  String get featured_cities => _data["featured_cities"];
  String get selected_cities => _data["selected_cities"];
  String get change_lang => _data["change_lang"];
  String get please_pull => _data["please_pull"];
  String get settings => _data["settings"];
  String get temp => _data["temp"];
  String get temp_min => _data["temp_min"];
  String get temp_max => _data["temp_max"];
}
