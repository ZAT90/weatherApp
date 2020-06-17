import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:splashbloc/localData/dbCities.dart';
import 'package:splashbloc/models/citydbModel.dart';
import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/persistence/apiProvider.dart';

class SelectedCities extends StatefulWidget {
  @override
  _SelectedCitiesState createState() => _SelectedCitiesState();
}

class _SelectedCitiesState extends State<SelectedCities> {
  DatabaseCity db = DatabaseCity();
  List<CityDbModel> dialogDbCities = [];
  @override
  void initState() {
    super.initState();
    // if(widget?.dbCountries?.length == 0){
    //   _saveCities();
    db.getAllCountries().then((value) {
      setState(() {
        if (value == null || value.length == 0) {
          _saveCities(db);
        } else {
          dialogDbCities = value;
        }
      });
    });
    //}
  }

  String cityName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('selected cities'),
      ),
      body: Center(
        child: CarouselSlider(
          items: dialogDbCities.length > 0
              ? dialogDbCities.map((cities) {
                  return Builder(
                    builder: (BuildContext context) {
                      ApiProvider appApiProvider = ApiProvider();
                      return FutureBuilder<LocationModel>(
                          future: appApiProvider
                              .fetchFeaturedCityWeather(cities.city),
                          builder: (context, snapshot) {
                            LocationModel locationModel = snapshot.data != null
                                ? snapshot.data
                                : LocationModel();
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(color: Colors.green),
                                child: Text(
                                  '${locationModel.name}',
                                  style: TextStyle(fontSize: 16.0),
                                ));
                          });
                      //});
                    },
                  );
                }).toList()
              : [],
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height / 1.5,
            enableInfiniteScroll: false,
          ),
        ),
      ),
    );
  }
}

void _saveCities(DatabaseCity db) {
  CityDbModel country1 = CityDbModel('Kuala Lumpur');
  CityDbModel country2 = CityDbModel('Johor Bahru');
  CityDbModel country3 = CityDbModel('George Town');
  db.saveData(country1);
  db.saveData(country2);
  db.saveData(country3);
}
