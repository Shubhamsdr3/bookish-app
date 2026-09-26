import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class NativeMethodCallService {
  Future<dynamic> invokeNative(String method, Map<String, dynamic> args);
}

class NativeMethodHandler extends NativeMethodCallService {
  static final NativeMethodHandler shared = NativeMethodHandler._internal();

  String channelId = "channel:com.bookish.app";

  late MethodChannel channel;

  NativeMethodHandler._internal() {
    channel = MethodChannel(channelId);
  }

  @override
  Future invokeNative(String method, Map<String, dynamic> args) async {
    return await channel.invokeMethod(method, args);
  }

  setMessageHandler() {
    channel.setMethodCallHandler((call) async {
      var args = call.arguments;
      switch (call.method) {
        case "getRandomNumber": {
          debugPrint("Shubham: This is random number ${args['number']}");
        }
      }
    });
  }
}
