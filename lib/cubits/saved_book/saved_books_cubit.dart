import 'package:bloc/bloc.dart';
import 'package:key_board_app/cubits/saved_book/saved_books_state.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/services/hive_service.dart';

class SavedBooksCubit extends Cubit<SavedBooksState> {
  SavedBooksCubit()
      : super(SavedBooksState(listOfAudioModels: [], loadList: false));

  loadList() async {
    emit(SavedBooksState(listOfAudioModels: [], loadList: true));
    List<dynamic> listMap = await HiveDB.loadCountryCode(key: "listOfAudio");

    print(listMap);
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (listMap == null) {
      listMap = [];
    }

    List<AudioModel> listOfAudioModels = [];

    listOfAudioModels = List.generate(
        listMap.length, (index) => AudioModel.fromJson(listMap[index]));

    emit(
        SavedBooksState(listOfAudioModels: listOfAudioModels, loadList: false));
  }
}
