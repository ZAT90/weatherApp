

import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/models/weatherForecast.dart';

import 'apiProvider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<LocationModel> fetchCurrentWeather(latitude,longitude) => appApiProvider.fetchCurrentWeather(latitude,longitude);
  Future<List<WeatherList>> fetchForecasts(latitude,longitude) => appApiProvider.fetchForecasts(latitude,longitude);
    Future<LocationModel> fetchFeaturedWeather(cityName) => appApiProvider.fetchFeaturedCityWeather(cityName);

}