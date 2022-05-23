import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/convertion/convertion_cubit.dart';
import '../models/audio_model.dart';
import '../navigators/goto.dart';
import '../pages/home_page.dart';
import '../services/hive_service.dart';

saveAudioDialog(BuildContext context, AudioModel audioModel,
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
                  List<Map<String, dynamic>>? listOfAudio =
                      await HiveDB.loadCountryCode(key: "listOfAudio");

                  if (listOfAudio == null) {
                    List<Map<String, dynamic>> list = [audioModel.toJson()];
                    await HiveDB.saveData("listOfAudio", list);
                  } else {
                    listOfAudio.add(audioModel.toJson());
                    await HiveDB.saveData("listOfAudio", listOfAudio);
                  }
                  List<Map<String, dynamic>> list =
                      HiveDB.loadCountryCode(key: "listOfAudio");

                  print(list);
                  GOTO.pop(context);
                },
                child: const Text("save").tr()),
            TextButton(
                onPressed: () async {
                  if (isBack) {
                    GOTO.pushRpUntil(context, HomePage());
                  } else {
                    GOTO.pop(context);
                  }
                },
                child: const Text("no").tr()),
          ],
        );
      });
}

errorDialog(BuildContext context) {
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
                child: Text("go_home").tr()),
            TextButton(
                onPressed: () {
                  GOTO.popUT(context);
                  BlocProvider.of<ConvertionCubit>(context).succesLoaded();
                },
                child: Text("try").tr()),
          ],
        );
      });
}
