import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageGridWidget extends StatelessWidget {
  final List<String> imagePaths;
  final void Function(int) onRemoved;

  const ImageGridWidget({
    super.key,
    required this.imagePaths,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Colors.blueGrey, width: 1),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          padding: EdgeInsets.all(8.r),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return SingleImageCard(
              imagePath: imagePaths[index],
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
