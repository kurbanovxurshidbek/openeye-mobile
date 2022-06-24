import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_lang_page/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/for_lang_page/mainaligment_state.dart';
import 'package:key_board_app/cubits/for_text_to_speech/mediaplayer_cubit.dart';
import 'package:key_board_app/cubits/for_speech_to_text/speech_to_text_cubit.dart';
import 'package:lottie/lottie.dart';

class LangChangePage extends StatefulWidget {
  int count;
  LangChangePage({Key? key, required this.count}) : super(key: key);

  @override
  State<LangChangePage> createState() => _LangChangePageState();
}

class _LangChangePageState extends State<LangChangePage>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    BlocProvider.of<SpeechToTextCubit>(context).initSpeech();

    BlocProvider.of<MediaplayerCubit>(context)
        .onComplatedAudioAndStart(context, widget.count);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed---------------");
        BlocProvider.of<MediaplayerCubit>(context).playAudio();
        BlocProvider.of<SpeechToTextCubit>(context).startListening();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive------------------------");
        // BlocProvider.of<MediaplayerCubit>(context).playAudio();
        break;
      case AppLifecycleState.paused:
        print("app in paused--------------");
        BlocProvider.of<SpeechToTextCubit>(context).stopListening("stop");
        BlocProvider.of<MediaplayerCubit>(context).pauseAudio();
        break;
      case AppLifecycleState.detached:
        print("app in detached----------------------");
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    BlocProvider.of<SpeechToTextCubit>(context).stopListening("stop");

    BlocProvider.of<MediaplayerCubit>(context).stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(

              color: Colors.white),
          child: BlocBuilder<MainaligmentCubit, MainAligmentState>(
            builder: (context, state) {

              
              return Column(
                mainAxisAlignment: state.columnAligment,
                children: [
                  Column(
                    children: [
                      Semantics(
                        label: "logo".tr(),
                        child: Image.asset(
                          "assets/images/logo1.jpg",
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                        ),
                      ),
                      Text(
                        "OpenEye",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  state.bottomUp==false? Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage("assets/images/blind1.jpg"),fit: BoxFit.cover
                      )
                  ),
                    height: 200,
                    width: 200,
                  ):
                  state.bottomUp
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                        ),
                  Container(
                          height: MediaQuery.of(context).size.width / 2,
                          width: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.only(bottom: 40),
                          child: state.isSpeaking
                          ? Container(
                              height: MediaQuery.of(context).size.width / 2,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Lottie.asset('assets/lottie/sspeaking.json',
                                  repeat: true, fit: BoxFit.cover),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Lottie.asset('assets/lottie/audioss.json',
                                    repeat: true),
                                // Image.asset(
                                //   "assets/images/audio_icon.png",
                                //   width: 40,
                                //   height: 40,
                                // )
                              ],
                            )
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
