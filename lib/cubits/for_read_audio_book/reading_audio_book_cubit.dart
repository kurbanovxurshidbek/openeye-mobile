import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_read_audio_book/reading_audio_book_state.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:key_board_app/services/http_service.dart';

class ReadingAudioBookCubit extends Cubit<ReadingAudioBookState> {
  ReadingAudioBookCubit()
      : super(ReadingAudioBookState(isLoading: true, isFamale: true));

  String speeker = "";
  String langCode = "";
  String code = "";

  getAudio(String content) async {
    langCode = await HiveDB.loadLangCode()!;
    switch (langCode) {
      case 'uz':
        {
          if (state.isFamale) {
            speeker = Network.speeker_uz_famale;
          }
          else{
            speeker = Network.speeker_uz_male;
          }
          code = Network.lang_code_uz;
        }
        break;
      case 'ru':
        {
          if (state.isFamale) {
            speeker = Network.speeker_ru_famale;
          } else {
            speeker = Network.speeker_ru_male;
          }
          code = Network.lang_code_ru;
        }break;
      case 'en':
        {
          if (state.isFamale) {
            speeker = Network.speeker_en_famale;
          } else {
            speeker = Network.speeker_en_male;
          }
          code = Network.lang_code_en;
        }break;
    }
    Network.apiGetVoice(content, speeker, code);
  }


}
