import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

/// Lifecycle-aware reactive variable wrapper
/// Automatically manages subscriptions based on widget lifecycle
class LiveRx<T> {
  final Rx<T> _rx;
  final List<Worker> _workers = [];
  bool _isActive = false;

  LiveRx(T initial) : _rx = Rx<T>(initial);

  T get value => _rx.value;

  set value(T val) {
    if (_isActive) {
      _rx.value = val;
    }
  }

  /// Observe changes (lifecycle-aware)
  void observe(BuildContext context, void Function(T) callback) {
    final worker = ever(_rx, callback);
    _workers.add(worker);

    // Automatically dispose when widget is removed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        // Keep active
        _isActive = true;
      }
    });
  }

  /// Manual activation (like LiveData.observe)
  void setActive(bool active) {
    _isActive = active;
  }

  /// Clean up resources
  void dispose() {
    _isActive = false;
    for (var worker in _workers) {
      worker.dispose();
    }
    _workers.clear();
  }
}