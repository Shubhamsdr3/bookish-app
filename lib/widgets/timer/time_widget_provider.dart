import 'package:flutter/cupertino.dart';

class TimeWidgetProvider with ChangeNotifier {

  String _currentTime = "0";

  String get currentTime => _currentTime;

  setCurrentTime(String time) {
    _currentTime = time;
    notifyListeners();
  }
}