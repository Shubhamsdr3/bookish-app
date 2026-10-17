import 'dart:io';

import 'package:bookish/native/native_image_picker.dart';
import 'package:bookish/profile/domain/entities/user_profile_entity.dart';
import 'package:bookish/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:bookish/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:bookish/profile/ui/notifiers/user_profile_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:network_service/util/user_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../providers/profile_providers.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;
  final NativeImagePicker _nativeImagePicker;

  ProfileNotifier({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateProfileImageUseCase updateProfileImageUseCase,
    NativeImagePicker? nativeImagePicker,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _updateProfileImageUseCase = updateProfileImageUseCase,
        _nativeImagePicker = nativeImagePicker ?? NativeImagePicker.instance,
        super(const ProfileState()) {
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      _loadCurrentUserId(),
      _loadAppVersion(),
    ]);
    await fetchUserProfile();
  }

  Future<void> _loadCurrentUserId() async {
    final userId = await UserStore.getUserId();
    state = state.copyWith(currentUserId: userId);
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    state = state.copyWith(appVersion: packageInfo.version);
  }

  Future<void> fetchUserProfile({bool force = false}) async {
    if (!force &&
        state.status == ProfileStatus.loaded &&
        state.profile != null) {
      return;
    }
    state = state.copyWith(status: ProfileStatus.loading);

    final userId = state.currentUserId.isNotEmpty
        ? state.currentUserId
        : await UserStore.getUserId();

    final result = await _getUserProfileUseCase(userId);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) {
        state = state.copyWith(
          status: ProfileStatus.loaded,
          profile: profile,
        );
      },
    );
  }

  Future<void> openGallery() async {
    final List<String> paths = await _nativeImagePicker.pickFromGallery();
    if (paths.isEmpty) {
      return;
    }
    await onNativeImagePicked(paths.first);
  }

  Future<void> openCamera() async {
    final List<String> paths = await _nativeImagePicker.pickFromCamera();
    if (paths.isEmpty) {
      return;
    }
    await onNativeImagePicked(paths.first);
  }

  Future<void> onNativeImagePicked(String path) async {
    state = state.copyWith(localImagePath: path);
    await _uploadImageFile(path);
  }

  Future<void> _uploadImageFile(String imagePath) async {
    try {
      state = state.copyWith(isImageUploading: true);

      final file = File(imagePath);
      final fileName = file.uri.pathSegments.isNotEmpty
          ? file.uri.pathSegments.last
          : 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref('images/$fileName');

      final TaskSnapshot snapshot = await storageRef.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('Downloaded url: $downloadUrl');

      await _updateProfileImage(downloadUrl);
    } on FirebaseException catch (e) {
      debugPrint('Image upload error: $e');
      state = state.copyWith(isImageUploading: false);
    }
  }

  Future<void> _updateProfileImage(String imageUrl) async {
    final result = await _updateProfileImageUseCase(imageUrl);

    result.fold(
      (failure) {
        debugPrint('Profile image update failed: ${failure.message}');
        state = state.copyWith(isImageUploading: false);
      },
      (_) {
        final updatedProfile = state.profile != null
            ? _copyProfileWithImage(state.profile!, imageUrl)
            : null;

        state = state.copyWith(
          isImageUploading: false,
          profile: updatedProfile,
        );
      },
    );
  }

  ImageProvider getProfileImage(String? networkImageUrl) {
    if (state.localImagePath != null) {
      return FileImage(File(state.localImagePath!));
    } else if (networkImageUrl == null || networkImageUrl.isEmpty) {
      return const AssetImage('assets/image/user.png');
    } else {
      return NetworkImage(networkImageUrl);
    }
  }

  UserProfileEntity _copyProfileWithImage(
    UserProfileEntity original,
    String imageUrl,
  ) {
    return UserProfileEntity(
      userId: original.userId,
      userName: original.userName,
      profileIcon: imageUrl,
      phoneNumber: original.phoneNumber,
    );
  }

}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final getUserProfileUseCase = ref.watch(getUserProfileUseCaseProvider);
  final updateProfileImageUseCase =
      ref.watch(updateProfileImageUseCaseProvider);

  return ProfileNotifier(
    getUserProfileUseCase: getUserProfileUseCase,
    updateProfileImageUseCase: updateProfileImageUseCase,
  );
});
