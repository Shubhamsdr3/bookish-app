import 'dart:io';

import 'package:bookish/onboarding/controller/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  static String routeName = "/edit-profile";

  final String phoneNumber;
  EditProfileScreen({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    Get.put(EditProfileController(phoneNumber: phoneNumber));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              _buildUserProfile(context, ""),
              SizedBox(
                height: 32.r,
              ),
              Theme(
                data: ThemeData(disabledColor: Colors.blueGrey),
                child: TextFormField(
                  enabled: false,
                  initialValue: controller.phoneNumber,
                  decoration: const InputDecoration(
                      label: Text("Phone number"),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      prefix: Text("+91  "),
                      hintText: "9999999999"),
                  autofocus: true,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Visible to you only.",
                style: GoogleFonts.roboto(
                    fontSize: 14, color: Colors.grey.shade700),
              ),
              SizedBox(
                height: 32.r,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    label: Text("User name"),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    hintText: "@johndoe"),
                onChanged: (newValue) {
                  print(newValue);
                  controller.userNameController.text = newValue;
                },
                autofocus: true,
                controller: controller.userNameController,
              ),
              SizedBox(
                height: 4.r,
              ),
              Text(
                "This is will be visible to everyone.",
                style: GoogleFonts.roboto(
                    fontSize: 14, color: Colors.grey.shade700),
              ),
              SizedBox(
                height: 32.r,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    hintText: "John Doe"),
                onChanged: (newValue) {
                  print(newValue);
                  controller.nameController.text = newValue;
                },
                autofocus: true,
                controller: controller.nameController,
              ),
              SizedBox(
                height: 4.r,
              ),
              Text(
                "Visible to you only.",
                style: GoogleFonts.roboto(
                    fontSize: 14, color: Colors.grey.shade700),
              ),
              SizedBox(
                height: 24.r,
              ),
              Obx(
                () => SizedBox(
                  height: 50.r,
                  width: 60.r,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.isLoading.value
                          ? null
                          : controller.onSubmitClicked();
                    },
                    icon: controller.isLoading.value
                        ? _showLoader()
                        : Container(),
                    style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.teal)),
                    label: const Text("Submit"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, String? imageUrl) {
    return Center(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (builder) => _choseProfilePicture(context));
        },
        child: Stack(
          children: [
            _profileLoaderImage(imageUrl ?? ""),
            Positioned(
                bottom: 8.r,
                right: 8.r,
                child: Icon(
                  Icons.camera_alt,
                  size: 32.r,
                  color: Colors.teal,
                )),
          ],
        ),
      ),
    );
  }

  Widget _choseProfilePicture(BuildContext context) {
    return SizedBox(
      height: 160.r,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Chose profile picture",
                  style: TextStyle(fontSize: 18),
                )),
            SizedBox(
              height: 12.r,
            ),
            Row(
              children: [
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          controller.onCameraClicked(ImageSource.gallery);
                        },
                        icon: Icon(
                          Icons.photo,
                          size: 32.r,
                        )),
                    const Text("Gallery")
                  ],
                ),
                SizedBox(
                  width: 46.r,
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          controller.onCameraClicked(ImageSource.camera);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 32.r,
                        )),
                    const Text("Camera")
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _profileLoaderImage(String networkImageUrl) {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundImage: controller.imageFile.value != null
                ? FileImage(File(controller.imageFile.value?.path ?? ""))
                : NetworkImage(networkImageUrl) as ImageProvider,
            radius: 80.r,
          ),
          if (controller.imageLoading.value) const CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget _showLoader() {
    return Container(
      width: 24.r,
      height: 24.r,
      padding: const EdgeInsets.all(2.0),
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }
}
