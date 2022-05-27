import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/cubits/for_image_find_text/img_find_text_cubit.dart';
import 'package:key_board_app/pages/convertion_page.dart';
import 'package:key_board_app/pages/settings_page.dart';
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
        BlocProvider.of<ImgFindTextCubit>(context).getImage();
      }
      break;
    case ItemOfFullGrid.BookRecordingItem:
      {
        GOTO.push(context, ConvertionPage());
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

Widget itemGrid(String title, ItemOfFullGrid itemOfGridHome,
    BuildContext context) {
  return GestureDetector(
    onTap: () {
      itemGridOnPressed(itemOfGridHome, context);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.black12,width: 1,
        //
        // ),
color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            offset: const Offset(
              0.0,
              3.0,
            ),
            blurRadius: 3.0,
            spreadRadius:0.1,
          ), //BoxShadow
          BoxShadow(
            color: Colors.transparent,
            offset: const Offset(0.0, 0.0),
            // blurRadius: 1.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ),
      child:Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 23),
          )),
    ),
  );
}
