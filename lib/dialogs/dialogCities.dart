import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:splashbloc/localData/dbCountries.dart';
import 'package:splashbloc/models/countrydbModel.dart';
import 'package:splashbloc/models/countrylistModel.dart';

class DialogCities extends StatefulWidget {
  @override
  _DialogCitiesState createState() => _DialogCitiesState();
}

class _DialogCitiesState extends State<DialogCities> {
  DatabaseCountry db = DatabaseCountry();
  List<CountryDbModel> dialogDbCountries;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(widget?.dbCountries?.length == 0){
    //   _saveCities();
    db.getAllCountries().then((value) {
      setState(() {
        if (value.length == 0) {
          _saveCities();
        } else {
          dialogDbCountries = value;
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
    CountryDbModel country1 = CountryDbModel('Kuala Lumpur');
    CountryDbModel country2 = CountryDbModel('Johor Bahru');
    CountryDbModel country3 = CountryDbModel('George Town');
    db.saveData(country1);
    db.saveData(country2);
    db.saveData(country3);
  }

  dialogContent(BuildContext context) {
    List<CountryListModel> countryList = [];
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
                  json.map((e) => CountryListModel.fromJson(e)).toList();
              debugPrint('dialog db countries: $dialogDbCountries');
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: countryList.length,
                itemBuilder: (BuildContext context, int index) {
                  debugPrint('country name'+ dialogDbCountries.any((element) => element.country == countryList[index].city).toString());
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
                          Icon(dialogDbCountries.any((element) => element.country == countryList[index].city)?Icons.add_circle:Icons.add)
                        ],
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
