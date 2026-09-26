import 'package:bookish_module/socket/socket_service.dart';
import 'package:flutter/material.dart';

class WebsocketScreen extends StatefulWidget {
  const WebsocketScreen({super.key});

  @override
  State<WebsocketScreen> createState() => _WebsocketScreenState();
}

class _WebsocketScreenState extends State<WebsocketScreen> {
  final socketService = SocketService();

  @override
  void initState() {
    socketService.initSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                socketService.emit("message", "Hello from Flutter!");
              },
              child: const Text("Send Message"),
            ),
            ElevatedButton(
              onPressed: () {
                socketService.on("systemStatus", (data) {
                  print("Received message: $data");
                });
              },
              child: const Text("Listen for Messages"),
            ),
          ],
        ),
      ),
    );
  }
}
