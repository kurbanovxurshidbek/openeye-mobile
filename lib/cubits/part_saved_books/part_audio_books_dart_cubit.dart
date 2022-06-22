import 'package:bloc/bloc.dart';
import 'package:key_board_app/cubits/part_saved_books/part_audio_books_dart_state.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/models/book_on_audio.dart';
import 'package:key_board_app/services/hive_service.dart';

class PartAudioBooksDartCubit extends Cubit<PartAudioBooksDartState> {
  PartAudioBooksDartCubit()
      : super(PartAudioBooksDartState(listOfAudioModels: [], loadList: false));

  loadList(int _index) async {
    emit(PartAudioBooksDartState(listOfAudioModels: [], loadList: true));
    List<dynamic>? listMap = await HiveDB.loadCountryCode(key: "listOfAudio");

    print(listMap);
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (listMap == null) {
      listMap = [];
    }

    AudioBook audioBook = AudioBook.fromJson(listMap[_index]);

    List<AudioModel> listOfAudioModels = audioBook.partOfBook!;

    emit(PartAudioBooksDartState(
        listOfAudioModels: listOfAudioModels, loadList: false));
  }
}
