import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/mainaligment_cubit.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
part 'speech_to_text_state.dart';

class SpeechToTextCubit extends Cubit<SpeechToTextState> {
  BuildContext context;
  SpeechToTextCubit({required this.context})
      : super(SpeechToTextState(speechToText: SpeechToText()));
  Timer? timer;

  initSpeech() async {
    bool _speechEnabled = await state.speechToText.initialize();
    print("Is succes" + _speechEnabled.toString());
  }

  stopListening(String code) async {
    if (timer != null && timer!.isActive) {
      await state.speechToText.stop();
      timer!.cancel();
      print("stopet spetch");
      emit(SpeechToTextState(speechToText: SpeechToText(), langCode: code));
    }
  }

  startListening({bool firstStart = false}) async {
    if (timer != null && timer!.isActive) return;
    if (!firstStart) return;
    timer = Timer.periodic(Duration(milliseconds: 1000), (t) async {
      await state.speechToText.listen(onResult: onSpeechResult);
    });
  }

  onSpeechResult(SpeechRecognitionResult result) async {
    String _lastWords = result.recognizedWords;
    print(_lastWords);
    if (_lastWords.toLowerCase().contains("uzbek") ||
        _lastWords.toLowerCase().contains("ozbek") ||
        _lastWords.toLowerCase().contains("back") ||
        _lastWords.toLowerCase().contains("bek") ||
        _lastWords.toLowerCase().contains("big") ||
        _lastWords.toLowerCase().contains("бек")) {
      BlocProvider.of<MainaligmentCubit>(context)
          .makeStartPosition(true, chackingItem: 0);

      await stopListening("uz");
    } else if (_lastWords.toLowerCase().contains("english") ||
        _lastWords.toLowerCase().contains("ingliz")) {
      BlocProvider.of<MainaligmentCubit>(context)
          .makeStartPosition(true, chackingItem: 1);

      await stopListening("en");
    } else if (_lastWords.toLowerCase().contains("russian") ||
        _lastWords.toLowerCase().contains("ruskiy") ||
        _lastWords.toLowerCase().contains("ruski") ||
        _lastWords.toLowerCase().contains("русский")) {
      BlocProvider.of<MainaligmentCubit>(context)
          .makeStartPosition(true, chackingItem: 2);

      await stopListening("ru");
    }
  }
}
