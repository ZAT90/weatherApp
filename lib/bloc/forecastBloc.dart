import 'package:rxdart/rxdart.dart';
import 'package:splashbloc/models/weatherForecast.dart';
import 'package:splashbloc/persistence/repository.dart';

class ForecastBloc {
  Repository _repository = Repository();

  final _forecastFetcher = PublishSubject<List<WeatherList>>();

  Stream<List<WeatherList>> get currentForecast => _forecastFetcher.stream;

  fetchForecasts(latitude, longitude) async {
    List<WeatherList> forecastList =
        await _repository.fetchForecasts(latitude, longitude);
    _forecastFetcher.sink.add(forecastList);
  }

  dispose() {
    _forecastFetcher.close();
  }
}

final forecastbloc = ForecastBloc();
