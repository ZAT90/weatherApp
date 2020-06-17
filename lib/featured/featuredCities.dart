import 'package:flutter/material.dart';
import 'package:splashbloc/bloc/featureBloc.dart';
import 'package:splashbloc/components/customAppbar.dart';
import 'package:splashbloc/currentLocation/currentlocation.dart';
import 'package:splashbloc/models/locationModel.dart';

class FeaturedCities extends StatefulWidget {
  @override
  _FeaturedCitiesState createState() => _FeaturedCitiesState();
}

class _FeaturedCitiesState extends State<FeaturedCities> {
  String chosenCity = 'Kuala Lumpur';
  @override
  Widget build(BuildContext context) {
    // = new LocationModel();
    // if (currentLatitude.isNotEmpty) {
    featuredLocationBloc.fetchFeaturedWeather(chosenCity);
    // }
    return Scaffold(
      body: StreamBuilder<LocationModel>(
          stream: featuredLocationBloc.featuredLocationWeather,
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
                child: buildSilverappChild(
                    currentLocationModel,
                    currentLocationModel.coord.lat.toString(),
                    currentLocationModel.coord.lon.toString()),
                //child: buildSilverappChild(currentLocationModel)
              ),
              // end of streambuilder
              titleWidget: Column(
                children: <Widget>[
                  //Text(currentLocationModel.name),
                  new DropdownButton<String>(
                    items: <String>[
                      'Kuala Lumpur',
                      'George Town',
                      'Johor Bahru'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        chosenCity = val;
                      });
                    },
                    value: chosenCity,
                    dropdownColor: Colors.blue,
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    child: Text(
                        '${temperature(currentLocationModel.main.temp)}°C'),
                    //'${temperature(currentLocationModel.main.temp)}°C')),
                  )
                ],
              ),
            );
          }),
    );
  }
}
