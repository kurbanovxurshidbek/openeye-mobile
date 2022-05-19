import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextState {
  SpeechToText speechToText;
  String? langCode;

  SpeechToTextState({
    required this.speechToText,
    this.langCode,
  });
}
