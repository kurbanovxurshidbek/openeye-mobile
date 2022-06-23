import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/cubits/convert_and_reading/convert_and_reading_state.dart';
import 'package:path_provider/path_provider.dart';
import '../../logic/kril_to_latin.dart';
import '../../models/audio_model.dart';
import '../../services/hive_service.dart';
import '../../services/http_service.dart';

class ConvertAndReadingCubit extends Cubit<ConvertAndReadingState> {
  ConvertAndReadingCubit()
      : super(ConvertAndReadingState(
            isLoading: true,
            cancel: false,
            isConverting: true,
            error: Errors.none,
            audioPlayer: AudioPlayer(),
            currentPosition: Duration.zero,
            duration: Duration.zero,
            index: 0,
            isPlaying: false,
            total: 1,
            listOfAudio: []));

  File? imageFile;
  String? path;
  InputImage? inputImage;
  String imgText = "";
  //get pdf file and convert to text and goto push reading page

  late StreamSubscription litening;

  /// #get pdf from device file
  Future<void> readDocumentDataAndListeningOnStream() async {
    makeDeffould();

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    emit(ConvertAndReadingState(
        error: state.error,
        isConverting: false,
        total: state.total,
        isLoading: state.isLoading,
        cancel: false,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));
    if (result != null && result.paths.toString().contains("pdf")) {
      File file = File(result.files.first.path!);

      Stream<AudioModel?> stream = getPdfTextAndPushReadingBookPage(
          false, [file.path, result.files.first.name]);

      litening = stream.listen((audioModel) {
        _listeningAudioModel(audioModel);
      });
    } else {
      print("a-----------------");
      hasError(Errors.file);
    }
  }

  removeLitening() {
    litening.cancel();
    print("=+++++++++++++++++++++++++++++++++++++");
    emit(ConvertAndReadingState(
        error: state.error,
        isConverting: false,
        total: state.total,
        isLoading: state.isLoading,
        cancel: true,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));
  }

  // error bo`lganda
  hasError(Errors error) {
    emit(ConvertAndReadingState(
        error: error,
        isConverting: state.isConverting,
        isLoading: state.isLoading,
        total: state.total,
        cancel: false,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));
  }

  // pagedan chiqib ketishda defould qiymatlarga qaytaradi
  makeDeffould() {
    emit(ConvertAndReadingState(
        isLoading: true,
        isConverting: true,
        total: state.total,
        cancel: false,
        error: Errors.none,
        audioPlayer: AudioPlayer(),
        currentPosition: Duration.zero,
        duration: Duration.zero,
        index: 0,
        isPlaying: false,
        listOfAudio: []));
  }

  _listeningAudioModel(AudioModel? audioModel) {
    if (audioModel != null) {
      state.listOfAudio.add(audioModel);
      if (audioModel.index != null && audioModel.index == 0) {
        startAndLoadAudioFiles(0, state.listOfAudio);
      }
    } else if (state.isConverting && state.listOfAudio.length == state.total) {
      emit(ConvertAndReadingState(
          error: Errors.network,
          total: state.total,
          isConverting: state.isConverting,
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: state.index,
          cancel: state.cancel,
          isPlaying: state.isPlaying,
          listOfAudio: state.listOfAudio));
    }

    emit(ConvertAndReadingState(
        error: state.error,
        total: state.total,
        isConverting: state.isConverting,
        isLoading: state.isLoading,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        cancel: false,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));
  }

  startAndLoadAudioFiles(int curentIndex, List<AudioModel> listOfAudio) {
    state.audioPlayer!.onPlayerCompletion.listen((event) {
      curentIndex++;

      if (curentIndex > state.listOfAudio.length - 1) {
        curentIndex = 0;
      }

      emit(ConvertAndReadingState(
          isLoading: state.isLoading,
          total: state.total,
          cancel: false,
          audioPlayer: state.audioPlayer,
          error: state.error,
          isConverting: state.isConverting,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: curentIndex,
          isPlaying: state.isPlaying,
          listOfAudio: listOfAudio));

      play(listOfAudio[curentIndex]);
    });

    state.audioPlayer!.onPlayerStateChanged.listen((event) {
      state.isPlaying = event == PlayerState.PLAYING;

      emit(ConvertAndReadingState(
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          error: state.error,
          isConverting: state.isConverting,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: state.index,
          total: state.total,
          cancel: false,
          isPlaying: event == PlayerState.PLAYING,
          listOfAudio: listOfAudio));
    });

    state.audioPlayer!.onDurationChanged.listen((event) {
      emit(ConvertAndReadingState(
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          error: state.error,
          isConverting: state.isConverting,
          currentPosition: state.currentPosition,
          duration: event,
          index: state.index,
          total: state.total,
          cancel: false,
          isPlaying: state.isPlaying,
          listOfAudio: listOfAudio));
    });

    state.audioPlayer!.onAudioPositionChanged.listen((event) {
      state.currentPosition = event;
      emit(ConvertAndReadingState(
          isLoading: state.isLoading,
          audioPlayer: state.audioPlayer,
          error: state.error,
          isConverting: state.isConverting,
          currentPosition: event,
          duration: state.duration,
          index: state.index,
          total: state.total,
          cancel: false,
          isPlaying: state.isPlaying,
          listOfAudio: listOfAudio));
    });

    play(listOfAudio[curentIndex]);
  }

