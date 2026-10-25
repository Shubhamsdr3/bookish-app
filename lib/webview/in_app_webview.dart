import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebView extends StatefulWidget {
  static String routeName = "/bookish-webview";

  const InAppWebView({super.key});

  @override
  State<InAppWebView> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  final WebViewController _webViewController = WebViewController();

  @override
  Widget build(BuildContext context) {
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset("assets/web/web_view.html")
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..addJavaScriptChannel(
        "messageFromFlutter",
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            // controller.runJavaScript(getInjectedJs());
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            debugPrint("onHttpError: ${error}");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("onWebResourceError: ${error.description}");
          },
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text("Webview"),
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
