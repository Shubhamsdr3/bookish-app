import 'package:bookish/data/book_detail.dart';

class SearchState {
  final SearchStatus status;
  final List<BookDetail> items;
  final String query;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.items = const [],
    this.query = '',
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<BookDetail>? items,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      items: items ?? this.items,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum SearchStatus { initial, loading, loaded, error }

