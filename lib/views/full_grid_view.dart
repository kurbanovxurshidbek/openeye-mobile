// import 'package:camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/pages/convertion_page.dart';
import 'package:key_board_app/pages/settings_page.dart';
import 'package:key_board_app/pages/take_image.dart';
import '../navigators/goto.dart';
import '../pages/list_of_saved_books.dart';
import 'bottom_sheets.dart';

//home page item on tap fucntions
void itemGridOnPressed(ItemOfFullGrid itemOfGridHome, BuildContext context) {
  switch (itemOfGridHome) {
    case ItemOfFullGrid.KeybordItem:
      androidOrIos();
      break;
    case ItemOfFullGrid.TextInImageItem:
      {
        goToImage(context);
      }
      break;
    case ItemOfFullGrid.BookRecordingItem:
      {
        GOTO.push(
            context,
            ConvertionPage(
              isCamera: false,
            ));
      }
      break;
    case ItemOfFullGrid.SettingItem:
      {
        GOTO.push(context, SettingsPage());
      }
      break;
    case ItemOfFullGrid.Voice:
      {
        voiceChooseSheet(context);
      }
      break;
    case ItemOfFullGrid.Lang:
      {
        showBottomS(context, inSettings: true);
      }
      break;
    case ItemOfFullGrid.ListOfSavedAudioBooks:
      {
        GOTO.push(context, SavedBooksPage());
      }
      break;
  }
}

void goToImage(BuildContext context) async {
  await availableCameras().then((value) {
    print("Value: $value");
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => TakeImagePage(cameras: value)));
  });
}

// going to android and ios settings
androidOrIos() async {
  String _counter = "";

  final plotform = const MethodChannel("flutter.native/helper");

  String result = "";
  try {
    result = await plotform.invokeMethod("helloNativeCode");
  } catch (e) {
    print(e);
  }
  print(result);
}

Widget itemGrid(
    String title, ItemOfFullGrid itemOfGridHome, BuildContext context) {
  return GestureDetector(
    onTap: () {
      itemGridOnPressed(itemOfGridHome, context);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        boxShadow: const [
          BoxShadow(
            color: Colors.transparent,
            offset: Offset(
              0.0,
              3.0,
            ),
            blurRadius: 3.0,
            spreadRadius: 0.1,
          ), //BoxShadow
          BoxShadow(
            color: Colors.transparent,
            offset: Offset(0.0, 0.0),
            // blurRadius: 1.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ),
      child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 23),
          )),
    ),
  );
}