  play(AudioModel audioModel) async {
    File audioFile = File(audioModel.path);
    int result = await state.audioPlayer!.play(audioFile.path, isLocal: true);
    if (result == 1) {
      //play success
      emit(ConvertAndReadingState(
          isLoading: false,
          cancel: false,
          audioPlayer: state.audioPlayer,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: state.index,
          error: state.error,
          total: state.total,
          isConverting: state.isConverting,
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
    emit(ConvertAndReadingState(
        error: state.error,
        isConverting: state.isConverting,
        isLoading: state.isLoading,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        total: state.total,
        cancel: false,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));
  }

  nextAudioButton() {
    state.audioPlayer!.stop();
    state.index++;
    if (state.index > state.listOfAudio.length - 1) {
      state.index = 0;
    }

    play(state.listOfAudio[state.index]);
    emit(ConvertAndReadingState(
        isLoading: state.isLoading,
        cancel: false,
        error: state.error,
        isConverting: state.isConverting,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        total: state.total,
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

  Stream<AudioModel?> getPdfTextAndPushReadingBookPage(
      bool isCamera, List<String> _list) async* {
    Uint8List? uint8list;

    List<String>? list = await getTextFromPdfAndName(_list);
    if (list != null) {
      List<String> partList = await getContent(list[0]);
      String? countryCode = HiveDB.loadLangCode();

      for (int i = 0; i < partList.length; i++) {
        if (state.cancel) {
          print(
              "-----------------------------------------------------------------");
          break;
        }

        if (countryCode != null && countryCode == "uz") {
          if (partList[i].contains("В") ||
              partList[i].contains("б") ||
              partList[i].contains("я") ||
              partList[i].contains("ю") ||
              partList[i].contains("ь") ||
              partList[i].contains("ж") ||
              partList[i].contains("э")) {
            String str = await toLatin(partList[i]);

            partList[i] = str;
          }
        }

        uint8list = await Network.getAudioFromApi(partList[i]);

        if (uint8list == null) {
          yield null;
          continue;
        }
        final tempDir = await getTemporaryDirectory();
        File file =
            await File('${tempDir.path}/${list[1]}-${i + 1}.mp3').create();
        await file.writeAsBytes(uint8list);
        AudioModel audioFileModel =
            AudioModel(name: list[1], path: file.path, index: i);
        yield audioFileModel;
      }
    } else {
      emit(ConvertAndReadingState(
          isLoading: state.isLoading,
          cancel: state.cancel,
          error: Errors.network,
          isConverting: state.isConverting,
          audioPlayer: state.audioPlayer,
          currentPosition: state.currentPosition,
          duration: state.duration,
          index: state.index,
          total: state.total,
          isPlaying: state.isPlaying,
          listOfAudio: state.listOfAudio));
    }
  }

  static Future<List<String>?> getTextFromPdfAndName(List<String> list) async {
    //Load an existing PDF document.
    print(list);
    if (list != null) {
      String? text = await getPDFtext(list[0]);
      if (text == null) {
        return null;
      }

      return [text, list[1]];
    }
    return null;
  }

  static Future<String?> getPDFtext(String path) async {
    String? text;
    try {
      // api bilan qilinsin
      text = await Network.MULTIPART(path);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
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

  Future<List<String>> getContent(String content) async {
    List<String> list = content.split(" ");
    list.retainWhere((item) => item.toString().isNotEmpty);
    String str = "";
    List<String> listofContent = [];
    for (int i = 0; i < list.length; i++) {
      str += list[i] + " ";
      if (i % 700 == 0 && i != 0) {
        listofContent.add(str);

        str = "";
      }
    }
    listofContent.add(str);

    emit(ConvertAndReadingState(
        isLoading: state.isLoading,
        cancel: state.cancel,
        error: state.error,
        isConverting: state.isConverting,
        audioPlayer: state.audioPlayer,
        currentPosition: state.currentPosition,
        duration: state.duration,
        index: state.index,
        total: listofContent.length,
        isPlaying: state.isPlaying,
        listOfAudio: state.listOfAudio));

    return listofContent;
  }
}
