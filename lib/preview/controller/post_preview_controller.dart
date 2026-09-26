import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/feed_data.dart';

class PostPreviewController extends GetxController {
  final PageController pagerController = PageController();

  RxInt _activePage = 0.obs;

  RxInt get activePage => _activePage;

  final FeedData feedData;

  PostPreviewController(this.feedData);

  @override
  void onClose() {
    pagerController.dispose();
    super.onClose();
  }

  void setActivePage(int page) {
    _activePage.value = page;
  }

  List<Widget> buildIndicator() {
    final indicators = <Widget>[];
    int size = feedData.post?.images?.length ?? 0;
    for (var i = 0; i < size; i++) {
      if (_activePage == i) {
        indicators.add(_indicatorsTrue());
      } else {
        indicators.add(_indicatorsFalse());
      }
    }
    return indicators;
  }

  // Changes colors based on screen
  Widget _indicatorsTrue() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: 42,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.greenAccent.shade200,
      ),
    );
  }

  Widget _indicatorsFalse() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
    );
  }
}
