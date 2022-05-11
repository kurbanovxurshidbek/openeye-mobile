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

        // ...add your text style
      ),
    );
  }
}
