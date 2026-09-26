import 'package:bookish_module/getx/safe_controller.dart';

import 'live_rx.dart';

class CounterController extends SafeController {
  // Lifecycle-aware reactive variable
  late final LiveRx<int> count;

  @override
  void onInit() {
    super.onInit();
    count = createLiveRx<int>(0);
  }

  void increment() {
    if (!isDisposed) {
      count.value++;
    }
  }
}
