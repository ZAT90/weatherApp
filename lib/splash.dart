import 'package:flutter/material.dart';
import 'package:splashbloc/homepage.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
      return new SplashScreen(
      seconds: 10,
      navigateAfterSeconds:  HomePage(),
      imageBackground: AssetImage('assets/images/yahoo.png'),
      loaderColor: Colors.transparent,
    );
  }
  }