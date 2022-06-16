import 'package:key_board_app/models/audio_model.dart';

class ConvertionState {
  bool isConverting;
  bool error;

  AudioModel? audioModel;
  ConvertionState(
      {required this.isConverting, this.error = false, this.audioModel});
}
