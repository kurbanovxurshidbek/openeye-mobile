import 'package:key_board_app/models/audio_model.dart';

class ImgFindTextState {
  bool textScanning = false;
  bool error;
  String? scanningText;
  AudioModel? audioModel;

  ImgFindTextState({this.scanningText,this.error = false,required this.textScanning,this.audioModel});
}
