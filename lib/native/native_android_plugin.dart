import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../native/hybrid_composition_view.dart';

class NativeAndroidPlugin extends StatefulWidget {
  static String routeName = "/native-android-plugin";

  const NativeAndroidPlugin({super.key});

  @override
  State<NativeAndroidPlugin> createState() => _NativeAndroidPluginState();
}

class _NativeAndroidPluginState extends State<NativeAndroidPlugin> {
  static const MethodChannel _nativeImageChannel =
      MethodChannel('com.newaura.bookish/native_image');

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nativeImageChannel.setMethodCallHandler(_onNativeImageMethodCall);
  }

  @override
  void dispose() {
    _nativeImageChannel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _onNativeImageMethodCall(MethodCall call) async {
    if (call.method != 'onImagePicked') {
      return;
    }
    final Object? arguments = call.arguments;
    if (arguments is! Map) {
      return;
    }
    final Object? path = arguments['path'];
    if (path is! String || path.isEmpty) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _imagePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Android Plugin'),
      ),
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: HybridCompositionView(
              viewType: HybridCompositionView.composeViewType,
            ),
          ),
          Expanded(
            flex: 3,
            child: _imagePath == null
                ? const Center(
                    child: Text('Pick an image from the native buttons above'),
                  )
                : Image.file(
                    File(_imagePath!),
                    fit: BoxFit.contain,
                  ),
          ),
        ],
      ),
    );
  }
}
