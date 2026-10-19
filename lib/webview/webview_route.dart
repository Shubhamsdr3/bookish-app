import 'package:bookish/webview/in_app_webview.dart' deferred as webview;
import 'package:flutter/material.dart';

const String webviewRouteName = '/bookish-webview';

class WebViewRoute extends StatefulWidget {
  const WebViewRoute({super.key});

  @override
  State<WebViewRoute> createState() => _WebViewRouteState();
}

class _WebViewRouteState extends State<WebViewRoute> {
  late final Future<void> _libraryFuture;

  @override
  void initState() {
    super.initState();
    _libraryFuture = webview.loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _libraryFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Webview')),
            body: Center(
              child: Text('Could not load web view: ${snapshot.error}'),
            ),
          );
        }
        return webview.InAppWebView();
      },
    );
  }
}
