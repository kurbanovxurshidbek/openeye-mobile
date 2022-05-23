import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_board_app/cubits/convertion/convertion_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import '../../logic/kril_to_latin.dart';
import '../../models/audio_model.dart';
import '../../services/file_picker_service.dart';
import '../../services/http_service.dart';

class ConvertionCubit extends Cubit<ConvertionState> {
  BuildContext context;
  ConvertionCubit({required this.context})
      : super(ConvertionState(isConverting: false));

  succesLoaded() async {
    AudioModel? audioModel = await getPdfTextAndPushReadingBookPage();

    if (audioModel == null) {
      emit(ConvertionState(isConverting: false, error: true));
      return;
    }

    emit(ConvertionState(
        isConverting: false, error: false, audioModel: audioModel));
  }

  //get pdf file and convert to text and goto push reading page
  Future<AudioModel?> getPdfTextAndPushReadingBookPage() async {
    List<String>? list = await getTextFromPdfAndName(context);
    Uint8List? uint8list;

    if (list != null) {
      uint8list = await Network.getAudioFromApi(list[0]);

      if (uint8list == null) {
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${list[1]}.mp3').create();
      await file.writeAsBytes(uint8list);
      AudioModel audioModel = AudioModel(name: list[1], path: file.path);

      return audioModel;
    }
  }

  Future<List<String>?> getTextFromPdfAndName(BuildContext context) async {
    //Load an existing PDF document.
    List<String>? list = await readDocumentData();
    print(list);

    if (list != null) {
      String text = await getPDFtext(list[0]);
      if (text.contains("в") ||
          text.contains("б") ||
          text.contains("я") ||
          text.contains("ю") ||
          text.contains("ь") ||
          text.contains("ж") ||
          text.contains("э")) {
        text = await toLatin(text);
      }
      return [text, list[1]];
    }

//

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
}
