import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:key_board_app/cubits/for_image_find_text/img_find_text_state.dart';
import 'package:key_board_app/logic/kril_to_latin.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/navigators/goto.dart';
import 'package:key_board_app/pages/reading_audio_page.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:key_board_app/services/http_service.dart';
import 'package:path_provider/path_provider.dart';

class ImgFindTextCubit extends Cubit<ImgFindTextState> {
  BuildContext context;

  ImgFindTextCubit({required this.context})
      : super(ImgFindTextState(textScanning: false));

  File? imageFile;
  String? path;
  InputImage? inputImage;

  succesLoaded() async {
    AudioModel? audioModel = await getImageTextAndPushReadingBookPage();

    if (audioModel == null) {
      emit(ImgFindTextState(textScanning: false,error: true));
      return;
    }

    emit(ImgFindTextState(textScanning: true,error: false,audioModel: audioModel));
  }

  /// #matnlarni audioga aylantirib beradi
  Future<AudioModel?> getImageTextAndPushReadingBookPage() async {
    String? text = await getImage();
    print("Text: $text ///");
    Uint8List? uint8list;

    if (text != null) {
      uint8list = await Network.getAudioFromApi(text);

      if (uint8list == null) {
        print("Print: $uint8list");
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${text.hashCode.toString()}.mp3').create();
      await file.writeAsBytes(uint8list);
      state.audioModel = AudioModel(name: text.hashCode.toString(), path: file.path);

     GOTO.pushRpUntil(context, ReadingPage(listAudio: [state.audioModel!], startOnIndex: 0));
    }
  }

  /// #rasmli file olib beradi
  Future<String?> getImage() async {
    final file = (await ImagePicker().pickImage(source: ImageSource.camera));
    if (file != null) {
      imageFile = File(file.path);
      state.textScanning = true;
      String? textImage = await getRecognisedText(imageFile!);
      return textImage;
    }
    return null;
  }

  /// #rasmdagi matnlarni olib beradi
  Future<String?> getRecognisedText(File imageFile) async {
    inputImage = InputImage.fromFilePath(imageFile.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage!);
    state.scanningText = "";

    print(recognizedText.blocks[0].lines[0].text + "=======");
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        state.scanningText = state.scanningText! + line.text + "\n";
      }
    }
    // print(state.scanningText! + "///");
    state.textScanning = false;
    String imageText = await checkLatin(state.scanningText!);
    return imageText;
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
}
