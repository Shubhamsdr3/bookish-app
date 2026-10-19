import 'dart:async';

import 'package:bookish/native/generated/native_image_api.g.dart';

/// Dart facade over Pigeon [NativeImageHostApi] / [NativeImageFlutterApi].
///
/// Prefer [pickFromGallery] / [pickFromCamera] (one-shot). The broadcast
/// [imageBatches] stream is for demos that only observe picks.
class NativeImagePicker implements NativeImageFlutterApi {
  NativeImagePicker._() {
    NativeImageFlutterApi.setUp(this);
  }

  static final NativeImagePicker instance = NativeImagePicker._();

  final NativeImageHostApi _hostApi = NativeImageHostApi();
  final StreamController<List<String>> _batchesController =
      StreamController<List<String>>.broadcast();

  Completer<List<String>>? _pendingPick;

  /// One event per picker result (may contain multiple gallery paths).
  Stream<List<String>> get imageBatches => _batchesController.stream;

  /// Flattened single-path stream.
  Stream<String> get images =>
      imageBatches.expand((List<String> paths) => paths);

  Future<List<String>> pickFromGallery({bool allowMultiple = false}) {
    return _startPick(() => _hostApi.openGallery(allowMultiple));
  }

  Future<List<String>> pickFromCamera() {
    return _startPick(_hostApi.openCamera);
  }

  /// Fire-and-forget open (demo / Compose). Prefer [pickFromGallery].
  Future<void> openGallery({bool allowMultiple = false}) {
    return _hostApi.openGallery(allowMultiple);
  }

  Future<void> openCamera() {
    return _hostApi.openCamera();
  }

  Future<List<String>> _startPick(Future<void> Function() openNative) {
    if (_pendingPick != null && !_pendingPick!.isCompleted) {
      _pendingPick!.complete(const <String>[]);
    }
    final Completer<List<String>> completer = Completer<List<String>>();
    _pendingPick = completer;
    openNative().catchError((Object error, StackTrace stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  @override
  void onImagesPicked(List<String> paths) {
    final List<String> safePaths = List<String>.unmodifiable(paths);
    if (_pendingPick != null && !_pendingPick!.isCompleted) {
      _pendingPick!.complete(safePaths);
      _pendingPick = null;
    }
    // Empty list = user canceled; still complete the pending Future above.
    if (safePaths.isNotEmpty) {
      _batchesController.add(safePaths);
    }
  }
}
