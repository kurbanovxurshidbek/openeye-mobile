import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../views/bottom_sheets.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({Key? key}) : super(key: key);

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //load sound from assets

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    play();
  }

  play() async {
    String welcomeRu = "assets/sounds/welcome_home_ru.mp3";
    late ByteData bytes;
    bytes = await rootBundle.load(welcomeRu);
    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await audioPlayer.playBytes(soundbytes);
    if (result == 1) {
      //play success
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Center(
          child: RaisedButton(
            onPressed: () {
              saveAudioDialog(context);
            },
            shape: CircleBorder(),
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.arrow_back,
              size: 25,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width - 50,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/images/audio_book.png",
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.bottomLeft,
                        height: MediaQuery.of(context).size.height * 0.5,
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
                          "Choqintirgan ota",
                          style: Theme.of(context).textTheme.headline2,
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
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (double value) async {
                        final position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);
                      }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(position.inSeconds.toDouble().toString()),
                      Text(duration.inSeconds.toDouble().toString()),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        onPressed: () {},
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.keyboard_double_arrow_left_sharp,
                          size: 30,
                        )),
                    RaisedButton(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      onPressed: () {
                        if (isPlaying) {
                          audioPlayer.pause();
                        } else {
                          audioPlayer.resume();
                        }
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {},
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.keyboard_double_arrow_right,
                        size: 30,
                      ),
                    ),
                    RaisedButton(
                        onPressed: () {},
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.download,
                          size: 30,
                        )),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
