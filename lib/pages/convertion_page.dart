import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/connection/internet_cubit.dart';
import 'package:key_board_app/cubits/convertion/convertion_cubit.dart';
import 'package:key_board_app/cubits/convertion/convertion_state.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/navigators/goto.dart';
import 'package:key_board_app/pages/reading_audio_page.dart';
import 'package:key_board_app/views/dialogs.dart';
import 'package:lottie/lottie.dart';

class ConvertionPage extends StatefulWidget {
  bool isCamera;
  String? image;

  ConvertionPage({Key? key, this.image, required this.isCamera})
      : super(key: key);

  @override
  State<ConvertionPage> createState() => _ConvertionPageState();
}

class _ConvertionPageState extends State<ConvertionPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isCamera == false && widget.image == null) {
      BlocProvider.of<ConvertionCubit>(context).succesLoadedPdfText();
    } else {
      BlocProvider.of<ConvertionCubit>(context).succesLoadedImageText(
          widget.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: BlocBuilder<InternetCubit, InternetState>(

            builder: (context, internetsate) {
              return BlocListener<ConvertionCubit, ConvertionState>(

                listener: (context, state) {
                  if(internetsate is InternetDisconnected){
                    connectionDialog(context );

// print((audioModel.toJson());

                  }
                  if (state.error) {
                    errorDialog(context, !widget.isCamera);
                  }

                  if (state.audioModel != null) {
                    GOTO.pushRP(
                        context,
                        ReadingPage(
                            listAudio: [state.audioModel!], startOnIndex: 0));
                  }
                },
                child: BlocBuilder<ConvertionCubit, ConvertionState>(
                  builder: (context, state) {
                    return circuleProgresIndicator(state);
                  },
                ),
              );
            },
          )
      ),
    );
  }

  Widget circuleProgresIndicator(ConvertionState state) {
    return Container(
      alignment: Alignment.center,
      child: state.isConverting
          ? SizedBox(
        width: 150,
        height: 150,
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 20,

                ),
              ),
            ),
            Center(
              child: Lottie.asset('assets/lottie/convrting.json',
                  fit: BoxFit.cover, repeat: true),
            ),
          ],
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}
