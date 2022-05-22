import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
          title: const Text("save_audio").tr(),
          content: const Text("discreption").tr(),
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
