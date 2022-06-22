import 'package:bloc/bloc.dart';
import 'package:key_board_app/cubits/saved_book/saved_books_state.dart';
import 'package:key_board_app/services/hive_service.dart';

class SavedBooksCubit extends Cubit<SavedBooksState> {
  SavedBooksCubit()
      : super(SavedBooksState(listOAudioBook: [], loadList: false));

  loadList() async {
    emit(SavedBooksState(listOAudioBook: [], loadList: true));
    List<dynamic>? listMap = await HiveDB.loadCountryCode(key: "listOfAudio");

    print(listMap);
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (listMap == null) {
      listMap = [];
    }

    List<String> listOfAudioModels = [];

    listOfAudioModels =
        List.generate(listMap.length, (index) => listMap![index]["name"]);

    emit(SavedBooksState(listOAudioBook: listOfAudioModels, loadList: false));
  }
}
