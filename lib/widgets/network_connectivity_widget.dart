import 'package:bookish/util/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkConnectivityWidget extends GetView<ConnectivityController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internet Connection'),
      ),
      body: Center(
        child: Obx(() => Text(
              controller.connectionType == MConnectivityResult.wifi
                  ? "Wifi Connected"
                  : controller.connectionType == MConnectivityResult.mobile
                      ? 'Mobile Data Connected'
                      : 'No Internet Available',
              style: const TextStyle(fontSize: 20),
            )),
      ),
    );
  }
}
