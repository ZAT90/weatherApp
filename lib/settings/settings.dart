import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashbloc/localData/preferenceManager.dart';
import 'package:splashbloc/persistence/locDelegate.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String chosenLang = 'English';
  Future initalizePreferences() async {
    PreferenceManager.init(await SharedPreferences.getInstance());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initalizePreferences().then((value) {
      setState(() {
        chosenLang = PreferenceManager.instance.langCode;
        if (PreferenceManager.instance.langCode == 'ms') {
          chosenLang = 'Malay';
        } else {
          chosenLang = 'English';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LangLibrary.main(context).settings),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Center(
                //color: Colors.red,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Text(
                          LangLibrary.main(context).change_lang,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    DropdownButton<String>(
                      items: <String>['English', 'Malay'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          chosenLang = val;
                        });
                      },
                      value: chosenLang,
                      dropdownColor: Colors.blue,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  //Navigator.pop(context);
                  if (chosenLang == 'English') {
                    PreferenceManager.instance.langCode = 'en';
                  } else if (chosenLang == 'Malay') {
                    PreferenceManager.instance.langCode = 'ms';
                  }
                  Phoenix.rebirth(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ));
  }
}
