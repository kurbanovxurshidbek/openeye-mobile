// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_read_audio_book/reading_audio_book_cubit.dart';
import 'package:key_board_app/cubits/for_read_audio_book/reading_audio_book_state.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/pages/home_page.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:lottie/lottie.dart';

import '../navigators/goto.dart';
import '../views/dialogs.dart';

class ReadingPage extends StatefulWidget {
  List<AudioModel> listAudio;
  int startOnIndex;

  ReadingPage({
    Key? key,
    required this.listAudio,
    required this.startOnIndex,
  }) : super(key: key);

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //load sound from assets
    BlocProvider.of<ReadingAudioBookCubit>(context)
        .startAndLoadAudioFiles(widget.startOnIndex, widget.listAudio);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingAudioBookCubit, ReadingAudioBookState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Semantics(
                    label: "exit".tr(),
                    child: Icon(Icons.arrow_back, color: Colors.blueGrey)),
                onPressed: () async {
                  GOTO.pop(context);
                },
              )),
          body: state.isLoading
              ? Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Container(),
                  ),
                )
              : SafeArea(
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width - 50,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/audbook.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.bottomLeft,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black12,
                                            Colors.black54,
                                          ])),
                                  child: Text(
                                    state.listOfAudio[state.index].name,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Slider(
                                inactiveColor: Colors.blueGrey.shade100,
                                activeColor: Colors.blueGrey.shade600,
                                thumbColor: Colors.blueGrey,
                                min: 0,
                                max: state.duration!.inSeconds.toDouble(),
                                value:
                                    state.currentPosition!.inSeconds.toDouble(),
                                onChanged: (double value) async {
                                  final position =
                                      Duration(seconds: value.toInt());
                                  await state.audioPlayer!.seek(position);
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(((state.currentPosition!.inSeconds / 60)
                                            .toDouble()
                                            .toString() +
                                        "0")
                                    .substring(0, 4)),
                                Text(((state.duration!.inSeconds / 60)
                                            .toDouble()
                                            .toString() +
                                        "0")
                                    .substring(0, 4)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: MaterialButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      BlocProvider.of<ReadingAudioBookCubit>(
                                              context)
                                          .backAudioButton();
                                    },
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(8),
                                    child: Semantics(
                                      label: "back".tr(),
                                      child: Icon(
                                        Icons.keyboard_double_arrow_left_sharp,
                                        color: Colors.blueGrey,
                                        size: 30,
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: MaterialButton(
                                  color: Colors.white,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(20),
                                  onPressed: () {
                                    BlocProvider.of<ReadingAudioBookCubit>(
                                            context)
                                        .stopOrPlayButton();
                                  },
                                  child: Semantics(
                                    label: "pause".tr(),
                                    child: Icon(
                                      state.isPlaying!
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MaterialButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    BlocProvider.of<ReadingAudioBookCubit>(
                                            context)
                                        .nextAudioButton();
                                  },
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(8),
                                  child: Semantics(
                                    label: "next".tr(),
                                    child: Icon(
                                      Icons.keyboard_double_arrow_right,
                                      size: 30,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                ),
        );
      },
    );
  }
}
