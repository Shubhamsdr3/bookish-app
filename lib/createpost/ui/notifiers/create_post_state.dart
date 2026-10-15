import 'package:bookish/data/book_detail.dart';
import 'package:bookish/data/feed_data.dart';
import 'package:image_picker/image_picker.dart';

enum CreatePostStatus { initial, loading, success, error }

class CreatePostState {
  final CreatePostStatus status;
  final String? errorMessage;
  final FeedData? createdPost;
  final BookDetail? selectedBook;
  final List<XFile> imageFiles;
  final bool isBookSelected;
  final String caption;
  final String bookTitle;
  final String bookLink;

  const CreatePostState({
    this.status = CreatePostStatus.initial,
    this.errorMessage,
    this.createdPost,
    this.selectedBook,
    this.imageFiles = const [],
    this.isBookSelected = false,
    this.caption = '',
    this.bookTitle = '',
    this.bookLink = '',
  });

  bool get canPost =>
      status != CreatePostStatus.loading &&
      bookTitle.isNotEmpty &&
      caption.isNotEmpty;

  CreatePostState copyWith({
    CreatePostStatus? status,
    String? errorMessage,
    FeedData? createdPost,
    BookDetail? selectedBook,
    List<XFile>? imageFiles,
    bool? isBookSelected,
    String? caption,
    String? bookTitle,
    String? bookLink,
    bool clearBook = false,
    bool clearError = false,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdPost: createdPost ?? this.createdPost,
      selectedBook: clearBook ? null : (selectedBook ?? this.selectedBook),
      imageFiles: imageFiles ?? this.imageFiles,
      isBookSelected: isBookSelected ?? this.isBookSelected,
      caption: caption ?? this.caption,
      bookTitle: bookTitle ?? this.bookTitle,
      bookLink: bookLink ?? this.bookLink,
    );
  }
}

