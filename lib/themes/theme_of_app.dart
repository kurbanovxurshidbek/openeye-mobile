import 'package:flutter/material.dart';

class ThemeOf {
  static ThemeData ligth() {
    return ThemeData(
      textTheme: const TextTheme(
        // use    Text( "hello",  style: Theme.of(context).textTheme.headline1,),
        headline1: TextStyle(
            fontSize: 18,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 49, 49, 49),
            fontStyle: FontStyle.normal),
        //for language change text
        headline2: TextStyle(
            fontSize: 25,
            fontFamily: "Serif",
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 219, 219, 219),
            fontStyle: FontStyle.normal),

        headline3: TextStyle(
            fontSize: 25,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 219, 219, 219),
            fontStyle: FontStyle.normal),
        headline4: TextStyle(
            fontSize: 45,
            fontFamily: "Serif",
            fontWeight: FontWeight.normal,
            color: Color(0xFF0e3554),
            fontStyle: FontStyle.normal),
        headline5: TextStyle(
            fontSize: 60,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 219, 219, 219),
            fontStyle: FontStyle.normal),
        caption: TextStyle(
            fontSize: 20,
            fontFamily: "Serif",
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(209, 219, 219, 219),
            fontStyle: FontStyle.normal),

        headline6: TextStyle(
            fontSize: 35,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            fontStyle: FontStyle.normal),

        bodyText1: TextStyle(
            fontSize: 20,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(129, 0, 0, 0),
            fontStyle: FontStyle.normal),
        // ...add your text style
      ),
    );
  }
}
