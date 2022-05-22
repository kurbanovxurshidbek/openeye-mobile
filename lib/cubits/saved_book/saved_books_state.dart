import 'package:key_board_app/models/audio_model.dart';

class SavedBooksState {
  bool loadList;
  List<AudioModel> listOfAudioModels;
  SavedBooksState({required this.listOfAudioModels, required this.loadList});
}
