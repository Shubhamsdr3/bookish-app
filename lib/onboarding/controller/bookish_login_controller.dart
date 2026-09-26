import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_service/util/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/utility.dart';
import '../screen/otp_verification_screen.dart';

class BookishLoginController extends GetxController {
  late TextEditingController phoneEditController;

  RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  RxBool _resendOtpLoader = false.obs;
  RxBool get resendOtpLoader => _resendOtpLoader;

  RxString _phoneNumber = "".obs;
  RxString get phoneNumber => _phoneNumber;

  @override
  void onInit() {
    phoneEditController = TextEditingController(text: _phoneNumber.value);
    super.onInit();
  }

  onLoginClicked() {
    if (!_phoneNumber.value.isEmpty && _phoneNumber.value.length >= 10) {
      _openOtpVerification();
    } else {
      Utility.showSnackBar(Get.context!, "Please enter a valid phone number");
    }
  }

  void _openOtpVerification() {
    _isLoading.value = true;
    Future.delayed(const Duration(microseconds: 100), () {
      Get.toNamed(
          OtpVerificationScreen.routeName,
        arguments: _phoneNumber.value
      );
      _isLoading.value = false;
    });
  }

  void openTnCUrl() async {
    final Uri url = Uri.parse(Constants.TNC_URL);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${url}');
    }
  }

  void setPhoneNumber(String newValue) {
    _phoneNumber.value = newValue;
  }

  @override
  void onClose() {
    phoneEditController.clear();
    phoneEditController.dispose();
    super.onClose();
  }
}
