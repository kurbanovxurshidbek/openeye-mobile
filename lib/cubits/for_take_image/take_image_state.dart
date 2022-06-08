import 'package:camera/camera.dart';

class TakeImageState {
  CameraController? cameraController;
  String? image;
  bool isOpen;
  bool error;
  bool isRearCameraSelected;

  TakeImageState(
      {this.cameraController,
      this.image,
      this.isOpen = false,
      this.error = false,
      this.isRearCameraSelected = true});
}
