import 'dart:async';
import 'dart:isolate';

/// 1. Data Model representing the live feed payload
class LiveStockPrice {
  final String symbol;
  final double price;
  final String timestamp;

  LiveStockPrice({required this.symbol, required this.price, required this.timestamp});
}

/// 2. The Bridge manager that wraps the Isolate into a Stream
class BackgroundFeedManager {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  StreamController<LiveStockPrice>? _streamController;

  /// Starts the isolate and returns a cold stream of data
  Stream<LiveStockPrice> startFeed() {
    _streamController = StreamController<LiveStockPrice>.broadcast(
      onListen: _spawnIsolate,
      onCancel: stopFeed,
    );
    return _streamController!.stream;
  }

  void _spawnIsolate() async {
    _receivePort = ReceivePort();

    // Spawn the background worker, passing it the communication port
    _isolate = await Isolate.spawn(_isolateEntryPoint, _receivePort!.sendPort);

    // Listen to raw messages coming from the background Isolate
    _receivePort!.listen((message) {
      if (message is List) {
        final stock = LiveStockPrice(
          symbol: message[0] as String,
          price: message[1] as double,
          timestamp: message[2] as String,
        );
        _streamController?.add(stock);
      }
    });
  }

  void stopFeed() {
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.beforeNextEvent);
    _streamController?.close();
    _isolate = null;
    _receivePort = null;
  }

  /// 3. BACKGROUND ENTRY POINT (Runs entirely on a separate isolate heap)
  static void _isolateEntryPoint(SendPort mainIsolatePort) {
    // Simulate a continuous socket connection dropping messages every 500ms
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final now = DateTime.now().toIso8601String();
      final mockData = ['AAPL', 175.50 + (timer.tick % 5), now];

      // Send the data package over the port to the main UI isolate
      mainIsolatePort.send(mockData);
    });
  }
}
