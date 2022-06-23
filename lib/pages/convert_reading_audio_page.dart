import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/cubits/convert_and_reading/convert_and_reading_state.dart';
import 'package:key_board_app/main.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/pages/home_page.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:lottie/lottie.dart';
import '../cubits/convert_and_reading/convert_and_reading_cubit.dart';
import '../navigators/goto.dart';
import '../views/dialogs.dart';

class ConvertAndReadingPage extends StatefulWidget {
  ConvertAndReadingPage({
    Key? key,
  }) : super(key: key);
  @override
  State<ConvertAndReadingPage> createState() => _ConvertAndReadingPageState();
}

class _ConvertAndReadingPageState extends State<ConvertAndReadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //load sound from assets
    print("asdfasdfasdfasdffffffff");

    BlocProvider.of<ConvertAndReadingCubit>(context)
        .readDocumentDataAndListeningOnStream();
  }

  Future<bool> _readDate(String name) async {
    List<dynamic>? listMap = await HiveDB.loadCountryCode(key: "listOfAudio");

    List<String> listOfAudioModels = [];
    if (listMap == null) {
      listMap = [];
    }

    listOfAudioModels =
        List.generate(listMap.length, (index) => listMap![index]["name"]);

    return listOfAudioModels.contains(name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    BlocProvider.of<ConvertAndReadingCubit>(context).removeLitening();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConvertAndReadingCubit, ConvertAndReadingState>(
      listener: (context, listening) {
        if (listening.error == Errors.file) {
          GOTO.pushRpUntil(context, HomePage());
        } else if (listening.error == Errors.network) {
          errorDialog(context, true);
        }
      },
      child: BlocBuilder<ConvertAndReadingCubit, ConvertAndReadingState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: (() async {
              bool isSaved =
                  await _readDate(state.listOfAudio[state.index].name);

              if (isSaved) {
                BlocProvider.of<ConvertAndReadingCubit>(context).stop();

                return true;
              }

              await saveAudioDialog(context, state.listOfAudio, isBack: true);
              BlocProvider.of<ConvertAndReadingCubit>(context).stop();

              return false;
            }),
            child: state.isConverting
                ? Center(
                    child: Container(),
                  )
                : state.isLoading
                    ? Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Lottie.asset('assets/lottie/convrting.json',
                                fit: BoxFit.cover, repeat: true),
                          ),
                        ),
                      )
                    : Scaffold(
                        appBar: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            leading: IconButton(
                              icon: Semantics(
                                  label: "exit".tr(),
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.blueGrey)),
                              onPressed: () async {
                                bool isSaved = await _readDate(
                                    state.listOfAudio[state.index].name);

                                if (isSaved) {
                                  BlocProvider.of<ConvertAndReadingCubit>(
                                          context)
                                      .stop();

                                  GOTO.pushRpUntil(context, HomePage());
                                  return;
                                }

                                await saveAudioDialog(
                                    context, state.listOfAudio,
                                    isBack: true);
                                BlocProvider.of<ConvertAndReadingCubit>(context)
                                    .stop();

                                return;
                              },
                            )),
                        body: SafeArea(
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            "assets/images/audbook.png",
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          alignment: Alignment.bottomLeft,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.black12,
                                                    Colors.black54,
                                                  ])),
                                          child: Text(
                                            state.listOfAudio[state.index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          alignment: Alignment.topLeft,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            ((100 *
                                                        state.listOfAudio
                                                            .length /
                                                        state.total))
                                                    .toString()
                                                    .substring(0, 3) +
                                                " %",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Slider(
                                        inactiveColor: Colors.blueGrey.shade100,
                                        activeColor: Colors.blueGrey.shade600,
                                        thumbColor: Colors.blueGrey,
                                        min: 0,
                                        max: state.duration!.inSeconds
                                            .toDouble(),
                                        value: state.currentPosition!.inSeconds
                                            .toDouble(),
                                        onChanged: (double value) async {
                                          final position =
                                              Duration(seconds: value.toInt());
                                          await state.audioPlayer!
                                              .seek(position);
                                        }),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            ((state.currentPosition!.inSeconds /
                                                            60)
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              BlocProvider.of<
                                                          ConvertAndReadingCubit>(
                                                      context)
                                                  .backAudioButton();
                                            },
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(8),
                                            child: Semantics(
                                              label: "back".tr(),
                                              child: Icon(
                                                Icons
                                                    .keyboard_double_arrow_left_sharp,
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
                                            BlocProvider.of<
                                                        ConvertAndReadingCubit>(
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
                                            BlocProvider.of<
                                                        ConvertAndReadingCubit>(
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
                                  MaterialButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        bool isSaved = await _readDate(state
                                            .listOfAudio[state.index].name);

                                        if (isSaved) {
                                          return;
                                        }

                                        saveAudioDialog(
                                            context, state.listOfAudio);
                                      },
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(8),
                                      child: Semantics(
                                        label: "download".tr(),
                                        child: Icon(
                                          Icons.download,
                                          color: Colors.blueGrey,
                                          size: 30,
                                        ),
                                      )),
                                ],
                              )),
                        ),
                      ),
          );
        },
      ),
    );
  }
}
