import 'package:bookish_module/getx/safe_get.dart';
import 'package:get/get.dart';

import '../getX/counter_controller.dart';

class DependencyInjection {
  static void init() {
    // Use SafeGet for all registrations
    SafeGet.findOrPut(() => CounterController(), permanent: true);
  }

  static void dispose() {
    // Safe cleanup
    if (SafeGet.isRegistered<CounterController>()) {
      Get.delete<CounterController>();
    }
  }
}
