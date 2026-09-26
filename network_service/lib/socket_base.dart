import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';

typedef EventHandler<T> = dynamic Function(T data);

class SocketBase {
  Socket? _socket;

  static const String TAG = "SocketBase";

  init({required String baseUrl}) {
    _socket = io(
        baseUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
  }

  void connect({bool enableConnectionLogs = false}) {
    if (null == _socket) {
      debugPrint("$TAG: socket is null");
      return;
    }
    debugPrint("$TAG: connecting to socket..");
    _socket?.connect();
    if(enableConnectionLogs) _enableLogs();
  }

  void onConnect(EventHandler handler) {
    _socket?.onConnect((data) {
      handler.call(data);
    });
  }

  void _enableLogs() {
    debugPrint("Enabling socket logs");
    // coverage:ignore-start
    _socket?.onConnect((data) {
      debugPrint("Socket Connected $data");
    });

    _socket?.onConnectError((data) {
      debugPrint("Socket onConnectError $data");
    });

    // _socket?.onConnectTimeout((data) {
    //   debugPrint("Socket onConnectTimeout $data");
    // });

    _socket?.onError((error) {
      debugPrint("Socket onError $error");
    });

    _socket?.onDisconnect((data) {
      debugPrint("onDisconnect $data");
    });
    // coverage:ignore-end
  }

  void clearSocket() {
    if (_socket != null) {
      debugPrint("Socket Cleared");
      _socket?.disconnect();
      _socket?.close();
      _socket?.clearListeners();
      _socket?.dispose();
    }
  }
}
