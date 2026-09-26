import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatelessWidget {

  final Function(ImageSource source) onChosePictureClicked;

  const ProfileWidget({super.key, required this.onChosePictureClicked});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        onPressed: () =>
                            onChosePictureClicked(ImageSource.gallery),
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
                        onPressed: () =>
                            onChosePictureClicked(ImageSource.camera),
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
}
