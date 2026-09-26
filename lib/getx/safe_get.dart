import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

/// Safe wrapper around Get.find() with proper error handling
class SafeGet {
  /// Find with null safety and error handling
  static T? findSafe<T>({String? tag}) {
    try {
      return Get.find<T>(tag: tag);
    } catch (e) {
      if (kDebugMode) {
        print('SafeGet: Controller $T not found. Error: $e');
      }
      return null;
    }
  }

  /// Find or create (lazy initialization)
  static T findOrPut<T>(T Function() builder, {String? tag, bool permanent = false}) {
    try {
      return Get.find<T>(tag: tag);
    } catch (e) {
      if (kDebugMode) {
        print('SafeGet: Controller $T not found, creating new instance');
      }
      return Get.put<T>(builder(), tag: tag, permanent: permanent);
    }
  }

  /// Check if dependency exists
  static bool isRegistered<T>({String? tag}) {
    return Get.isRegistered<T>(tag: tag);
  }

  /// Force find (throws if not found)
  static T findOrThrow<T>({String? tag, String? errorMessage}) {
    if (!Get.isRegistered<T>(tag: tag)) {
      throw StateError(errorMessage ?? 'Controller $T not registered');
    }
    return Get.find<T>(tag: tag);
  }
}