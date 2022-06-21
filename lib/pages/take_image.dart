import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_take_image/take_image_cubit.dart';
import 'package:key_board_app/cubits/for_take_image/take_image_state.dart';
import 'package:key_board_app/navigators/goto.dart';
import 'package:key_board_app/pages/convertion_page.dart';

class TakeImagePage extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const TakeImagePage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<TakeImagePage> createState() => _TakeImagePageState();
}

class _TakeImagePageState extends State<TakeImagePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TakeImageCubit>(context).initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    BlocProvider.of<TakeImageCubit>(context).state.cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TakeImageCubit, TakeImageState>(
        builder: (context, state) {
          return Container(
            color: Colors.black,
            child: SafeArea(
                child: state.isOpen == false
                    ? openCamera(state)
                    : openImage(state)),
          );
        },
      ),
    );
  }

  Widget openCamera(TakeImageState state) {
    return Stack(
      children: [
        state.cameraController!.value.isInitialized
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CameraPreview(state.cameraController!),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 65,
                          width: 65,
                          child: FloatingActionButton(
                            child: Icon(
                              Icons.camera,
                              size: 30,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            onPressed: () {
                              BlocProvider.of<TakeImageCubit>(context)
                                  .takePicture();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      child: Icon(
                        Icons.adjust,
                        color: Colors.white,
                        size: 60,
                      ),
                      onPressed: () {
                        BlocProvider.of<TakeImageCubit>(context)
                            .backOrFront(widget.cameras!);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget openImage(TakeImageState state)  {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.file(File(state.image!)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      onPressed: () {
                        GOTO.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      onPressed: () {
                        GOTO.push(
                            context,
                            ConvertionPage(
                              image: state.image,isCamera: true,
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
