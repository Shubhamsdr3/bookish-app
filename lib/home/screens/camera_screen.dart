import 'package:bookish/home/controller/camera_screen_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CameraScreen extends GetView<CameraScreenController> {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  Widget build(BuildContext context) {
    Get.put(CameraScreenController(cameras: cameras));
    return Scaffold(
        body: SafeArea(
      child: Obx(
        () => Stack(children: [
          (controller.isLoading.value)
              ? CameraPreview(controller.cameraController)
              : Container(
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator())),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    color: Colors.black),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30.r,
                        icon: Icon(
                            controller.isRearCameraSelected.value
                                ? CupertinoIcons.switch_camera
                                : CupertinoIcons.switch_camera_solid,
                            color: Colors.white),
                        onPressed: () {
                          controller.onCameraRotated();
                        },
                      )),
                      Expanded(
                          child: IconButton(
                        onPressed: controller.takePicture,
                        iconSize: 50.r,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.circle, color: Colors.white),
                      )),
                      const Spacer(),
                    ]),
              )),
        ]),
      ),
    ));
  }
}
