import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_lang_page/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/for_lang_page/mainaligment_state.dart';
import 'package:key_board_app/cubits/for_language/load_lang_cubit.dart';
import 'package:key_board_app/cubits/for_speech_to_text/speech_to_text_state.dart';
import 'package:key_board_app/cubits/for_text_to_speech/mediaplayer_cubit.dart';
import 'package:key_board_app/cubits/for_speech_to_text/speech_to_text_cubit.dart';
import 'package:key_board_app/services/hive_service.dart';
import '../animations/fade_animatoin.dart';
import '../navigators/goto.dart';
import '../pages/home_page.dart';
import 'lang_view.dart';

showBottomS(BuildContext context1, {bool inSettings = false}) {
  List<String> listLang = [
    "O`zbek",
    "English",
    "Русский",
  ];

  List<String> listHello = [
    "Salom!",
    "Hello!",
    "Привет!",
  ];

  savedLanguage(BuildContext context, int index) async {
    if (!inSettings) {
      BlocProvider.of<SpeechToTextCubit>(context).stopListening("stop");
      BlocProvider.of<MainaligmentCubit>(context)
          .makeStartPosition(true, chackingItem: index);

      BlocProvider.of<MediaplayerCubit>(context).stopAudio();
    }

    ///store in HiveDB
    switch (index) {
      case 0:
        await HiveDB.storeLang("uz", "UZ");
        break;
      case 1:
        await HiveDB.storeLang("en", "US");
        break;
      case 2:
        await HiveDB.storeLang("ru", "RU");
        break;
    }
    if (!inSettings) {
      await HiveDB.saveData("voice", "famale");
    }

    await BlocProvider.of<MainaligmentCubit>(context)
        .makeStartPosition(true, chackingItem: 9999);

    if (inSettings) {
      GOTO.pop(context);

      await BlocProvider.of<LoadLangCubit>(context).loadedLang();
    } else {


      GOTO.pushRpUntil(context,  HomePage());
    }
  }

  listenerBloc(context, state) async {
    if (state.langCode != null) {
      if (state.langCode == "uz") {
        await HiveDB.storeLang("uz", "UZ");
        if (!inSettings) {
          await HiveDB.saveData("voice", "famale");
        }

        GOTO.pushRpUntil(context,  HomePage());
      } else if (state.langCode == "en") {
        await HiveDB.storeLang("en", "US");
        if (!inSettings) {
          await HiveDB.saveData("voice", "famale");
        }

        GOTO.pushRpUntil(context,  HomePage());
      } else if (state.langCode == "ru") {
        await HiveDB.storeLang("ru", "RU");
        if (!inSettings) {
          await HiveDB.saveData("voice", "famale");
        }
        if (inSettings) {
          GOTO.pop(context);
        } else {
          GOTO.pushRpUntil(context,  HomePage());
        }
      }
    }
  }

  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0),
      enableDrag: false,
      useRootNavigator: false,
      context: context1,
      builder: (context1) {
        BuildContext context;
        return Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context1).size.height * 0.4,
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 3.0,
                    spreadRadius: 0,
                    color: Colors.blueGrey,
                    offset: Offset(2, -1))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: "Choose".tr(),
                      style: Theme.of(context1).textTheme.headline6,
                      children: [
                    TextSpan(
                        text: "your language".tr(),
                        style: Theme.of(context1).textTheme.bodyText1),
                  ])),
              Container(
                height:MediaQuery.of(context1).size.height/5 ,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index) {
                    return FadeAnimation(
                      index == 0
                          ? 1
                          : index == 1
                              ? inSettings
                                  ? 1
                                  : 8.1
                              : inSettings
                                  ? 1
                                  : 14.1,
                      BlocBuilder<MainaligmentCubit, MainAligmentState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              savedLanguage(context, index);
                            },
                            child: BlocListener<SpeechToTextCubit,
                                SpeechToTextState>(
                              listener: ((context, state) =>
                                  listenerBloc(context, state)),
                              child: LangUI(
                                  hello: listHello[index],
                                  lang: listLang[index],
                                  isChackLang: index == state.chackedItem
                                      ? true
                                      : false),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
              Container(),
              Container(),
            ],
          ),
          width: double.infinity,
        );
      });
}

voiceChooseSheet(BuildContext context) async {
  savedLanguage(context, index) async {
    if (index == 0) {
      await HiveDB.saveData("voice", "male");
    } else {
      await HiveDB.saveData("voice", "famale");
    }
    GOTO.pop(context);
  }
  List<String> listVoice = ["voice_male", "voice_famale"];

  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0),
      enableDrag: false,
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.4,
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 3.0,
                    spreadRadius: 0,
                    color: Colors.blueGrey,
                    offset: Offset(2, -1)
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: "choose_voice".tr(),
                      style: Theme.of(context).textTheme.headline6,
                      children: [])),
              Container(
                height: MediaQuery.of(context).size.height/5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(2, (index) {
                    return FadeAnimation(
                      1,
                      BlocBuilder<MainaligmentCubit, MainAligmentState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              savedLanguage(context, index);
                            },
                            child: LangUI(
                                icon: Image.asset(
                                  index == 0
                                      ? "assets/images/male.png"
                                      : "assets/images/female.png",
                                  width: 50,
                                  height: 50,
                                  color: Colors.blueGrey,
                                ),
                                hello: "",
                                lang: listVoice[index],
                                isChackLang:
                                    index == state.chackedItem ? true : false),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
              Container(),
              Container(),
            ],
          ),
          width: double.infinity,
        );
      });
}
