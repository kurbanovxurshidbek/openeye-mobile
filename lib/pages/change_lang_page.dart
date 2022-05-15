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

class _LangChangePageState extends State<LangChangePage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<SpeechToTextCubit>(context).initSpeech();

    BlocProvider.of<MediaplayerCubit>(context)
        .onComplatedAudioAndStart(context);
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
                        width: 100,
                        height: 100,
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
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4000),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/blind1.jpg")),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Container(
                            width: 200,
                            height: 200,
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
                      height: 200,
                      width: 200,
                      margin: EdgeInsets.only(bottom: 40),
                      child: state.isSpeaking
                          ? Container(
                              height: 300,
                              width: 300,
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
