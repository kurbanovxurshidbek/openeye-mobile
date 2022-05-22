import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/cubits/for_image_find_text/img_find_text_cubit.dart';
import 'package:key_board_app/cubits/for_read_audio_book/reading_audio_book_cubit.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/pages/settings_page.dart';
import 'package:path_provider/path_provider.dart';
import '../navigators/goto.dart';
import '../pages/list_of_saved_books.dart';
import '../pages/reading_audio_page.dart';
import '../services/file_picker_service.dart';
import '../services/http_service.dart';
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
        getPdfTextAndPushReadingBookPage(context);
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

//get pdf file and convert to text and goto push reading page
getPdfTextAndPushReadingBookPage(BuildContext context) async {
  List<String>? list = await FilePickerService.getTextFromPdfAndName(context);
  Uint8List? uint8list;

  if (list != null) {
    uint8list = await Network.getAudioFromApi(list[0]);

    if (uint8list != null) {
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${list[1]}.mp3').create();
      await file.writeAsBytes(uint8list);
      AudioModel audioModel = AudioModel(name: list[1], path: file.path);

      GOTO.push(
          context,
          ReadingPage(
            listAudio: [audioModel],
            startOnIndex: 0,
          ));
    }
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

Widget itemGrid(String title, Icon icon, ItemOfFullGrid itemOfGridHome,
    BuildContext context) {
  return GestureDetector(
    onTap: () {
      itemGridOnPressed(itemOfGridHome, context);
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
