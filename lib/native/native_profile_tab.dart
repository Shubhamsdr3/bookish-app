import 'package:bookish/feedback/screens/feedback_screen.dart';
import 'package:bookish/native/native_profile_bridge.dart';
import 'package:bookish/onboarding/screen/bookish_login_screen.dart';
import 'package:bookish/onboarding/screen/edit_profile_screen.dart';
import 'package:bookish/profile/ui/notifiers/user_profile_state.dart';
import 'package:bookish/profile/ui/providers/profile_state_providers.dart';
import 'package:bookish/settings/account_setting_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:network_service/util/user_store.dart';

/// Android profile tab: Compose UI inside a platform view.
/// Flutter owns Riverpod state, upload, and navigation.
class NativeProfileTab extends ConsumerStatefulWidget {
  const NativeProfileTab({super.key});

  static const String viewType = 'profile-compose-view';

  @override
  ConsumerState<NativeProfileTab> createState() => _NativeProfileTabState();
}

class _NativeProfileTabState extends ConsumerState<NativeProfileTab> {
  final NativeProfileBridge _bridge = NativeProfileBridge.instance;

  @override
  void initState() {
    super.initState();
    _bridge.setActionHandler(_onNativeAction);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _pushState(ref.read(profileNotifierProvider));
    });
  }

  @override
  void dispose() {
    _bridge.setActionHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(profileNotifierProvider);
    ref.listen<ProfileState>(profileNotifierProvider, (_, next) {
      _pushState(next);
    });
    return PlatformViewLink(
      viewType: NativeProfileTab.viewType,
      surfaceFactory: (
        BuildContext context,
        PlatformViewController controller,
      ) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        debugPrint('[BookishProfile] creating surface id=${params.id}');
        try {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: NativeProfileTab.viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: const <String, dynamic>{},
            creationParamsCodec: const StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener((int id) {
              debugPrint('[BookishProfile] surface created id=$id');
              params.onPlatformViewCreated(id);
            })
            ..create();
        } catch (error, stackTrace) {
          debugPrint('[BookishProfile] create failed: $error\n$stackTrace');
          rethrow;
        }
      },
    );
  }

  Future<void> _pushState(ProfileState state) async {
    final String status = switch (state.status) {
      ProfileStatus.loaded => NativeProfileStatus.loaded,
      ProfileStatus.error => NativeProfileStatus.error,
      ProfileStatus.initial || ProfileStatus.loading =>
        NativeProfileStatus.loading,
    };
    debugPrint('[BookishProfile] pushState status=$status');
    try {
      await _bridge.updateState(
        status: status,
        userName: state.profile?.userName ?? '',
        name: state.profile?.name ?? '',
        phoneNumber: state.profile?.phoneNumber ?? '',
        profileIconUrl: state.profile?.profileIcon ?? '',
        localImagePath: state.localImagePath ?? '',
        appVersion: state.appVersion,
        isOwner: state.isOwner,
        isImageUploading: state.isImageUploading,
        isDebug: kDebugMode,
        errorMessage: state.errorMessage ?? '',
      );
    } catch (error, stackTrace) {
      debugPrint('$error\n$stackTrace');
    }
  }

  Future<void> _onNativeAction(String action) async {
    debugPrint('onNativeAction: $action');
    final notifier = ref.read(profileNotifierProvider.notifier);
    if (action == NativeProfileAction.retry) {
      await notifier.fetchUserProfile(force: true);
      return;
    }
    if (action == NativeProfileAction.openGallery) {
      await notifier.openGallery();
      return;
    }
    if (action == NativeProfileAction.openCamera) {
      await notifier.openCamera();
      return;
    }
    if (action == NativeProfileAction.editProfile) {
      await _openEditProfile();
      return;
    }
    if (action == NativeProfileAction.shareFeedback) {
      Get.toNamed(FeedbackScreen.routeName);
      return;
    }
    if (action == NativeProfileAction.openSettings) {
      Get.toNamed(AccountSettingScreen.routeName);
      return;
    }
    if (action == NativeProfileAction.logout) {
      notifier.logout();
      Get.toNamed(LoginScreen.routeName);
      return;
    }
  }

  Future<void> _openEditProfile() async {
    final userDetail = await UserStore.getUserDetail();
    await Get.to(
      () => EditProfileScreen(
        phoneNumber: userDetail?.phoneNumber ?? '',
      ),
    );
    if (!mounted) {
      return;
    }
    await ref.read(profileNotifierProvider.notifier).fetchUserProfile(force: true);
  }
}
