import 'dart:async';

import 'package:bookish_module/search/domain/usecases/search_books_usecase.dart';
import 'package:bookish_module/search/ui/notifiers/search_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchBooksUseCase _searchBooksUseCase;

  Timer? _debounce;

  final List<String> suggestions = const [
    "Hooked",
    "Atomic habits",
    "Lord Of Rings",
    "Civilized to Death",
    "The Great Gatsby",
    "The Alchemist",
  ];

  SearchNotifier({required SearchBooksUseCase searchBooksUseCase})
      : _searchBooksUseCase = searchBooksUseCase,
        super(const SearchState());

  void onSearchChanged(String query) {
    state = state.copyWith(query: query);

    if (query.isEmpty) {
      state = state.copyWith(
        status: SearchStatus.initial,
        items: [],
      );
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery(query);
    });
  }

  Future<void> _searchQuery(String query) async {
    state = state.copyWith(status: SearchStatus.loading);

    final result = await _searchBooksUseCase(query);

    result.fold(
      (failure) {
        debugPrint('Search error: ${failure.message}');
        state = state.copyWith(
          status: SearchStatus.error,
          errorMessage: failure.message,
        );
      },
      (searchResult) {
        state = state.copyWith(
          status: SearchStatus.loaded,
          items: searchResult.items,
        );
      },
    );
  }

  void onSuggestionItemSelected(String item) {
    state = state.copyWith(query: item);
    _searchQuery(item);
  }

  String getAuthors(List<String>? authors) {
    if (authors == null || authors.isEmpty) return '';
    return authors.join(', ');
  }

  void clearSearch() {
    state = const SearchState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}


