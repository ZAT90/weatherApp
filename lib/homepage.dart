import 'package:flutter/material.dart';
import 'package:splashbloc/currentLocation/currentlocation.dart';
import 'package:splashbloc/dialogs/dialogCities.dart';
import 'package:splashbloc/featured/featuredCities.dart';
import 'package:splashbloc/localData/dbCities.dart';
import 'package:splashbloc/persistence/locDelegate.dart';
import 'package:splashbloc/selectedCities/selectedCities.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseCity db = DatabaseCity();
  int _cIndex = 0;
  bool dialogClosed = false;
  List _pages = [
    CurrentLocation(), // current location data
    FeaturedCities(), // KL, JB and GeorgeTown
    SelectedCities(), // all the cities added by the user. by default has 3 man cities
  ];

  @override
  void initState() {
    super.initState();
    db.initDbCities();
  }

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_cIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white60,
        currentIndex: _cIndex,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            title: new Text(LangLibrary.main(context).curr_location),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              title: new Text(LangLibrary.main(context).featured_cities)),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: new Text(LangLibrary.main(context).selected_cities,
                style: TextStyle(color: Colors.black)),
          ),
        ],
        onTap: (index) {
          _incrementTab(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogCities(
                    onClosed: (dialogClosed) {
                      setState(() {
                        dialogClosed = dialogClosed;
                      });
                    },
                  ));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
