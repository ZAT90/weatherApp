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
    // if(widget?.dbCountries?.length == 0){
    //   _saveCities();
    db.getAllCountries().then((value) {
      setState(() {
        if (value == null ||value.length == 0) {
          _saveCities();
        } else {
          dialogDbCities = value;
        }
      });
    });
    //}
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

  _saveCities() async {
    CityDbModel country1 = CityDbModel('Kuala Lumpur');
    CityDbModel country2 = CityDbModel('Johor Bahru');
    CityDbModel country3 = CityDbModel('George Town');
    db.saveData(country1);
    db.saveData(country2);
    db.saveData(country3);
  }

  dialogContent(BuildContext context) {
    List<CityListModel> countryList = [];
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString('assets/my.json'),
            builder: (context, snapshot) {
              List json =
                  snapshot.data != null ? jsonDecode(snapshot.data) : [];
              if (json.length == 0) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              countryList =
                  json.map((e) => CityListModel.fromJson(e)).toList();
              debugPrint('dialog db countries: $dialogDbCities');
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: countryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      debugPrint(countryList[index].city);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 5, child: Text(countryList[index].city)),
                          Icon(dialogDbCities.any((element) => element.city == countryList[index].city)?Icons.check_circle_outline:Icons.add)
                        ],
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
