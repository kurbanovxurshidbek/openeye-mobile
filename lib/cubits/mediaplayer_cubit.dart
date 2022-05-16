import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:key_board_app/cubits/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/speech_to_text_cubit.dart';
import '../views/bottom_sheets.dart';
import 'mediaplayer_state.dart';

class MediaplayerCubit extends Cubit<MediaPlayerState> {
  MediaplayerCubit() : super(MediaPlayerState(audioPlayer: AudioPlayer()));

  onComplatedAudioAndStart(BuildContext context) {
    int count = 1;

    startAudio(count);

    state.audioPlayer.onPlayerCompletion.listen((event) {
      count++;

      if (count == 4) {
        showBottomS(context);
        BlocProvider.of<MainaligmentCubit>(context).makeStartPosition(false);
        emit(state);
      }

      if (count == 7) {
        stopAudio();
        BlocProvider.of<MainaligmentCubit>(context).makeStartPosition(true);

        BlocProvider.of<SpeechToTextCubit>(context).startListening();
        return;
      }

      startAudio(count);
    });
  }

  pauseAudio() {
    state.audioPlayer.pause();
  }

  playAudio() {
    state.audioPlayer.resume();
  }

  startAudio(int count) async {
    String audioassetUZ = "assets/sounds/welcome_uz.mp3";
    String audioassetEN = "assets/sounds/welcome_en.mp3";
    String audioassetRU = "assets/sounds/welcome_ru.mp3";
    String chooseUZ = "assets/sounds/choose_uz.mp3";
    String chooseEN = "assets/sounds/choose_en.mp3";
    String chooseRU = "assets/sounds/choose_ru.mp3";
    late ByteData bytes;

    if (count == 1) {
      bytes = await rootBundle.load(audioassetUZ); //load sound from assets

    } else if (count == 2) {
      bytes = await rootBundle.load(audioassetEN); //load sound from assets

    } else if (count == 3) {
      bytes = await rootBundle.load(audioassetRU); //load sound from assets

    } else if (count == 4) {
      bytes = await rootBundle.load(chooseUZ); //load sound from assets

    } else if (count == 5) {
      bytes = await rootBundle.load(chooseEN); //load sound from assets

    } else if (count == 6) {
      bytes = await rootBundle.load(chooseRU); //load sound from assets

    }

    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await state.audioPlayer.playBytes(soundbytes);
    if (result == 1) {
      //play success
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  stopAudio() {
    state.audioPlayer.stop();
    state.audioPlayer.dispose();
  }
}
