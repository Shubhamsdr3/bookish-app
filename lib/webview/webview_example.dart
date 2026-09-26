import 'package:flutter/material.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Okto app"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("On click"),
          onPressed: () {},
        ),
      ),
    );
  }
}
