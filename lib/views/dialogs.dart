import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/convert_and_reading/convert_and_reading_cubit.dart';
import 'package:key_board_app/cubits/part_saved_books/part_audio_books_dart_cubit.dart';
import 'package:key_board_app/models/book_on_audio.dart';
import '../models/audio_model.dart';
import '../navigators/goto.dart';
import '../pages/home_page.dart';
import '../services/hive_service.dart';

saveAudioDialog(BuildContext context, List<AudioModel> audioBook,
    {bool isBack = false}) async {
  showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          title: const Text(
            "save_audio",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Serif",
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 49, 49, 49),
                fontStyle: FontStyle.normal),
          ).tr(),
          content: const Text(
            "discreption",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Serif",
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 49, 49, 49),
                fontStyle: FontStyle.normal),
          ).tr(),
          actions: [
            TextButton(
                onPressed: () async {
                  List<dynamic>? listOfAudio =
                      await HiveDB.loadCountryCode(key: "listOfAudio");

                  listOfAudio ??= [];

                  String? langCode = HiveDB.loadLangCode()!;
                  String part = langCode == "uz"
                      ? "qism"
                      : langCode == "ru"
                          ? "часть"
                          : "part";

                  AudioBook book =
                      AudioBook(name: audioBook[0].name, partOfBook: []);

                  for (int i = 0; i < audioBook.length; i++) {
                    AudioModel newAudio = AudioModel(
                        name: (i + 1).toString() + " -$part",
                        path: audioBook[i].path);

                    book.partOfBook!.add(newAudio);
                  }

                  listOfAudio.add(book.toJson());

                  await HiveDB.saveData("listOfAudio", listOfAudio);

                  GOTO.pop(context);
                },
                child: Text("save",
                        style: TextStyle(
                            color: Colors.green.shade700, fontSize: 15))
                    .tr()),
            TextButton(
                onPressed: () async {
                  if (isBack) {
                    GOTO.pushRpUntil(context, HomePage());
                  } else {
                    GOTO.pop(context);
                  }
                },
                child: Text("no",
                        style: TextStyle(
                            color: Colors.green.shade700, fontSize: 15))
                    .tr()),
          ],
        );
      });
}

errorDialog(BuildContext context, bool isCamera) {
  showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: const Text(
            "error",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Serif",
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 49, 49, 49),
                fontStyle: FontStyle.normal),
          ).tr(),
          content: const Text(
            "about_error",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Serif",
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 49, 49, 49),
                fontStyle: FontStyle.normal),
          ).tr(),
          actions: [
            TextButton(
                onPressed: () {
                  GOTO.pushRpUntil(context, HomePage());
                },
                child: Text("go_home",
                        style: TextStyle(
                            color: Colors.green.shade700, fontSize: 15))
                    .tr()),
            TextButton(
                onPressed: () {
                  GOTO.popUT(context);

                  if(isCamera) {
                    BlocProvider.of<ConvertAndReadingCubit>(context)
                        .readImageDataAndListeningOnStream();
                  }else {
                    BlocProvider.of<ConvertAndReadingCubit>(context)
                        .readDocumentDataAndListeningOnStream();
                  }
                },
                child: Text(
                  "try",
                  style: TextStyle(color: Colors.green.shade700, fontSize: 15),
                ).tr()),
          ],
        );
      });
}

connectionDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Center(
              child: Text(
            "noinet",
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600),
          ).tr()),
          actions: [
            TextButton(
                onPressed: () {
                  GOTO.pop(context);
                },
                child: Text(
                  "try",
                  style: TextStyle(color: Colors.green.shade700, fontSize: 17),
                ).tr()),
          ],
        );
      });
}

deleteItemDialog(BuildContext context, AudioModel audioModel, int index) {
  showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text(
            "confirm",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Serif",
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 49, 49, 49),
                fontStyle: FontStyle.normal),
          ).tr(),
          content: Text(
            "sure",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Serif",
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 49, 49, 49),
                fontStyle: FontStyle.normal),
          ).tr(),
          actions: [
            TextButton(
                onPressed: () async {
                  print("----------" + audioModel.path);
                  File aufioFile = File(audioModel.path);
                  bool hasFile = await aufioFile.exists();
                  if (!hasFile) {
                    GOTO.pop(context);
                    return;
                  }
                  await aufioFile.delete();

                  List<dynamic> listMap =
                      await HiveDB.loadCountryCode(key: "listOfAudio");

                  AudioBook book = AudioBook.fromJson(listMap[index]);

                  book.partOfBook!.remove(audioModel);

                  listMap.removeAt(index);


                  if(book.partOfBook!.isNotEmpty){
                    listMap.insert(index, book.toJson());
                  }



                  await HiveDB.saveData("listOfAudio", listMap);

                  GOTO.pop(context);

                  BlocProvider.of<PartAudioBooksDartCubit>(context)
                      .loadList(index);
                },
                child: Text("delete",
                        style: TextStyle(
                            color: Colors.green.shade700, fontSize: 15))
                    .tr()),
            TextButton(
                onPressed: () {
                  GOTO.pop(context);
                },
                child: Text("no",
                        style: TextStyle(
                            color: Colors.green.shade700, fontSize: 15))
                    .tr()),
          ],
        );
      });
}
