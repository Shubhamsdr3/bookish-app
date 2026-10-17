import 'dart:io';

import 'package:bookish/createpost/domain/usecases/create_post_usecase.dart';
import 'package:bookish/createpost/ui/notifiers/create_post_state.dart';
import 'package:bookish/createpost/ui/providers/create_post_providers.dart';
import 'package:bookish/data/book_detail.dart';
import 'package:bookish/native/native_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_service/util/user_store.dart';
import 'package:path/path.dart' as path;

class CreatePostNotifier extends Notifier<CreatePostState> {

  late final CreatePostUseCase _createPostUseCase;
  final NativeImagePicker _nativeImagePicker = NativeImagePicker.instance;

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

  Future<void> openGallery() async {
    final List<String> paths =
        await _nativeImagePicker.pickFromGallery(allowMultiple: true);
    if (paths.isEmpty) {
      return;
    }
    state = state.copyWith(
      imagePaths: [...state.imagePaths, ...paths],
    );
  }

  Future<void> openCamera() async {
    final List<String> paths = await _nativeImagePicker.pickFromCamera();
    if (paths.isEmpty) {
      return;
    }
    state = state.copyWith(
      imagePaths: [...state.imagePaths, ...paths],
    );
  }

  void removeImage(int index) {
    final List<String> updatedPaths = List<String>.from(state.imagePaths)
      ..removeAt(index);
    state = state.copyWith(imagePaths: updatedPaths);
  }

  Future<String> _uploadImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      final String fileName = path.basename(imagePath);
      final storageRef =
          FirebaseStorage.instance.ref('post/images/$fileName');
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

  Future<bool> createPost() async {
    if (!state.canPost) return false;

    state = state.copyWith(status: CreatePostStatus.loading, clearError: true);

    try {
      final downloadedUrls = await Future.wait(
        state.imagePaths.map(_uploadImageFile),
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
