import 'package:flutter_riverpod/legacy.dart';

import '../notifiers/search_notifier.dart';
import '../notifiers/search_state.dart';
import 'search_providers.dart';

/// Single provider for the entire search screen state.
final searchNotifierProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  final searchBooksUseCase = ref.watch(searchBooksUseCaseProvider);
  return SearchNotifier(searchBooksUseCase: searchBooksUseCase);
});


