import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'detector_view.dart';

class TextRecognizerView extends StatefulWidget {

  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {

  // var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  var _isAlreadyPopped = false;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() async {
    _canProcess = false;
    // _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            DetectorView(
              title: 'Text Detector',
              customPaint: _customPaint,
              text: _text,
              // onImage: (inputImage) {
                // _processImage(inputImage);
              // },
              initialCameraLensDirection: _cameraLensDirection,
              onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
            )
          ]
      ),
    );
  }

  // Future<void> _processImage(InputImage inputImage) async {
  //   if (!_canProcess) return;
  //   if (_isBusy) return;
  //   _isBusy = true;
  //   final recognizedText = await _textRecognizer.processImage(inputImage);
  //   if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
  //     if(mounted && !_isAlreadyPopped) {
  //       Navigator.of(context).pop(recognizedText);
  //       _isAlreadyPopped = true;
  //     }
  //   } else {
  //     // _text = 'Recognized text:\n\n${recognizedText.text}';
  //     // TODO: set _customPaint to draw boundingRect on top of image
  //     _customPaint = null;
  //   }
  //   _isBusy = false;
  // }
}