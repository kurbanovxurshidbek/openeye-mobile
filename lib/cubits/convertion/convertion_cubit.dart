import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:key_board_app/cubits/convertion/convertion_state.dart';
import 'package:key_board_app/logic/check_latin.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:path_provider/path_provider.dart';
import '../../logic/kril_to_latin.dart';
import '../../models/audio_model.dart';
import '../../services/http_service.dart';

class ConvertionCubit extends Cubit<ConvertionState> {
  BuildContext context;

  ConvertionCubit({required this.context})
      : super(ConvertionState(isConverting: false));

  File? imageFile;
  String? path;
  InputImage? inputImage;
  String imgText = "";

  /// #get pdf file and convert to text and goto push reading page
  succesLoadedPdfText() async {
    AudioModel? audioModel = await getPdfTextAndPushReadingBookPage();

    if (audioModel == null) {
      emit(ConvertionState(isConverting: false, error: true));
      return ;
    }

    emit(ConvertionState(
        isConverting: false, error: true, audioModel: audioModel));
  }

  /// #text to speech
  Future<AudioModel?> getPdfTextAndPushReadingBookPage() async {
    Uint8List? uint8list;

    List<String>? list = await getTextFromPdfAndName(context);
    if (list != null) {
      List<String> txt = await Network.getContent(list[0]);
      // uint8list = await Network.getAudioFromApi(txt);
      print("Uint8List: $uint8list");

      if (uint8list == null) {
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${list[1]}.mp3').create();
      await file.writeAsBytes(uint8list);
      AudioModel audioFileModel = AudioModel(name: list[1], path: file.path);
      print("AudioModel: $audioFileModel");

      return audioFileModel;
    }
  }

  /// #chacke latin
  Future<List<String>?> getTextFromPdfAndName(BuildContext context) async {
    //Load an existing PDF document.
    List<String>? list = await readDocumentData();
    print(list);

    if (list != null) {
      String text = await getPDFtext(list[0]);
      String? countryCode = HiveDB.loadLangCode();

      if (countryCode != null && countryCode == "uz") {
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

      return [text, list[1]];
    }

    return null;
  }

  /// #get pdf from text
  Future<String> getPDFtext(String path) async {
    String text = "";
    if (path.isNotEmpty) {
      try {
        text = (await Network.MULTIPART(path))!;
        print("PDF Text : $text");
      } on SocketException catch (e) {
        print("No internet.....");
      }
    }
    return text;
  }

  /// #get pdf from device file
  Future<List<String>?> readDocumentData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ["pdf"]);


    emit(ConvertionState(
      isConverting: true,
      error: false,
    ));
    if (result != null && result.paths.toString().contains("pdf")) {
      File file = File(result.files.first.path!);

      return [file.path, result.files.first.name];
    } else {
      return null;
    }
  }





  /// #convert to text and goto push convert page
  succesLoadedImageText(String images) async {
    emit(ConvertionState(isConverting: true));
    AudioModel? audioModel = await getTextFromImageAndSendRequesd(images);

    if (audioModel == null) {
      emit(ConvertionState(error: true, isConverting: false));
      return;
    }

    print("AudioModel: $audioModel");
    emit(ConvertionState(audioModel: audioModel,error: false,isConverting: false));
  }

  /// #text to speech
  Future<AudioModel?> getTextFromImageAndSendRequesd(String images) async {
    Uint8List? uint8list;
    String? text;

    if(images != null) {
      text = await getRecognisedText(images);
      print("Text: $text");
      if(text != null) {
        // uint8list = await Network.getAudioFromApi([text]);
        print("Uint8List: $uint8list");
      }
    }

    if(uint8list == null) {
      return null;
    }

    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${text.hashCode.toString()}.mp3').create();
    await file.writeAsBytes(uint8list);
    AudioModel audioImageModel = AudioModel(name: text.hashCode.toString(), path: file.path);
    return audioImageModel;

  }

  /// #get text from image
  Future<String?> getRecognisedText(String imageFile) async {
    inputImage = InputImage.fromFilePath(imageFile);
    print(inputImage);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage!);
    String imgText = "";

    print(recognizedText.blocks[0].lines[0].text + "=======");
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        imgText = imgText + line.text + "\n";
      }
    }
    // print(state.scanningText! + "///");
    String imageText = await checkLatin(imgText);
    return imageText;
  }
}
