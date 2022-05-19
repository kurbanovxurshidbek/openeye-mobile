import 'package:flutter/material.dart';

class MainAligmentState {
  MainAxisAlignment columnAligment;
  bool bottomUp;
  bool isSpeaking;
  int chackedItem;
  String? lanhCode;

  MainAligmentState(
      {required this.columnAligment,
      required this.bottomUp,
      required this.isSpeaking,
      required this.chackedItem,
      this.lanhCode});
}
