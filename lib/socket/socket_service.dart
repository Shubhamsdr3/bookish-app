import 'package:network_service/util/constants.dart';
import 'package:network_service/util/user_store.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  static String socketUrl = Constants.SOCKET_URL;

  Future<void> initSocket() async {
    final authToken  = await UserStore.getAuthToken();
    socket = IO.io(socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': authToken})
            .enableAutoConnect()
            .enableReconnection()
            .build()
    );

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onError((data) {
      print('Socket error: $data');
    });
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void disconnect() {
    socket.disconnect();
  }
}