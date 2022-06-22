
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:key_board_app/navigators/goto.dart';
import 'package:key_board_app/pages/convert_reading_audio_page.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:key_board_app/services/http_service.dart';
import 'package:path_provider/path_provider.dart';
import '../logic/kril_to_latin.dart';
import '../models/audio_model.dart';

class FileServises {
  File? imageFile;
  String? path;
  InputImage? inputImage;
  String imgText = "";
  //get pdf file and convert to text and goto push reading page
   bool cancel = false;
   int total = 0;


   Stream<AudioModel?> getPdfTextAndPushReadingBookPage(
       bool isCamera, List<String> _list) async* {
       Uint8List? uint8list;

    List<String>? list = await getTextFromPdfAndName(_list);
    if (list != null) {
      List<String> partList = await getContent(list[0]);
      String? countryCode = HiveDB.loadLangCode();


      for (int i = 0; i < partList.length; i++) {
                print("----------------------"+partList[i]);

                if(cancel){
                   break;
                }

        if (countryCode != null && countryCode == "uz") {
          if (partList[i].contains("В") ||
              partList[i].contains("б") ||
              partList[i].contains("я") ||
              partList[i].contains("ю") ||
              partList[i].contains("ь") ||
              partList[i].contains("ж") ||
              partList[i].contains("э")) {
            String str= await toLatin(partList[i]);

            partList[i] = str;
          }
        }
                print("+++++++++++++++++++++="+partList[i]);



        uint8list = await Network.getAudioFromApi(partList[i]);

        if (uint8list == null) {
          yield null;
          continue;
        }
        final tempDir = await getTemporaryDirectory();
        File file =
        await File('${tempDir.path}/${list[1]}-${i + 1}.mp3').create();
        await file.writeAsBytes(uint8list);
        AudioModel audioFileModel = AudioModel(name: list[1], path: file.path, index: i);
        yield audioFileModel;
      }
    }
  }

  static Future<List<String>?> getTextFromPdfAndName(
     List<String> list) async {
    //Load an existing PDF document.
    print(list);
    if (list != null) {
      String? text = await getPDFtext(list[0]);
      if (text == null) {
        return null;
      }




      return [text, list[1]];
    }

    return null;
  }

  static Future<String?> getPDFtext(String path) async {
    String? text;
    try {
      // api bilan qilinsin
      text = await Network.MULTIPART(path);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
  }


  /// #matinlarni lotin harflariga tekshiradi
   Future<String> checkLatin(String? text) async {
    String? countryCode = HiveDB.loadLangCode();

    if (text != null && countryCode != null && countryCode == "uz") {
      if (text.contains("в") ||
          text.contains("б") ||
          text.contains("я") ||
          text.contains("ю") ||
          text.contains("ь") ||
          text.contains("ж") ||
          text.contains("э")) {
        text = await toLatin(text);
      }
    }
    return text!;
  }

   Future<List<String>> getContent(String content) async {
    List<String> list = content.split(" ");
    list.retainWhere((item) => item.toString().isNotEmpty);
    String str = "";
    List<String> listofContent = [];
    for (int i = 0; i < list.length; i++) {
      str += list[i] + " ";
      if (i %  700 == 0 && i != 0) {
        total++;
        listofContent.add(str);

         str = "";
      }
    }
    listofContent.add(str);


    return listofContent;
  }


}
