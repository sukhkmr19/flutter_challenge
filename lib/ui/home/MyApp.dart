import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/constants/AppContstant.dart';
import 'package:flutter_app_challenge/ui/view/MyHomePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        // Define the default Font Family
        fontFamily: 'Montserrat',
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
        ),
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}
