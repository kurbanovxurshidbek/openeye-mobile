import 'package:flutter/material.dart';

class GOTO {
  // navigator push
  static void push(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }

  // navigator pop
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  // navigator push replacement
  static void pushRP(BuildContext context, Widget route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }

  //  ... add your navigator

}
