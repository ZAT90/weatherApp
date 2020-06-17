import 'package:flutter/material.dart';
import 'package:splashbloc/currentLocation/currentlocation.dart';
import 'package:splashbloc/dialogs/dialogCities.dart';
import 'package:splashbloc/featured/featuredCities.dart';
import 'package:splashbloc/localData/dbCities.dart';
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
  List _pages = [
    CurrentLocation(),
    FeaturedCities(),
    SelectedCities(),
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

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _pages[_cIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white60,
        currentIndex: _cIndex,
        selectedItemColor: Colors.green,
        //type: BottomNavigationBarType.shifting ,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            title: new Text('Current location'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              title: new Text('Featured cities')),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            title: new Text('Selected Cities',
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
              builder: (BuildContext context) => DialogCities());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
