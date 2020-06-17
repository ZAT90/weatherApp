import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/models/weatherForecast.dart';

class ApiProvider {
  //Client client = Client();
  final _baseUrl = "http://api.openweathermap.org/";
  final apiKey = 'ca6d482c6b63d05abc5dd780a764b58f';
  var dio = Dio();

  Future<LocationModel> fetchCurrentWeather(
      String latitude, String longitude) async {
    final response = await dio.get(_baseUrl +
        'data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');
    // debugPrint('response data :${response.data}');

    // if (response.statusCode == 200) {
    return LocationModel.fromJson(response.data);
  }

  Future<LocationModel> fetchFeaturedCityWeather(String cityName) async {
    final response =
        await dio.get(_baseUrl + 'data/2.5/weather?q=$cityName&appid=$apiKey');
    return LocationModel.fromJson(response.data);
  }

  Future<List<WeatherList>> fetchForecasts(
      String latitude, String longitude) async {
    final response = await dio.get(_baseUrl +
        'data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey');
    WeatherForecast weatherForecast = WeatherForecast.fromJson(response.data);
    return weatherForecast.weatherList;
  }
}
