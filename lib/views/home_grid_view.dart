import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_board_app/constants/enums.dart';

//home page item on tap fucntions
void itemGridOnPressed(ItemOfGridHome itemOfGridHome) {
  switch (itemOfGridHome) {
    case ItemOfGridHome.KeybordItem:
      androidOrIos();
      break;
    case ItemOfGridHome.TextInImageItem:
      {}
      break;
    case ItemOfGridHome.BookRecordingItem:
      {}
      break;
    case ItemOfGridHome.SettingItem:
      {}
      break;
  }
}

// going to android and ios settings
androidOrIos() async {
  if (Platform.isAndroid) {
    String _counter = "";

    final plotform = MethodChannel("flutter.native/helper");

    String result = "";
    try {
      result = await plotform.invokeMethod("helloNativeCode");
    } catch (e) {
      print(e);
    }
    print(result);
  } else if (Platform.isIOS) {}
}

Widget itemGrid(String title, Icon icon, ItemOfGridHome itemOfGridHome) {
  return GestureDetector(
    onTap: () {
      itemGridOnPressed(itemOfGridHome);
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.white24),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    ),
  );
}
