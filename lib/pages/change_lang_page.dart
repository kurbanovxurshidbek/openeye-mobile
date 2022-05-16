import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/mainaligment_state.dart';
import 'package:key_board_app/cubits/mediaplayer_cubit.dart';
import 'package:key_board_app/cubits/speech_to_text_cubit.dart';
import 'package:lottie/lottie.dart';

class LangChangePage extends StatefulWidget {
  const LangChangePage({Key? key}) : super(key: key);

  @override
  State<LangChangePage> createState() => _LangChangePageState();
}

class _LangChangePageState extends State<LangChangePage>
    with WidgetsBindingObserver {
  AppLifecycleState? _notification;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

    BlocProvider.of<SpeechToTextCubit>(context).initSpeech();

    BlocProvider.of<MediaplayerCubit>(context)
        .onComplatedAudioAndStart(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed---------------");
        BlocProvider.of<MediaplayerCubit>(context).playAudio();

        break;
      case AppLifecycleState.inactive:
        print("app in inactive------------------------");
        BlocProvider.of<MediaplayerCubit>(context).playAudio();
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
    WidgetsBinding.instance!.removeObserver(this);

    BlocProvider.of<SpeechToTextCubit>(context).stopListening("stop");

    BlocProvider.of<MediaplayerCubit>(context).stopAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter,
                  colors: [
                Color(0xFF443efc),
                Color(0xFF52e5de),
              ])),
          child: BlocBuilder<MainaligmentCubit, MainAligmentState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: state.columnAligment,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/images/logo1.jpg",
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.width / 4,
                      ),
                      Text(
                        "OpenEye",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  state.bottomUp
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4000),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/blind1.jpg")),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4000),
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.2),
                                      Colors.black.withOpacity(0.4)
                                    ])),
                          )),
                  Container(
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(bottom: 40),
                      child: state.isSpeaking
                          ? Container(
                              height: MediaQuery.of(context).size.width / 2,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Lottie.asset('assets/lottie/speaking.json',
                                  repeat: true, fit: BoxFit.cover),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Lottie.asset('assets/lottie/audio.json',
                                    repeat: true),
                                Image.asset(
                                  "assets/images/audio_icon.png",
                                  width: 40,
                                  height: 40,
                                )
                              ],
                            )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
