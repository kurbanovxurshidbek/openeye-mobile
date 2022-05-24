import 'package:flutter/material.dart';

class GOTO {
  // navigator push
  static void push(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context1) => route));
  }

  // navigator pop
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  // navigator pop until
  static void popUT(BuildContext context) {
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  // navigator push replacement
  static void pushRP(BuildContext context, Widget route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }

  // navigator push replacement and until
  static void pushRpUntil(BuildContext context, Widget route) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return route;
    }), (route) => false);
  }

  //  ... add your navigator

}
