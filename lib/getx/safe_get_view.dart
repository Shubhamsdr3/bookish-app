import 'package:bookish_module/getx/safe_get.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class SafeGetView<T extends GetxController> extends StatelessWidget {
  const SafeGetView({Key? key}) : super(key: key);

  /// Safe controller access
  T? get controller => SafeGet.findSafe<T>();

  /// Builder pattern for safe access
  Widget buildWithController(BuildContext context, T controller);

  /// Fallback widget when controller not found
  Widget buildFallback(BuildContext context) {
    return const Center(
      child: Text('Controller not found'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    if (ctrl == null) {
      return buildFallback(context);
    }
    return buildWithController(context, ctrl);
  }
}