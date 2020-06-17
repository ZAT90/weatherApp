import 'package:splashbloc/localData/dbCities.dart';
import 'package:splashbloc/models/citydbModel.dart';

class SaveCity {
  
  void _saveCities(DatabaseCity db) {
  CityDbModel country1 = CityDbModel('Kuala Lumpur');
  CityDbModel country2 = CityDbModel('Johor Bahru');
  CityDbModel country3 = CityDbModel('George Town');
  db.saveData(country1);
  db.saveData(country2);
  db.saveData(country3);
}
}