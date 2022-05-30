import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:key_board_app/cubits/convertion/convertion_state.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import '../../logic/kril_to_latin.dart';
import '../../models/audio_model.dart';
import '../../services/http_service.dart';

class ConvertionCubit extends Cubit<ConvertionState> {
  BuildContext context;
  ConvertionCubit({required this.context}) : super(ConvertionState(isConverting: false));

  File? imageFile;
  String? path;
  InputImage? inputImage;
  String imgText = "";

  succesLoaded(bool isCamera) async {
    AudioModel? audioModel = await getPdfTextAndPushReadingBookPage(isCamera);

    if (audioModel == null) {
      emit(ConvertionState(isConverting: false, error: true));
      return;
    }

    emit(ConvertionState(
        isConverting: false, error: false, audioModel: audioModel));
  }

  //get pdf file and convert to text and goto push reading page
  Future<AudioModel?> getPdfTextAndPushReadingBookPage(bool isCamera) async {
    Uint8List? uint8list;

    if(isCamera == false) {
      List<String>? list = await getTextFromPdfAndName(context);
      if (list != null) {
        uint8list = await Network.getAudioFromApi(list[0]);

        if (uint8list == null) {
          return null;
        }

        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/${list[1]}.mp3').create();
        await file.writeAsBytes(uint8list);
        AudioModel audioFileModel = AudioModel(name: list[1], path: file.path);

        return audioFileModel;
      }
    } else {

      String? text = await getImage();
      if (text != null) {
        uint8list = await Network.getAudioFromApi(text);

        if (uint8list == null) {
          print("Print: $uint8list");
          return null;
        }

        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/${text.hashCode.toString()}.mp3').create();
        await file.writeAsBytes(uint8list);
        AudioModel audioImageModel = AudioModel(name: text.hashCode.toString(), path: file.path);
        return audioImageModel;
      }
    }
  }

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

  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
  }

  showD(BuildContext context, String str) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text(str),
          ),
        );
      },
    );
  }

  Future<List<String>?> readDocumentData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    emit(ConvertionState(
      isConverting: true,
      error: false,
    ));
    if (result != null) {
      File file = File(result.files.first.path!);

      return [file.path, result.files.first.name];
    } else {
      return null;
    }
  }






  /// #rasmli file olib beradi
  Future<String?> getImage() async {
    final file = (await ImagePicker().pickImage(source: ImageSource.camera));
    emit(ConvertionState(
      isConverting: true,
      error: false,
    ));
    if (file != null) {
      imageFile = File(file.path);
      state.isConverting = true;
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
    imgText = "";

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
