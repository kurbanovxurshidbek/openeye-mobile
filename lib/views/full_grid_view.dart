import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/logic/check_internet.dart';
import 'package:key_board_app/pages/convert_reading_audio_page.dart';
import 'package:key_board_app/pages/settings_page.dart';
import 'package:key_board_app/pages/take_image.dart';
import 'package:key_board_app/views/dialogs.dart';
import '../navigators/goto.dart';
import '../pages/list_of_part_books.dart';
import '../pages/list_of_saved_books.dart';
import 'bottom_sheets.dart';

//home page item on tap fucntions
void itemGridOnPressed(
    ItemOfFullGrid itemOfGridHome, BuildContext context) async {
  bool isConnect = await hasNetwork();
  switch (itemOfGridHome) {
    case ItemOfFullGrid.KeybordItem:
      _goingToAndroidAndIosSetting();
      break;
    case ItemOfFullGrid.TextInImageItem:
      {
        if (isConnect) {
          goToImage(context);
        } else {
          connectionDialog(context);
        }
      }
      break;
    case ItemOfFullGrid.BookRecordingItem:
      {
        if (isConnect) {
          GOTO.push(context, ConvertAndReadingPage());
        } else {
          connectionDialog(context);
        }
        // //  return;

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

//! going to android and ios settings
void _goingToAndroidAndIosSetting() async {
  const plotform = MethodChannel("flutter.native/helper");

  String result = "";
  try {
    result = await plotform.invokeMethod("helloNativeCode");
  } catch (e) {
    print(e);
  }
  print(result);
}

void goToImage(BuildContext context) async {
  await availableCameras().then((value) {
    print("Value: $value");
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => TakeImagePage(cameras: value)));
  });
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
