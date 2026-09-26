import 'dart:io';

import 'package:bookish_module/createpost/domain/usecases/create_post_usecase.dart';
import 'package:bookish_module/createpost/ui/notifiers/create_post_state.dart';
import 'package:bookish_module/createpost/ui/providers/create_post_providers.dart';
import 'package:bookish_module/data/book_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_service/util/user_store.dart';

class CreatePostNotifier extends Notifier<CreatePostState> {
  late final CreatePostUseCase _createPostUseCase;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  CreatePostState build() {
    _createPostUseCase = ref.watch(createPostUseCaseProvider);
    return const CreatePostState();
  }


  void onCaptionChanged(String value) {
    state = state.copyWith(caption: value);
  }

  void onBookLinkChanged(String value) {
    state = state.copyWith(bookLink: value);
  }

  void onBookSelected(BookDetail? book) {
    if (book != null) {
      state = state.copyWith(
        selectedBook: book,
        bookTitle: book.volumeInfo?.title ?? '',
        isBookSelected: true,
      );
    }
  }

  void clearBookSelection() {
    state = state.copyWith(
      clearBook: true,
      bookTitle: '',
      isBookSelected: false,
    );
  }

  // ─── Image Picking ────────────────────────────────────────────────────

  Future<void> pickImagesFromGallery() async {
    final pickedFiles = await _imagePicker.pickMultiImage(imageQuality: 25);
    if (pickedFiles.isNotEmpty) {
      state = state.copyWith(
        imageFiles: [...state.imageFiles, ...pickedFiles],
      );
    }
  }

  void onCameraFileReceived(XFile file) {
    state = state.copyWith(
      imageFiles: [...state.imageFiles, file],
    );
  }

  void removeImage(int index) {
    final updatedFiles = List<XFile>.from(state.imageFiles)..removeAt(index);
    state = state.copyWith(imageFiles: updatedFiles);
  }

  // ─── Firebase Upload ──────────────────────────────────────────────────

  Future<String> _uploadImageFile(XFile imageFile) async {
    try {
      final file = File(imageFile.path);
      final storageRef =
          FirebaseStorage.instance.ref('post/images/${imageFile.name}');
      final snapshot = await storageRef.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await snapshot.ref.getDownloadURL();
    } catch (ex) {
      debugPrint('Error uploading image: $ex');
      rethrow;
    }
  }

  // ─── Create Post ──────────────────────────────────────────────────────

  Future<bool> createPost() async {
    if (!state.canPost) return false;

    state = state.copyWith(status: CreatePostStatus.loading, clearError: true);

    try {
      final downloadedUrls = await Future.wait(
        state.imageFiles.map((image) => _uploadImageFile(image)),
      );

      final userId = await UserStore.getUserId();
      final bookCategories = state.selectedBook?.volumeInfo?.bookCategories
          ?.map((e) => e.toString())
          .toList();

      final requestBody = {
        'userId': userId,
        'isLiked': false,
        'post': {
          'caption': state.caption,
          'images': downloadedUrls,
          'bookName': state.bookTitle,
          'bookLink': state.bookLink,
          'bookId': state.selectedBook?.bookId ?? '',
          'bookCategories': bookCategories,
        },
      };

      final result = await _createPostUseCase(requestBody);

      return result.fold(
        (failure) {
          state = state.copyWith(
            status: CreatePostStatus.error,
            errorMessage: failure.message,
          );
          return false;
        },
        (feedData) {
          state = state.copyWith(
            status: CreatePostStatus.success,
            createdPost: feedData,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: CreatePostStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
