import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_read_audio_book/reading_audio_book_state.dart';
import 'package:key_board_app/models/audio_model.dart';

class ReadingAudioBookCubit extends Cubit<ReadingAudioBookState> {
  ReadingAudioBookCubit()
      : super(ReadingAudioBookState(
            isLoading: true,
            audioPlayer: AudioPlayer(),
            currentPosition: Duration.zero,
            duration: Duration.zero,
            index: 0,
            isPlaying: false,
            listOfAudio: []));

  startAndLoadAudioFiles(int curentIndex, List<AudioModel> listOfAudio) {
    state.index = curentIndex;

    state.audioPlayer!.onPlayerCompletion.listen((event) {
      curentIndex++;

      if (curentIndex > state.listOfAudio.length - 1) {
        curentIndex = 0;
      }

      emit(ReadingAudioBookState(
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: curentIndex,
          isPlaying: state.isPlaying,
          listOfAudio: listOfAudio));

      play(listOfAudio[curentIndex]);
    });

    state.audioPlayer!.onPlayerStateChanged.listen((event) {
      state.isPlaying = event == PlayerState.PLAYING;

      emit(ReadingAudioBookState(
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: state.index,
          isPlaying: event == PlayerState.PLAYING,
          listOfAudio: listOfAudio));
    });

    state.audioPlayer!.onDurationChanged.listen((event) {
      emit(ReadingAudioBookState(
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          currentPosition: state.currentPosition,
          duration: event,
          index: state.index,
          isPlaying: state.isPlaying,
          listOfAudio: listOfAudio));
    });

    state.audioPlayer!.onAudioPositionChanged.listen((event) {
      emit(ReadingAudioBookState(
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          currentPosition: event,
          duration: state.duration,
          index: state.index,
          isPlaying: state.isPlaying,
          listOfAudio: listOfAudio));
    });

    play(listOfAudio[curentIndex]);
  }

  play(AudioModel audioModel) async {
    print(audioModel);
    File audioFile = File(audioModel.path);
    int result = await state.audioPlayer!.play(audioFile.path, isLocal: true);
    if (result == 1) {
      //play success
      emit(ReadingAudioBookState(
          isLoading: false,
          audioPlayer: state.audioPlayer,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: state.index,
          isPlaying: state.isPlaying,
          listOfAudio: state.listOfAudio));
    } else {
      print("Error while playing sound.");
    }
  }

  backAudioButton() {
    state.audioPlayer!.stop();

    state.index--;
    if (state.index < 0) {
      state.index = state.listOfAudio.length - 1;
    }

    play(state.listOfAudio[state.index]);
    emit(ReadingAudioBookState(
        isLoading: state.isLoading,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));
  }

  nextAudioButton() {
    state.audioPlayer!.stop();
    state.index++;
    if (state.index > state.listOfAudio.length - 1) {
      state.index = 0;
    }

    print(state.listOfAudio.toString() + "0000000000000000000000000000");

    play(state.listOfAudio[state.index]);
    emit(ReadingAudioBookState(
        isLoading: state.isLoading,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));
  }

  stopOrPlayButton() {
    if (state.isPlaying!) {
      state.audioPlayer!.pause();
    } else {
      state.audioPlayer!.resume();
    }
  }

  stop() {
    print(state.isPlaying);
    state.audioPlayer!.stop();
  }

  resume() {
    state.audioPlayer!.resume();
  }
}
