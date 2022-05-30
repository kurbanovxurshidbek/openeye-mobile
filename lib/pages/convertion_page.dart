import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/convertion/convertion_cubit.dart';
import 'package:key_board_app/navigators/goto.dart';
import 'package:key_board_app/pages/reading_audio_page.dart';
import 'package:lottie/lottie.dart';
import '../cubits/convertion/convertion_state.dart';
import '../views/dialogs.dart';

class ConvertionPage extends StatefulWidget {
   bool isCamera;
   ConvertionPage({Key? key, required this.isCamera}) : super(key: key);

  @override
  State<ConvertionPage> createState() => _ConvertionPageState();
}

class _ConvertionPageState extends State<ConvertionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isCamera == true){
      BlocProvider.of<ConvertionCubit>(context).succesLoaded(true);
    }else{
      BlocProvider.of<ConvertionCubit>(context).succesLoaded(false);
    }
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<ConvertionCubit, ConvertionState>(
          listener: (context, state) {
            if (state.error) {
              errorDialog(context,widget.isCamera);
            }

            if (state.audioModel != null) {
              GOTO.pushRP(context, ReadingPage(listAudio: [state.audioModel!], startOnIndex: 0));
            }
          },
          child: BlocBuilder<ConvertionCubit, ConvertionState>(
            builder: (context, state) {
              return Container(
                alignment: Alignment.center,
                child: state.isConverting
                    ? SizedBox(
                        width: 150,
                        height: 150,
                        child: Center(
                          child: Lottie.asset('assets/lottie/convrting.json',
                              fit: BoxFit.cover, repeat: true),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }
}
