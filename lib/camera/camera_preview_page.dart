import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:share_plus/share_plus.dart';

class CameraPreviewPage extends StatelessWidget {
  const CameraPreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview'), actions: [
        Padding(
            padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: _createPostButton(context)),
      ]),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(picture.path), fit: BoxFit.cover),
          const SizedBox(height: 24),
          Text(picture.name)
        ]),
      ),
    );
  }

  Widget _createPostButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(10.0),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.pop(context, picture);
              Navigator.pop(context, picture);
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
