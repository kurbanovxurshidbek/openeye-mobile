import 'package:flutter/material.dart';

class ReadingAudioPage extends StatefulWidget {
  const ReadingAudioPage({Key? key}) : super(key: key);

  @override
  State<ReadingAudioPage> createState() => _ReadingAudioPageState();
}

class _ReadingAudioPageState extends State<ReadingAudioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [
                Color(0xFF443efc),
                Color(0xFF52e5de),
              ]),
        ),
      )),
    );
  }
}
