import 'package:rxdart/rxdart.dart';
import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/persistence/repository.dart';

class FeaturedLocationBloc {
  Repository _repository = Repository();

  final _featuredLocationFetcher = PublishSubject<LocationModel>();

  Stream<LocationModel> get featuredLocationWeather =>
      _featuredLocationFetcher.stream;

  fetchFeaturedWeather(String city) async {
    LocationModel weatherResponse =
        await _repository.fetchFeaturedWeather(city);
    _featuredLocationFetcher.sink.add(weatherResponse);
  }

  dispose() {
    _featuredLocationFetcher.close();
  }
}

final featuredLocationBloc = FeaturedLocationBloc();
