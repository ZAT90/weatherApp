

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const USER_LANGUAGE = "USER_LANGUAGE";

  static PreferenceManager _instance;

  static init(SharedPreferences pref) => _instance = PreferenceManager(pref);

  static PreferenceManager get instance => _instance;

  SharedPreferences pref;

  PreferenceManager(SharedPreferences pref) {
    this.pref = pref;
  }


  String get langCode => pref.get(USER_LANGUAGE) ?? "";
  set langCode(lngCd) => pref.setString(USER_LANGUAGE, lngCd);

}