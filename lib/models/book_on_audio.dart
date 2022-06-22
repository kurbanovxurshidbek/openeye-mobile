import 'package:key_board_app/models/audio_model.dart';

class AudioBook {
  String? name;
  List<AudioModel>? partOfBook;
  AudioBook({required this.name, required this.partOfBook});

  toJson() {
    return {
      "name": name,
      "partOfBook": List.generate(
          partOfBook!.length, (index) => partOfBook![index].toJson())
    };
  }

  AudioBook.fromJson(Map json) {
    name = json["name"];
    partOfBook = List.generate(json["partOfBook"].length,
        (index) => AudioModel.fromJson(json["partOfBook"][index]));
  }
}
