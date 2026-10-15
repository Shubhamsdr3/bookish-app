import 'package:bookish/data/feed_data.dart';
import 'package:get/get.dart';

class AppState {
  AppState._privateConstructor();

  static final AppState _instance = AppState._privateConstructor();

  factory AppState() {
    return _instance;
  }

  RxInt _tabIndex = 0.obs;
  RxInt get tabIndex => _tabIndex;

  Rx<FeedData?> feedData = FeedData().obs;
  Rx<FeedData?> get getFeedData => feedData;

  void setTabIndex(int index) {
    _tabIndex.value = index;
  }

  void setFeedData(FeedData? data) {
    feedData.value = data;
  }
}