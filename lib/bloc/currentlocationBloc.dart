import 'package:rxdart/rxdart.dart';
import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/persistence/repository.dart';


class CurrentLocationBloc {
  Repository _repository = Repository();

  final _currentLocationFetcher = PublishSubject<LocationModel>();

  Stream<LocationModel> get currentLocationWeather => _currentLocationFetcher.stream;

  fetchCurrentWeather(latitude, longitude) async {
    LocationModel weatherResponse = await _repository.fetchCurrentWeather(latitude, longitude);
    _currentLocationFetcher.sink.add(weatherResponse);
  }

  dispose() {
    _currentLocationFetcher.close();
  }
}

final currentLocationBloc = CurrentLocationBloc();