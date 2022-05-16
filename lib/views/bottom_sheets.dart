import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/mainaligment_state.dart';
import 'package:key_board_app/cubits/mediaplayer_cubit.dart';
import 'package:key_board_app/cubits/speech_to_text_cubit.dart';

import '../animations/fade_animatoin.dart';
import '../navigators/goto.dart';
import '../pages/home_page.dart';
import 'lang_view.dart';

showBottomS(BuildContext context) {
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
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.4,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Color.fromARGB(255, 119, 119, 119),
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
                      style: Theme.of(context).textTheme.headline6,
                      children: [
                    TextSpan(
                        text: "your language",
                        style: Theme.of(context).textTheme.bodyText1)
                  ])),
              Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index) {
                    return FadeAnimation(
                      1,
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

                              await Future.delayed(
                                  Duration(milliseconds: 3000));

                              GOTO.pushRpUntil(context, HomePage());
                            },
                            child: BlocListener<SpeechToTextCubit,
                                SpeechToTextState>(
                              listener: (context, state) {
                                if (state.langCode != null) {
                                  if (state.langCode == "uz") {
                                    GOTO.pushRpUntil(context, HomePage());
                                  } else if (state.langCode == "en") {
                                    GOTO.pushRpUntil(context, HomePage());
                                  } else if (state.langCode == "ru") {
                                    GOTO.pushRpUntil(context, HomePage());
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
