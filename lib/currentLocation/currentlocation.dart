import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splashbloc/bloc/currentlocationBloc.dart';
import 'package:splashbloc/bloc/forecastBloc.dart';
import 'package:splashbloc/components/customAppbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/models/weatherForecast.dart';
import 'package:splashbloc/persistence/locDelegate.dart';

class CurrentLocation extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation>
    with WidgetsBindingObserver {
  String currentLatitude = '';
  String currentLongitude = '';
  bool locationEnabled = false;
  getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLatitude = position.latitude.toString();
      currentLongitude = position.longitude.toString();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkLocation();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkLocation();
    }
  }

  checkLocation() async {
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    setState(() {
      locationEnabled = isLocationEnabled;
    });
    if (!isLocationEnabled) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No location access'),
            content: const Text('Please turn on your location'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  AndroidIntent intent = new AndroidIntent(
                    action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                  );
                  intent.launch();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      getPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentLatitude.isNotEmpty) {
      currentLocationBloc.fetchCurrentWeather(
          currentLatitude, currentLongitude);
    }
    return Scaffold(
      body: StreamBuilder<LocationModel>(
          stream: currentLocationBloc.currentLocationWeather,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Lottie.asset('assets/lottie/loading.json',
                    width: 200, height: 200),
              );
            }
            LocationModel currentLocationModel =
                snapshot.data != null ? snapshot.data : LocationModel();
            return CustomAppBar(
              locationData: currentLocationModel,
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: buildSilverappChild(context, currentLocationModel,
                      currentLatitude, currentLongitude)),
              // end of streambuilder
              marginTitle: MediaQuery.of(context).size.height / 6,
              titleWidget: Flexible(
                child: Column(
                  children: <Widget>[
                    Text(currentLocationModel.name),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                            '${temperature(currentLocationModel.main.temp)}')),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

Container buildSilverappChild(
    BuildContext context,
    LocationModel currentlocdata,
    String currentLatitude,
    String currentLongitude) {
  forecastbloc.fetchForecasts(currentLatitude, currentLongitude);
  return Container(
    margin: EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size.width - 40,
    color: Color(0xD2691E),
    child: Column(
      children: <Widget>[
        buildValues(LangLibrary.main(context).pressure,
            currentlocdata.main.pressure.toString()),
        SizedBox(
          height: 15,
        ),
        buildValues(LangLibrary.main(context).humidity,
            currentlocdata.main.humidity.toString()),
        SizedBox(
          height: 15,
        ),
        buildValues(LangLibrary.main(context).wind_speed,
            currentlocdata.wind.speed.toString()),
        SizedBox(
          height: 15,
        ),
        buildValues(LangLibrary.main(context).description,
            currentlocdata.weather[0].description),
        SizedBox(
          height: 15,
        ),
        Text(LangLibrary.main(context).upcoming_forecast,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        StreamBuilder<List<WeatherList>>(
            stream: forecastbloc.currentForecast,
            builder: (context, snapshot) {
              List<WeatherList> forecastList =
                  snapshot.data != null ? snapshot.data : [];
              List dates = forecastList
                  .map((e) => e.dtTxt.substring(0, e.dtTxt.indexOf(' ')))
                  .toList();
              List mappedDates = dates.toSet().toList();
              return Flexible(
                child: ListView.builder(
                    itemCount: mappedDates.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      String headerDate = mappedDates[index];
                      return Column(
                        children: <Widget>[
                          Container(
                              // width: MediaQuery.of(context).size.width - 40,
                              color: Color(0xFFB74093),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      DateTime.parse(headerDate).day ==
                                              DateTime.now().day
                                          ? LangLibrary.main(context).today
                                          : headerDate,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: <Widget>[
                                          listItems(context, 'Time', true),
                                          listItems(context, 'Temp.', true),
                                          listItems(context, 'Expected', true),
                                          listItems(context, 'Min.Temp', true),
                                          listItems(context, 'Max.Temp', true),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                      color: Colors.black,
                                    ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: forecastList
                                    .where((e) =>
                                        e.dtTxt.substring(
                                            0,
                                            forecastList[index]
                                                .dtTxt
                                                .indexOf(' ')) ==
                                        headerDate)
                                    .toList()
                                    .length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  List<WeatherList> sublist = forecastList
                                      .where((e) =>
                                          e.dtTxt.substring(
                                              0,
                                              forecastList[index]
                                                  .dtTxt
                                                  .indexOf(' ')) ==
                                          headerDate)
                                      .toList();
                                  List<String> time =
                                      sublist[index].dtTxt.split(' ');
                                  String retVal = time[1];
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          listItems(context, retVal, false),
                                          listItems(
                                              context,
                                              '${temperature(sublist[index].main.temp)}',
                                              false),
                                          listItemIcon(
                                              context,
                                              sublist[index].weather[0].icon,
                                              false),
                                          listItems(
                                              context,
                                              '${temperature(sublist[index].main.tempMin)}',
                                              false),
                                          listItems(
                                              context,
                                              '${temperature(sublist[index].main.tempMax)}',
                                              false)
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          )
                        ],
                      );
                    }),
              );
            })
      ],
    ),
  );
}

Container listItems(BuildContext context, String retVal, bool isHeader) {
  return Container(
      width: MediaQuery.of(context).size.width / 6,
      padding: EdgeInsets.only(top: 20),
      child: Text(
        retVal,
        style: TextStyle(color: isHeader ? Colors.white : Colors.blueGrey),
        textAlign: TextAlign.center,
      ));
}

Container listItemIcon(BuildContext context, String retVal, bool isHeader) {
  return Container(
      width: MediaQuery.of(context).size.width / 6,
      child: Image.network('http://openweathermap.org/img/wn/$retVal@2x.png'));
}

Row buildValues(String title, String value) {
  return Row(
    children: <Widget>[
      Text(
        '$title :',
        style: TextStyle(fontSize: 20),
      ),
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Text(
          value,
          style: TextStyle(fontSize: 20),
        ),
      ),
    ],
  );
}

String temperature(double temperature) {
  double temp = temperature / 10;
  return temp.toStringAsFixed(2).toString() + '°C';
}
