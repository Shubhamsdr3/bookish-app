import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookish/createpost/ui/notifiers/create_post_notifier.dart';
import 'package:bookish/createpost/ui/notifiers/create_post_state.dart';

/// Single provider for the entire create-post screen state.
///
/// Uses modern Notifier API (not deprecated StateNotifier).
/// In Riverpod v3, providers auto-dispose by default.
final createPostNotifierProvider =
    NotifierProvider<CreatePostNotifier, CreatePostState>(
  CreatePostNotifier.new,
);
