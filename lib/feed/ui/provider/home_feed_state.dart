import 'package:bookish/data/feed_data.dart';

enum HomeFeedStatus { initial, loading, loaded, error }

class HomeFeedState {
  final HomeFeedStatus status;
  final List<FeedData> feeds;
  final String? errorMessage;
  final int currentPage;
  final bool hasNextPage;
  final bool isPageLoading;
  final String userProfileIcon;
  final int notificationCount;
  final String currentUserId;

  const HomeFeedState({
    this.status = HomeFeedStatus.initial,
    this.feeds = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasNextPage = false,
    this.isPageLoading = false,
    this.userProfileIcon = '',
    this.notificationCount = 0,
    this.currentUserId = '',
  });

  HomeFeedState copyWith({
    HomeFeedStatus? status,
    List<FeedData>? feeds,
    String? errorMessage,
    int? currentPage,
    bool? hasNextPage,
    bool? isPageLoading,
    String? userProfileIcon,
    int? notificationCount,
    String? currentUserId,
  }) {
    return HomeFeedState(
      status: status ?? this.status,
      feeds: feeds ?? this.feeds,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      userProfileIcon: userProfileIcon ?? this.userProfileIcon,
      notificationCount: notificationCount ?? this.notificationCount,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}
