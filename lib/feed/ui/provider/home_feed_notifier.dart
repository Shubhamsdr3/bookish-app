import 'package:bookish_module/data/feed_data.dart';
import 'package:bookish_module/exchange/controller/chatlist_controller.dart';
import 'package:bookish_module/exchange/ui/chat_list_screen.dart';
import 'package:bookish_module/feed/domain/delete_post_use_case.dart';
import 'package:bookish_module/feed/domain/get_feed_user_case.dart';
import 'package:bookish_module/firebase/firestore_util.dart';
import 'package:bookish_module/onboarding/screen/bookish_login_screen.dart';
import 'package:bookish_module/preview/screen/post_preview_screen.dart';
import 'package:bookish_module/util/share_util.dart';
import 'package:bookish_module/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:network_service/exceptions/unauthorized_exception.dart';
import 'package:network_service/util/user_store.dart';

import 'home_feed_provider.dart';
import 'home_feed_state.dart';

class HomeFeedNotifier extends Notifier<HomeFeedState> {
  late final GetFeedUserCase _getFeedUseCase;
  late final DeletePostUseCase _deletePostUseCase;
  final FireStoreUtil _fireStoreUtil = FireStoreUtil();
  final ScrollController scrollController = ScrollController();

  @override
  HomeFeedState build() {
    _getFeedUseCase = ref.watch(getFeedUseCaseProvider);
    _deletePostUseCase = ref.watch(deletePostUseCaseProvider);

    // Auto-fetch on build
    Future.microtask(() {
      _init();
    });

    ref.onDispose(() {
      scrollController.dispose();
    });

    return const HomeFeedState();
  }

  Future<void> _init() async {
    _loadUserId();
    _loadUserProfile();
    _loadNotificationCount();
    scrollController.addListener(_scrollListener);
    await fetchFeed();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (state.hasNextPage && !state.isPageLoading) {
        loadNextPage();
      }
    }
  }

  Future<void> _loadUserId() async {
    final userId = await UserStore.getUserId();
    state = state.copyWith(currentUserId: userId);
  }

  Future<void> _loadUserProfile() async {
    final profileIcon = await UserStore.getUserProfileIcon();
    state = state.copyWith(userProfileIcon: profileIcon ?? '');
  }

  Future<void> _loadNotificationCount() async {
    final userId = await UserStore.getUserId();
    if (userId.isEmpty) return;
    final count = await _fireStoreUtil.getNewNotificationCount(userId);
    state = state.copyWith(notificationCount: count);
  }

  Future<void> fetchFeed({int page = 1, int offset = 10}) async {
    if (page == 1) {
      state = state.copyWith(status: HomeFeedStatus.loading);
    } else {
      state = state.copyWith(isPageLoading: true);
    }
    final result = await _getFeedUseCase(page: page, offset: offset);
    result.fold(
      (failure) {
        _handleError(failure.message);
      },
      (feedResponse) {
        final existingFeeds = page > 1 ? state.feeds : <FeedData>[];
        state = state.copyWith(
          status: HomeFeedStatus.loaded,
          feeds: [...existingFeeds, ...feedResponse.data ?? []],
          currentPage: feedResponse.currentPage ?? page,
          hasNextPage: feedResponse.hasNextPage ?? false,
          isPageLoading: false,
        );
      },
    );
  }

  void _handleError(String errorMessage) {
    state = state.copyWith(
      status: HomeFeedStatus.error,
      errorMessage: errorMessage,
      isPageLoading: false,
    );

    if (errorMessage.contains('UnAuthorizedException') ||
        errorMessage.contains('401')) {
      Get.toNamed(LoginScreen.routeName);
    } else {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("Check if VPN is off.")),
        );
      }
    }
  }

  Future<void> loadNextPage() async {
    if (!state.hasNextPage || state.isPageLoading) return;
    await fetchFeed(page: state.currentPage + 1);
  }

  Future<void> onRefresh() async {
    state = state.copyWith(
      feeds: [],
      currentPage: 1,
      hasNextPage: false,
    );
    await fetchFeed();
  }

  Future<void> deletePost(FeedData feedData) async {
    final result = await _deletePostUseCase(feedData);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: HomeFeedStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        final updatedFeeds = state.feeds
            .where((f) => f.post?.postId != feedData.post?.postId)
            .toList();
        state = state.copyWith(feeds: updatedFeeds);
      },
    );
  }

  Future<void> showNotification() async {
    final userId = await UserStore.getUserId();
    Get.toNamed("notification", arguments: {"userId": userId});
  }

  void showChatList() {
    Get.toNamed(
      UserChatListScreen.routeName,
      arguments: ChatListScreenArgs(
        feedPost: state.feeds.isNotEmpty ? state.feeds.first : null,
      ),
    );
  }

  void onSaveClicked() {
    Utility.showToast("Saved");
  }

  void openPreViewScreen(FeedData feedData) {
    Get.toNamed(PostPreviewScreen.routeName, arguments: feedData);
  }

  void openExchangeScreen(FeedData feedData) {
    Get.toNamed(
      UserChatListScreen.routeName,
      arguments: ChatListScreenArgs(feedPost: feedData),
    );
  }

  void onShareClicked(FeedData feedData) {
    String? postId = feedData.post?.postId;
    if (postId == null || postId.isEmpty) return;
    final postImages = feedData.post?.images;
    if (postImages == null || postImages.isEmpty) return;
    ShareUtil.sharePost(postId, feedData.post?.caption ?? '', postImages);
  }
}

final homeFeedNotifierProvider =
    NotifierProvider<HomeFeedNotifier, HomeFeedState>(
  HomeFeedNotifier.new,
);
