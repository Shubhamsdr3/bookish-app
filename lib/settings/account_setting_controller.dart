import 'package:bookish/webview/webview_route.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:network_service/base_api_service.dart';

class AccountSettingController extends GetxController {
  late final List<AccountSetting> accountSettings = [
    if (kDebugMode)
      AccountSetting(
        title: 'Open Alice',
        subtitle: '',
        iconUrl: '',
        onClick: () {
          ApiService().alice.showInspector();
        },
      ),
    if (kDebugMode)
      AccountSetting(
        title: 'Open webview',
        subtitle: '',
        iconUrl: '',
        onClick: () {
          Get.toNamed(WebViewRoute.webviewRouteName);
        },
      ),
  ];
}

class AccountSetting {
  final String title;
  final String subtitle;
  final String iconUrl;
  final Function onClick;

  AccountSetting({
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    required this.onClick,
  });
}
