import 'package:audioplayers/audioplayers.dart';
import 'package:key_board_app/constants/enums.dart';

import '../../models/audio_model.dart';

class ConvertAndReadingState {
  bool isLoading;
  List<AudioModel> listOfAudio;
  Duration? currentPosition;
  Duration? duration;
  bool? isPlaying;
  AudioPlayer? audioPlayer;
  int index;
  bool isConverting;
  Errors error;
  int total;
  bool cancel;

  ConvertAndReadingState(
      {required this.isLoading,
      required this.index,
      required this.total,
      required this.isConverting,
      required this.error,
      required this.cancel,
      required this.currentPosition,
      required this.duration,
      required this.audioPlayer,
      required this.listOfAudio,
      required this.isPlaying});
}
