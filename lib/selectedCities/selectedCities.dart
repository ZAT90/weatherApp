import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:splashbloc/currentLocation/currentlocation.dart';
import 'package:splashbloc/localData/dbCities.dart';
import 'package:splashbloc/models/citydbModel.dart';
import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/persistence/apiProvider.dart';
import 'package:splashbloc/persistence/locDelegate.dart';

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
    setData();
  }

  setData() {
    db.getAllCountries().then((value) {
      if (value == null || value.length == 0) {
        _saveCities(db);
      } else {
        setState(() {
          dialogDbCities = value;
        });
      }
    });
  }

  Future<Null> handleRefresh() async {
    setData();
    return null;
  }

  String cityName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LangLibrary.main(context).selected_cities),
      ),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Text(
                      LangLibrary.main(context).please_pull,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 30),
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
                                      LocationModel locationModel =
                                          snapshot.data != null
                                              ? snapshot.data
                                              : LocationModel();
                                      if(locationModel == null){
                                        return CircularProgressIndicator();
                                      }
                                      return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                              color: Colors.green),
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                  Colors.green,
                                                  Colors.blue,
                                                  Colors.indigo
                                                ])),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    '${locationModel.name}',
                                                    style: TextStyle(
                                                        fontSize: 24.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                locationModel.weather != null &&
                                                        locationModel.weather
                                                                .length >
                                                            0
                                                    ? Image.network(
                                                        'http://openweathermap.org/img/wn/${locationModel.weather[0].icon}@2x.png')
                                                    : Container(),
                                                Expanded(
                                                  child:
                                                      locationModel.name != null ?dataGrid(locationModel):Container(),
                                                )
                                              ],
                                            ),
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
                      initialPage: 2,
                      enlargeCenterPage: true,

                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GridView dataGrid(LocationModel locationModel) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        buildText(
            LangLibrary.main(context).temp,
            temperature(
                locationModel.main.temp != null ? locationModel.main.temp : '')),
        buildText(
            LangLibrary.main(context).pressure,
            locationModel.main != null
                ? locationModel.main.pressure.toString()
                : ''),
        buildText(
            LangLibrary.main(context).temp_min,
            locationModel.main != null
                ? temperature(
                locationModel.main != null ? locationModel.main.tempMin : '')
                : ''),
        buildText(
            LangLibrary.main(context).temp_max,
            locationModel.main != null
                ? temperature(
                locationModel.main != null ? locationModel.main.tempMax : '')
                : ''),
        buildText(
            LangLibrary.main(context).humidity,
            locationModel.main != null
                ? locationModel.main.humidity.toString()
                : ''),
        buildText(
            LangLibrary.main(context).wind_speed,
            locationModel.wind != null
                ? locationModel.wind.speed.toString()
                : ''),
      ],
    );
  }

  Column buildText(String title, String data) {
    return Column(
      children: <Widget>[
        Text('$title :'),
        Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(data, style: TextStyle(color: Colors.white))),
      ],
    );
  }

  void _saveCities(DatabaseCity db) {
    CityDbModel country1 = CityDbModel('Kuala Lumpur');
    CityDbModel country2 = CityDbModel('Johor Bahru');
    CityDbModel country3 = CityDbModel('George Town');
    db.saveData(country1);
    db.saveData(country2);
    db.saveData(country3);
    setData();
  }
}
