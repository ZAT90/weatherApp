import 'package:flutter/material.dart';
import 'package:splashbloc/bloc/currentlocationBloc.dart';
import 'package:splashbloc/bloc/forecastBloc.dart';
import 'package:splashbloc/components/customAppbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:splashbloc/models/locationModel.dart';
import 'package:splashbloc/models/weatherForecast.dart';

class CurrentLocation extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String currentLatitude = '';
  String currentLongitude = '';
  getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLatitude = position.latitude.toString();
      currentLongitude = position.longitude.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    // = new LocationModel();
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
                child: CircularProgressIndicator(),
              );
            }
            LocationModel currentLocationModel =
                snapshot.data != null ? snapshot.data : LocationModel();
            return CustomAppBar(
              locationData: currentLocationModel,
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: buildSilverappChild(currentLocationModel, currentLatitude, currentLongitude)),
              // end of streambuilder
              titleWidget: Column(
                children: <Widget>[
                  Text(currentLocationModel.name),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                          '${temperature(currentLocationModel.main.temp)}°C')),
                ],
              ),
            );
          }),
    );
  }

  
}

Column buildSilverappChild(LocationModel currentlocdata, String currentLatitude, String currentLongitude) {
    //if (currentLatitude.isNotEmpty) {
    forecastbloc.fetchForecasts(currentLatitude, currentLongitude);
    // }
    return Column(
      children: <Widget>[
        buildValues('Pressure', currentlocdata.main.pressure.toString()),
        SizedBox(
          height: 15,
        ),
        buildValues('Humidity', currentlocdata.main.humidity.toString()),
        SizedBox(
          height: 15,
        ),
        buildValues('Wind speed', currentlocdata.wind.speed.toString()),
        SizedBox(
          height: 15,
        ),
        buildValues('description', currentlocdata.weather[0].description),
        SizedBox(
          height: 15,
        ),
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
                              width: MediaQuery.of(context).size.width - 40,
                              color: Color(0xFFB74093),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      DateTime.parse(headerDate).day ==
                                              DateTime.now().day
                                          ? 'today'
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
                                          listItems(context, 'Humidity', true),
                                          listItems(context, 'Min.Temp.', true),
                                          listItems(context, 'Max. Temp', true),
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
                                              '${temperature(sublist[index].main.temp)}°C',
                                              false),
                                          //SizedBox(width: 10),
                                          listItems(
                                              context,
                                              sublist[index]
                                                  .main
                                                  .humidity
                                                  .toString(),
                                              false),
                                          // SizedBox(width: 5),
                                          listItems(
                                              context,
                                              '${temperature(sublist[index].main.tempMin)}°C',
                                              false),
                                          listItems(
                                              context,
                                              '${temperature(sublist[index].main.tempMax)}°C',
                                              false)
                                          // Text(sublist[index].dtTxt.substring(1,forecastList[index].dtTxt.indexOf(' ')) ),
                                        ],
                                      ),
                                    ],
                                  );
                                  //return null;
                                }),
                          )
                        ],
                      );
                    }),
              );
            })
      ],
    );
  }

Container listItems(BuildContext context, String retVal, bool isHeader) {
  return Container(
      width: MediaQuery.of(context).size.width / 6,
      child: Text(
        retVal,
        style: TextStyle(color: isHeader ? Colors.white : Colors.blueGrey),
        textAlign: TextAlign.center,
      ));
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
  return temp.toStringAsFixed(2).toString();
}
