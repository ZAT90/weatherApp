import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashbloc/featured/featuredCities.dart';
import 'package:splashbloc/homepage.dart';
import 'package:splashbloc/settings/settings.dart';
import 'package:splashbloc/splash.dart';
import 'package:splashbloc/persistence/locDelegate.dart';
import 'package:splashbloc/localData/preferenceManager.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String appLanguage = '';
  Future initalizePreferences() async{
    PreferenceManager.init(await SharedPreferences.getInstance());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initalizePreferences().then((value){
      if(PreferenceManager.instance.langCode.isEmpty){
        
        setState(() {
          appLanguage = 'en';
        });
      }else{
        setState(() {
          appLanguage = PreferenceManager.instance.langCode;
        });
        
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //locale: Locale(),
      locale: appLanguage.isEmpty?Locale('en'):Locale(appLanguage),
      localizationsDelegates: [
        const LocDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:
          supportedLanguageMap.keys.map((key) => Locale(key)).toList(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: SplashPage(),
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => HomePage(),
        '/featured': (context) => FeaturedCities(),
        '/settings': (context) => Settings(),
      },
    );
  }
}
