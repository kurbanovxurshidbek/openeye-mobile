
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:key_board_app/navigators/goto.dart';
import 'package:key_board_app/pages/reading_audio_page.dart';
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
  static Stream<AudioModel?> getPdfTextAndPushReadingBookPage(
       bool isCamera, List<String> _list) async* {
       Uint8List? uint8list;

    List<String>? list = await getTextFromPdfAndName(_list);
    if (list != null) {
      List<String> partList = await getContent(list[0]);
      for (int i = 0; i < partList.length; i++) {
        print(partList[i]);
        String? countryCode = HiveDB.loadLangCode();

        if (countryCode != null && countryCode == "uz") {
          if (partList[i].contains("В") ||
              partList[i].contains("б") ||
              partList[i].contains("я") ||
              partList[i].contains("ю") ||
              partList[i].contains("ь") ||
              partList[i].contains("ж") ||
              partList[i].contains("э")) {
            partList[i] = await toLatin(partList[i]);
          }
        }
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
        print(audioFileModel);
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

  // static Future<List<String>?> readDocumentData() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     File file = File(result.files.first.path!);
  //
  //     return [file.path, result.files.first.name];
  //   } else {
  //     return null;
  //   }
  // }

  // /// #rasmli file olib beradi
  // Future<String?> getImage() async {
  //   final file = (await ImagePicker().pickImage(source: ImageSource.camera));
  //   // emit(ConvertionState(
  //   //   isConverting: true,
  //   //   error: false,
  //   // ));
  //   if (file != null) {
  //     imageFile = File(file.path);
  //     // state.isConverting = true;
  //     String? textImage = await getRecognisedText(imageFile!);
  //     return textImage;
  //   }
  //   return null;
  // }

  /// #rasmdagi matnlarni olib beradi
  // Future<String?> getRecognisedText(File imageFile) async {
  //   inputImage = InputImage.fromFilePath(imageFile.path);
  //   final textDetector = GoogleMlKit.vision.textRecognizer();
  //   RecognizedText recognizedText =
  //       await textDetector.processImage(inputImage!);
  //   imgText = "";

  //   print(recognizedText.blocks[0].lines[0].text + "=======");
  //   for (TextBlock block in recognizedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       imgText = imgText + line.text + "\n";
  //     }
  //   }
  //   // print(state.scanningText! + "///");
  //   String imageText = await checkLatin(imgText);
  //   return imageText;
  // }

  /// #matinlarni lotin harflariga tekshiradi
  static Future<String> checkLatin(String? text) async {
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

  static Future<List<String>> getContent(String content) async {
    List<String> list = content.split(" ");
    list.retainWhere((item) => item.toString().isNotEmpty);
    String str = "";
    List<String> listofContent = [];
    for (int i = 0; i < list.length; i++) {
      str += list[i] + " ";
      if (i % 1000 == 0 && i != 0) {
        listofContent.add(str);
        return listofContent;
      }
    }
    listofContent.add(str);
    return listofContent;
  }
}
