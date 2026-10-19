import 'package:flutter/services.dart';

typedef NativeProfileActionHandler = void Function(String action);

/// Dart side of [com.newaura.bookish/native_profile].
///
/// Pushes profile UI state to Compose; receives navigation actions back.
class NativeProfileBridge {
  NativeProfileBridge._() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  static final NativeProfileBridge instance = NativeProfileBridge._();

  static const MethodChannel _channel =
      MethodChannel('com.newaura.bookish/native_profile');

  NativeProfileActionHandler? _onAction;

  void setActionHandler(NativeProfileActionHandler? handler) {
    _onAction = handler;
  }

  Future<void> updateState({
    required String status,
    required String userName,
    required String phoneNumber,
    required String profileIconUrl,
    required String localImagePath,
    required String appVersion,
    required bool isOwner,
    required bool isImageUploading,
    required bool isDebug,
    required String errorMessage,
  }) {
    return _channel.invokeMethod<void>('updateState', <String, Object?>{
      'status': status,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'profileIconUrl': profileIconUrl,
      'localImagePath': localImagePath,
      'appVersion': appVersion,
      'isOwner': isOwner,
      'isImageUploading': isImageUploading,
      'isDebug': isDebug,
      'errorMessage': errorMessage,
    });
  }

  Future<void> _onMethodCall(MethodCall call) async {
    if (call.method != 'onAction') {
      return;
    }
    final Object? arguments = call.arguments;
    if (arguments is! Map) {
      return;
    }
    final Object? action = arguments['action'];
    if (action is! String || action.isEmpty) {
      return;
    }
    _onAction?.call(action);
  }
}

/// Status strings must match [ProfileUiState] on Android.
abstract final class NativeProfileStatus {
  static const String loading = 'loading';
  static const String loaded = 'loaded';
  static const String error = 'error';
}

abstract final class NativeProfileAction {
  static const String editProfile = 'editProfile';
  static const String shareFeedback = 'shareFeedback';
  static const String openSettings = 'openSettings';
  static const String logout = 'logout';
  static const String retry = 'retry';
  static const String openGallery = 'openGallery';
  static const String openCamera = 'openCamera';
}
