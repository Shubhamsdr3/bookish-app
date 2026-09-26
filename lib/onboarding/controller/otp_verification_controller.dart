import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:network_service/data/reader.dart';
import 'package:network_service/util/user_store.dart';

import '../../home/screens/home_screen.dart';
import '../../util/utility.dart';
import '../data/onboarding_repository.dart';

enum ButtonState { ENABLED, DISABLED, LOADING }

enum OtpVerificationState { IN_PROGRESS, SUCCESS, FAILED }

class OtpVerificationController extends GetxController {
  final String? phoneNumber;
  IOnboardingRepository onboardingRepository;

  OtpVerificationController(
      {this.phoneNumber, required this.onboardingRepository});

  final TextEditingController otpEditController = TextEditingController();
  final FocusNode otpFocus = FocusNode();

  RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  RxString otpCode = "".obs;
  Timer? _otpTimer;

  Rxn<OtpVerificationState> otpVerificationState = Rxn();

  RxString _verificationId = "".obs;

  ValueNotifier<int>? timerSecValListener;

  int get timerSeconds => 30;

  Rx<ButtonState> resendButtonState = Rx(ButtonState.DISABLED);
  Rx<ButtonState> otpSubmitButtonState = Rx(ButtonState.DISABLED);

  @override
  onInit() async {
    _verifyPhoneNumber();
    _startOTPTimer();
    super.onInit();
  }

  Future<void> _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 ${phoneNumber}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("FirebaseAuth: ${e}");
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint('FirebaseAuth: Code sent..$resendToken');
        _verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('FirebaseAuth: VerificationId...$verificationId');
        _verificationId.value = verificationId;
      },
    );
  }

  void _startOTPTimer() {
    resetError();
    timerSecValListener = ValueNotifier(timerSeconds);
    if (_otpTimer?.isActive ?? false) _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == timerSeconds + 1) {
        resendButtonState.value = ButtonState.ENABLED;
        timer.cancel();
      } else {
        timerSecValListener?.value--;
      }
    });
  }

  void verifyOtp(String code) async {
    if (code.isEmpty || code.length != 6) return;
    otpCode.value = code;
    otpSubmitButtonState.value = ButtonState.LOADING;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId.value, smsCode: otpCode.value);
      await FirebaseAuth.instance.signInWithCredential(credential);
      otpVerificationState.value = OtpVerificationState.IN_PROGRESS;
      _onLoggedInSuccess();
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      otpVerificationState.value = OtpVerificationState.FAILED;
      Utility.showSnackBar(
          Get.context!, "Something went wrong, please try later.");
    }
  }

  void _onLoggedInSuccess() async {
    otpVerificationState.value = OtpVerificationState.SUCCESS;
    UserStore.setUserLoggedIn(true);
    final payload = await _getUserPayload();
    onboardingRepository.loginUser(payload).then((response) {
      _isLoading.value = false;
      _saveUserDetails(response.data);
      Get.offAll(HomeScreen());
    }).onError((e, s) {
      _isLoading.value = false;
      debugPrint("$e : $s");
    });
  }

  void _saveUserDetails(UserData? userData) {
    if (userData == null) return;
    UserStore.saveUser(userData.user!);
    UserStore.setUserId(userData.user?.userId ?? "");
    if (userData.token != null && userData.token?.isNotEmpty == true) {
      UserStore.setAuthToken(userData.token ?? "");
    }
  }

  Future<Map<String, dynamic>> _getUserPayload() async {
    String userId = await UserStore.getUserId();
    return <String, dynamic>{
      if (userId.isNotEmpty) 'userId': userId,
      'privacy': 0,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'connections': 0,
      'phoneNumber': phoneNumber,
    };
  }

  void resendOtp() {
    _isLoading.value = true;
    resendButtonState.value = ButtonState.DISABLED;
    _verifyPhoneNumber();
    _startOTPTimer();
  }

  void resetError() {
    otpVerificationState.value = OtpVerificationState.IN_PROGRESS;
    otpEditController.clear();
  }

  @override
  void onClose() {
    otpEditController.clear();
    otpEditController.dispose();
    otpFocus.dispose();
    _otpTimer?.cancel();
    super.onClose();
  }
}
