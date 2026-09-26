import 'package:shared_preferences/shared_preferences.dart';

class AppEnvironment {
  static final AppEnvironment _shared = AppEnvironment._internal();

  AppEnvironment._internal();

  factory AppEnvironment() {
    return _shared;
  }

  bool get isDebugMode {
    return const bool.hasEnvironment('isDebugMode')
        ? const bool.fromEnvironment('isDebugMode')
        : true;
  }

  static Future<bool> getEnvironment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDebugMode") ?? false;
  }

  static setEnvironment(bool isDebugMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDebugMode", isDebugMode);
  }
}
