import 'dart:async';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:key_board_app/cubits/for_lang_page/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/for_speech_to_text/speech_to_text_cubit.dart';
import 'package:key_board_app/services/hive_service.dart';
import '../../views/bottom_sheets.dart';
import 'mediaplayer_state.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MediaplayerCubit extends Cubit<MediaPlayerState> {
  MediaplayerCubit() : super(MediaPlayerState(audioPlayer: AudioPlayer()));

  late StreamSubscription audioListening;
  late File file;

  onComplatedAudioAndStart(BuildContext context, int _count) async {
    int count = _count;

    String? done = await HiveDB.loadCountryCode(key: "in_home");
    if (done == "done") {
      return;
    }

    startAudio(count);

    audioListening = state.audioPlayer.onPlayerCompletion.listen(
      (event) {
        file.deleteSync();
        count++;
        print(count);

        if (count == 4) {
          showBottomS(context);
          BlocProvider.of<MainaligmentCubit>(context).makeStartPosition(false);
          emit(state);
        }

        if (count == 7) {
          stopAudio();

          BlocProvider.of<MainaligmentCubit>(context).makeStartPosition(true);

          BlocProvider.of<SpeechToTextCubit>(context)
              .startListening(firstStart: true);

          return;
        }

        if (count == 9) {
          stopAudio();
        }

        startAudio(count);
      },
    );
  }

  pauseAudio() async {
    await state.audioPlayer.pause();

    // List<Uint8List>
  }

  playAudio() async {
    await state.audioPlayer.resume();
  }

  Future<int> playAudionFromUint8List(Uint8List list) async {
    int result = await state.audioPlayer.playBytes(list);
    return result;
  }

  startAudio(int count) async {
    String audioassetUZ = "assets/sounds/welcome_uz.mp3";
    String audioassetEN = "assets/sounds/welcome_en.mp3";
    String audioassetRU = "assets/sounds/welcome_ru.mp3";
    String chooseUZ = "assets/sounds/choose_uz.mp3";
    String chooseEN = "assets/sounds/choose_en.mp3";
    String chooseRU = "assets/sounds/choose_ru.mp3";
    String welcomeUz = "assets/sounds/welcome_home_uz.mp3";
    String welcomeEn = "assets/sounds/welcome_home_en.mp3";
    String welcomeRu = "assets/sounds/welcome_home_ru.mp3";
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
    } else if (count == 8) {
      String? langCode = await HiveDB.loadLangCode();
      await HiveDB.saveData("in_home", "done");
      langCode ??= "uz";
      await Future.delayed(Duration(seconds: 3));

      if (langCode == "uz") {
        bytes = await rootBundle.load(welcomeUz);
      } else if (langCode == "en") {
        bytes = await rootBundle.load(welcomeEn);
      } else if (langCode == "ru") {
        bytes = await rootBundle.load(welcomeRu);
      }
    }

    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

// store unit8List audio here ;
    final tempDir = await getTemporaryDirectory();
    file = await File('${tempDir.path}/image.mp3').create();
    await file.writeAsBytes(soundbytes);

    int result = await state.audioPlayer.play(file.path, isLocal: true);

    if (result == 1) {
      //play success
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  stopAudio() async {
    await state.audioPlayer.stop();
    await audioListening.cancel();
  }
}
