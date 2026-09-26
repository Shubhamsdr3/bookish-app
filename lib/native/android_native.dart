import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidNative extends StatefulWidget {
  const AndroidNative({super.key});

  @override
  State<AndroidNative> createState() => _AndroidNativeWidget();
}

class _AndroidNativeWidget extends State<AndroidNative> {
  int _counter = 0;

  static const platform = MethodChannel('example.com/channel');

  Future<void> _generateRandomNumber() async {
    int random;
    try {
      random = await platform.invokeMethod('getRandomNumber');
    } on PlatformException {
      random = 0;
    }
    setState(() {
      _counter = random;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Android native"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Kotlin generates the following number:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateRandomNumber,
        tooltip: 'Generate',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
