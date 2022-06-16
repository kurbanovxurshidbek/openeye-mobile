import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/convertion/convertion_cubit.dart';
import 'package:key_board_app/cubits/for_take_image/take_image_cubit.dart';
import '../cubits/saved_book/saved_books_cubit.dart';
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
                  List<dynamic>? listOfAudio =
                  await HiveDB.loadCountryCode(key: "listOfAudio");

                  if (listOfAudio == null) {
                    List<dynamic> list = [audioModel.toJson()];
                    await HiveDB.saveData("listOfAudio", list);
                  } else {
                    print(audioModel.toJson());
                    listOfAudio.add(audioModel.toJson());
                    await HiveDB.saveData("listOfAudio", listOfAudio);
                  }


                  GOTO.pop(context);
                },
                child:  Text("save",style: TextStyle(color:Colors.green.shade700,fontSize: 15)).tr()),
            TextButton(
                onPressed: () async {
                  if (isBack) {
                    GOTO.pushRpUntil(context, HomePage());
                  } else {
                    GOTO.pop(context);
                  }
                },
                child:  Text("no",style: TextStyle(color:Colors.green.shade700,fontSize: 15)).tr()),
          ],
        );
      });
}

errorDialog(BuildContext context, bool isPage) {
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
                child: Text("go_home",style: TextStyle(color:Colors.green.shade700,fontSize: 15)).tr()),
            TextButton(
                onPressed: () {
                  GOTO.popUT(context);
                  if(isPage == false) {
                    BlocProvider.of<ConvertionCubit>(context).succesLoadedPdfText();
                  }else {
                    BlocProvider.of<TakeImageCubit>(context).state.isOpen = false;
                  }
                },
                child: Text("try",style: TextStyle(color:Colors.green.shade700,fontSize: 15),).tr()),
          ],
        );
      });
}

connectionDialog(BuildContext context){
  showDialog(context: context, builder: (c){
    return AlertDialog(

      title: Center(child: Text("noinet",style: TextStyle(fontSize: 16,color: Colors.grey.shade600,fontWeight: FontWeight.w600),).tr()),
      actions:[ TextButton(
          onPressed: () {
            GOTO.pop(context);
          },
                child: Text("try",style: TextStyle(color:Colors.green.shade700,fontSize: 17),).tr()),
          ],

    );
  });
}

deleteItemDialog(BuildContext context, AudioModel audioModel) {
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
                onPressed: () async {
                  File aufioFile = File(audioModel.path);
                  await aufioFile.delete();

                  List<dynamic> listMap =
                  await HiveDB.loadCountryCode(key: "listOfAudio");

                  List<AudioModel> listOfAudioModels = [];
                  List<dynamic> listOfJson = [];

                  listOfAudioModels = List.generate(listMap.length,
                          (index) => AudioModel.fromJson(listMap[index]));

                  listOfAudioModels.remove(audioModel);

                  listOfJson = List.generate(listOfAudioModels.length,
                          (index) => listOfAudioModels[index].toJson());

                  await HiveDB.saveData("listOfAudio", listOfJson);
                  GOTO.pop(context);

                  BlocProvider.of<SavedBooksCubit>(context).loadList();
                },
                child:  Text("delete",style: TextStyle(color:Colors.green.shade700,fontSize: 15)).tr()),
            TextButton(
                onPressed: () {
                  GOTO.pop(context);
                },
                child:  Text("no",style: TextStyle(color:Colors.green.shade700,fontSize: 15)).tr()),
          ],
        );
      });
}
