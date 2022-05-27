import 'package:flutter/material.dart';

class ThemeOf {
  static ThemeData ligth() {
    return ThemeData(
      textTheme:  TextTheme(
        // use    Text( "hello",  style: Theme.of(context).textTheme.headline1,),
        headline1: const TextStyle(
            fontSize: 18,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 49, 49, 49),
            fontStyle: FontStyle.normal),
        //for language change text
        headline2: const TextStyle(
            fontSize: 25,
            fontFamily: "Serif",
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontStyle: FontStyle.normal),

        headline3: const TextStyle(
            fontSize: 25,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 219, 219, 219),
            fontStyle: FontStyle.normal),
        headline4:  TextStyle(
            fontSize: 45,
            fontFamily: "Serif",
            fontWeight: FontWeight.normal,
            color: Colors.blueGrey.shade600,
            fontStyle: FontStyle.normal),
        headline5: const TextStyle(
            fontSize: 60,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 219, 219, 219),
            fontStyle: FontStyle.normal),
        caption: const TextStyle(
            fontSize: 20,
            fontFamily: "Serif",
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(209, 219, 219, 219),
            fontStyle: FontStyle.normal),

        headline6: TextStyle(
            fontSize: 35,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade600,
            fontStyle: FontStyle.normal),

        bodyText1: const TextStyle(
            fontSize: 20,
            fontFamily: "Serif",
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontStyle: FontStyle.normal),
        // ...add your text style
      ),
    );
  }
}
