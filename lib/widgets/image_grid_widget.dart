import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageGridWidget extends StatelessWidget {
  final List<XFile> imageFiles;
  final Function(int) onRemoved;

  const ImageGridWidget(
      {super.key, required this.imageFiles, required this.onRemoved});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.blueGrey, width: 1),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // number of items in each row
            mainAxisSpacing: 8.0, // spacing between rows
            crossAxisSpacing: 8.0, // spacing between columns
          ),
          padding: EdgeInsets.all(8.r),
          itemCount: imageFiles.length,
          itemBuilder: (context, index) {
            final item = imageFiles[index];
            return SingleImageCard(
              imagePath: item.path,
              onCrossClicked: () {
                onRemoved(index);
              },
            );
          },
        ),
      ),
    );
  }
}

class SingleImageCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onCrossClicked;

  const SingleImageCard(
      {super.key, required this.imagePath, required this.onCrossClicked});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.file(
            File(imagePath),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 4.r,
              right: 4.r,
              child: InkWell(
                child: Icon(
                  Icons.cancel,
                  size: 32.r,
                ),
                onTap: () {
                  onCrossClicked.call();
                },
              )),
        ],
      ),
    );
  }
}
