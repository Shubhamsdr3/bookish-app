import 'package:get/get.dart';
import 'live_rx.dart';

/// Base controller with lifecycle-aware reactive variables
abstract class SafeController extends GetxController {

  final List<LiveRx> _liveRxList = [];
  bool _isDisposed = false;

  /// Create lifecycle-aware Rx variable
  LiveRx<T> createLiveRx<T>(T initial) {
    final liveRx = LiveRx<T>(initial);
    _liveRxList.add(liveRx);
    return liveRx;
  }

  /// Check if controller is disposed
  bool get isDisposed => _isDisposed;

  @override
  void onInit() {
    super.onInit();
    for (var liveRx in _liveRxList) {
      liveRx.setActive(true);
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    // Dispose all LiveRx variables
    for (var liveRx in _liveRxList) {
      liveRx.dispose();
    }
    _liveRxList.clear();
    super.onClose();
  }
}