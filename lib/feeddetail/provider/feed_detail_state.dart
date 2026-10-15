import 'package:bookish/data/book_detail.dart';
import 'package:bookish/data/feed_data.dart';

enum FeedDetailStatus { initial, loading, loaded, error }

class FeedDetailState {
  final FeedDetailStatus status;
  final FeedData? feedData;
  final BookDetail? bookDetail;
  final String? errorMessage;

  const FeedDetailState({
    this.status = FeedDetailStatus.initial,
    this.feedData,
    this.bookDetail,
    this.errorMessage,
  });

  FeedDetailState copyWith({
    FeedDetailStatus? status,
    FeedData? feedData,
    BookDetail? bookDetail,
    String? errorMessage,
  }) {
    return FeedDetailState(
      status: status ?? this.status,
      feedData: feedData ?? this.feedData,
      bookDetail: bookDetail ?? this.bookDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

