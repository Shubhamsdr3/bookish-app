import 'package:bookish/data/feed_data.dart';
import 'package:bookish/feed/ui/provider/home_feed_provider.dart';
import 'package:bookish/feeddetail/provider/feed_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the currently selected FeedData for the detail screen
class SelectedFeedDataNotifier extends Notifier<FeedData?> {
  @override
  FeedData? build() => null;

  void set(FeedData? feedData) {
    state = feedData;
  }
}

final selectedFeedDataProvider =
    NotifierProvider<SelectedFeedDataNotifier, FeedData?>(
  SelectedFeedDataNotifier.new,
);

class FeedDetailNotifier extends Notifier<FeedDetailState> {

  @override
  FeedDetailState build() {
    final feedData = ref.watch(selectedFeedDataProvider);
    Future.microtask(() => _init());
    return FeedDetailState(feedData: feedData);
  }

  Future<void> _init() async {
    await getBookDetail();
  }

  Future<void> getBookDetail() async {
    final feedData = state.feedData;
    if (feedData == null ||
        feedData.post == null ||
        feedData.post?.bookId == null) {
      state = state.copyWith(
        status: FeedDetailStatus.error,
        errorMessage: "No data found",
      );
      return;
    }

    state = state.copyWith(status: FeedDetailStatus.loading);
    final repository = ref.read(feedRepositoryProvider);
    final result = await repository.fetchBookDetail(feedData.post!.bookId ?? "");
    result.fold(
      (failure) {
        state = state.copyWith(
          status: FeedDetailStatus.error,
          errorMessage: failure.message,
        );
      },
      (response) {
        state = state.copyWith(
          status: FeedDetailStatus.loaded,
          bookDetail: response.data,
        );
      },
    );
  }

  Future<void> deletePost() async {
    final feedData = state.feedData;
    if (feedData == null) return;
    final repository = ref.read(feedRepositoryProvider);
    final result = await repository.deletePost(feedData);
    result.fold(
      (failure) {
        debugPrint("Delete failed: ${failure.message}");
      },
      (_) {
        // Post deleted successfully
      },
    );
  }
}

final feedDetailNotifierProvider =
    NotifierProvider<FeedDetailNotifier, FeedDetailState>(
  FeedDetailNotifier.new,
);
