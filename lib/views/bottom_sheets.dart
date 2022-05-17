import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/mainaligment_state.dart';
import 'package:key_board_app/cubits/mediaplayer_cubit.dart';
import 'package:key_board_app/cubits/speech_to_text_cubit.dart';
import 'package:key_board_app/services/hive_service.dart';
import '../animations/fade_animatoin.dart';
import '../navigators/goto.dart';
import '../pages/home_page.dart';
import 'lang_view.dart';

showBottomS(BuildContext context1) {
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

  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0),
      enableDrag: false,
      useRootNavigator: false,
      context: context1,
      builder: (context1) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context1).size.height * 0.4,
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Color.fromARGB(123, 202, 201, 201),
                    offset: Offset(0, -0))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: "Choose\n",
                      style: Theme.of(context1).textTheme.headline6,
                      children: [
                    TextSpan(
                        text: "your language",
                        style: Theme.of(context1).textTheme.bodyText1)
                  ])),
              Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index) {
                    return FadeAnimation(
                      index == 0
                          ? 1
                          : index == 1
                              ? 8.1
                              : 14.1,
                      BlocBuilder<MainaligmentCubit, MainAligmentState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              BlocProvider.of<SpeechToTextCubit>(context)
                                  .stopListening("stop");
                              BlocProvider.of<MainaligmentCubit>(context)
                                  .makeStartPosition(true, chackingItem: index);

                              BlocProvider.of<MediaplayerCubit>(context)
                                  .stopAudio();

                              ///store in HiveDB
                              switch (index) {
                                case 0:
                                  await HiveDB.storeLang("uz");
                                  break;
                                case 1:
                                  await HiveDB.storeLang("en");
                                  break;
                                case 2:
                                  await HiveDB.storeLang("ru");
                                  break;
                              }

                              GOTO.pushRpUntil(context, const HomePage());
                            },
                            child: BlocListener<SpeechToTextCubit,
                                SpeechToTextState>(
                              listener: (context, state) async {
                                if (state.langCode != null) {
                                  if (state.langCode == "uz") {
                                    await HiveDB.storeLang("uz");
                                    GOTO.pushRpUntil(context, const HomePage());
                                  } else if (state.langCode == "en") {
                                    await HiveDB.storeLang("en");
                                    GOTO.pushRpUntil(context, const HomePage());
                                  } else if (state.langCode == "ru") {
                                    await HiveDB.storeLang("ru");
                                    GOTO.pushRpUntil(context, const HomePage());
                                  }
                                }
                              },
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
