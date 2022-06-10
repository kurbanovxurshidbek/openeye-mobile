import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:key_board_app/cubits/for_take_image/take_image_state.dart';
import 'package:key_board_app/logic/kril_to_latin.dart';
import 'package:key_board_app/models/audio_model.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:key_board_app/services/http_service.dart';
import 'package:path_provider/path_provider.dart';

class TakeImageCubit extends Cubit<TakeImageState> {
  TakeImageCubit() : super(TakeImageState());

  bool isRearCameraSelected = true;
  InputImage? inputImage;

  /// #take picture
  Future<String?> takePicture() async {
    if(!state.cameraController!.value.isInitialized) return null;
    if(state.cameraController!.value.isTakingPicture) return null;

    try {
      await state.cameraController!.setFlashMode(FlashMode.off);
      XFile picture = await state.cameraController!.takePicture();
      print("Picture: ${picture.path}");
      if(picture.path.isNotEmpty) {
        emit(TakeImageState(isOpen: true,image: picture.path));
      }
      state.image = picture.path;
      return picture.path;

    } on CameraException catch(e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  /// #camera back or front controller
  void backOrFront(List cameras) {
    isRearCameraSelected = !isRearCameraSelected;
    initCamera(cameras[isRearCameraSelected ? 0 : 1]);
  }

  /// #get camera controller
  Future initCamera(CameraDescription cameraDescription) async {
    CameraController controller = CameraController(cameraDescription, ResolutionPreset.high);
    emit(TakeImageState(cameraController: controller));
    print("Camera: ${controller}");

    try {
      await controller.initialize().then((_) {
        emit(TakeImageState(cameraController: controller));
        print("Controller: $controller");
      });

    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
}