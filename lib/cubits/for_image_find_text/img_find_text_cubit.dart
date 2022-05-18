 import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:key_board_app/cubits/for_image_find_text/img_find_text_state.dart';


class ImgFindTextCubit extends Cubit<ImgFindTextState> {
  BuildContext context;
  ImgFindTextCubit({required this.context}) : super(ImgFindTextState(textScanning: false));

  File? imageFile;
  String? path;
  InputImage? inputImage;

  void getImage()async{

    final file  = (await ImagePicker().pickImage(source: ImageSource.camera));
    if(file !=null){
      imageFile = File(file.path);
      state.textScanning = true;
      getRecognisedText(imageFile!);
    }
  }

  void getRecognisedText(File imageFile) async {

    inputImage = InputImage.fromFilePath(imageFile.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText =
    await textDetector.processImage(inputImage!);
    state.scanningText = "";
    print(recognizedText.blocks[0].lines[0].text + "=======");
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        state.scanningText = state.scanningText! + line.text + "\n";
      }
    }
    state.scanningText;
    print(state.scanningText);
    state.textScanning = false;
  }


}
