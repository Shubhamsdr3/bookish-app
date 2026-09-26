import 'package:bookish_module/data/feed_data.dart';
import 'package:bookish_module/feeddetail/provider/book_detail_provider.dart';
import 'package:bookish_module/feeddetail/provider/feed_detail_state.dart';
import 'package:bookish_module/widgets/book_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feed/ui/feed_card_widget.dart';

class FeedDetailArgs {
  final FeedData? feedData;

  FeedDetailArgs(this.feedData);
}

@immutable
class FeedDetailScreen extends ConsumerWidget {
  static String routeName = "/feed-detail";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments as FeedDetailArgs?;
    final feedData = args?.feedData;

    // Set the selected feed data so the notifier can pick it up
    Future.microtask(() {
      ref.read(selectedFeedDataProvider.notifier).set(feedData);
    });

    final state = ref.watch(feedDetailNotifierProvider);
    final notifier = ref.read(feedDetailNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (feedData != null)
              FeedCardWidget(
                feedData: feedData,
                callback: (String postId) {
                  notifier.deletePost();
                },
              ),
            _buildBookDetail(state),
          ],
        ),
      ),
    );
  }

  Widget _buildBookDetail(FeedDetailState state) {
    switch (state.status) {
      case FeedDetailStatus.initial:
      case FeedDetailStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case FeedDetailStatus.error:
        return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
      case FeedDetailStatus.loaded:
        if (state.bookDetail == null) {
          return const Center(child: Text("No book details found"));
        }
        return BookDetailCard(bookDetail: state.bookDetail!);
    }
  }
}
