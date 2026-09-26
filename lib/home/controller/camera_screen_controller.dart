import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../camera/camera_preview_page.dart';

class CameraScreenController extends GetxController {
  late CameraController cameraController;
  RxBool isRearCameraSelected = true.obs;
  RxBool isLoading = true.obs;

  final List<CameraDescription> cameras;

  CameraScreenController({required this.cameras});

  @override
  void onInit() {
    initCamera(cameras[0]);
    super.onInit();
  }

  Future initCamera(CameraDescription cameraDescription) async {
    cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      cameraController.initialize().then((_) {
        isLoading.value = true;
      }).onError((e, s) {
        isLoading.value = false;
        debugPrint("$e $s");
      });
    } on CameraException catch (e) {
      isLoading.value = false;
      debugPrint("camera error $e");
    }
  }

  onCameraRotated() {
    isRearCameraSelected.value = !isRearCameraSelected.value;
    initCamera(cameras[isRearCameraSelected.value ? 0 : 1]);
  }

  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }
    if (cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await cameraController.setFlashMode(FlashMode.off);
      XFile picture = await cameraController.takePicture();
      Navigator.push(
          Get.context!,
          MaterialPageRoute(
              builder: (context) => CameraPreviewPage(
                    picture: picture,
                  )));
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
      return null;
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
