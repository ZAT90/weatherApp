import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splashbloc/localData/dbCities.dart';
import 'package:splashbloc/models/citydbModel.dart';
import 'package:splashbloc/models/citylistModel.dart';

class DialogCities extends StatefulWidget {
  @override
  _DialogCitiesState createState() => _DialogCitiesState();
}

class _DialogCitiesState extends State<DialogCities> {
  DatabaseCity db = DatabaseCity();
  List<CityDbModel> dialogDbCities;
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
        //key: key,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context));
  }

  dialogContent(BuildContext context) {
    List<CityListModel> cityList = [];
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future:
                    DefaultAssetBundle.of(context).loadString('assets/my.json'),
                builder: (context, snapshot) {
                  List json =
                      snapshot.data != null ? jsonDecode(snapshot.data) : [];
                  if (json.length == 0) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  cityList =
                      json.map((e) => CityListModel.fromJson(e)).toList();
                  return Flexible(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: cityList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (cityList[index].city == 'Kuala Lumpur') {
                                debugPrint('do not change');
                              } else if (cityList[index].city ==
                                  'Johor Bahru') {
                                debugPrint('do not change');
                              } else if (cityList[index].city ==
                                  'George Town') {
                                debugPrint('do not change');
                              } else {
                                debugPrint(cityList[index].city);
                                saveOrDelete(cityList[index].city);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: index == 0 ? 5 : 0),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 5,
                                      child: Text(
                                        cityList[index].city,
                                        style: TextStyle(
                                            color:
                                                cityList[index].city ==
                                                            'Kuala Lumpur' ||
                                                        cityList[index].city ==
                                                            'George Town' ||
                                                        cityList[index].city ==
                                                            'Johor Bahru'
                                                    ? Colors.grey
                                                    : Colors.black),
                                      )),
                                  Icon(
                                    dialogDbCities.any((element) =>
                                            element.city ==
                                            cityList[index].city)
                                        ? Icons.check_circle_outline
                                        : Icons.add,
                                    color:
                                        cityList[index].city ==
                                                    'Kuala Lumpur' ||
                                                cityList[index].city ==
                                                    'George Town' ||
                                                cityList[index].city ==
                                                    'Johor Bahru'
                                            ? Colors.grey
                                            : Colors.green,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                /*...*/
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ));
  }

  saveOrDelete(String city) {
    CityDbModel cityDbModel = dialogDbCities
        .firstWhere((element) => city == element.city, orElse: () => null);
    debugPrint('citymodel $cityDbModel');
    if (cityDbModel == null) {
      CityDbModel countryadd = CityDbModel(city);
      db.saveData(countryadd);
      setState(() {
        debugPrint('setstate called');
      });
    } else {
      db.deleteData(cityDbModel);
    }

    setData();
  }
}

DatabaseCity _saveCities(DatabaseCity db) {
  CityDbModel country1 = CityDbModel('Kuala Lumpur');
  CityDbModel country2 = CityDbModel('Johor Bahru');
  CityDbModel country3 = CityDbModel('George Town');
  db.saveData(country1);
  db.saveData(country2);
  db.saveData(country3);

  return db;
}
