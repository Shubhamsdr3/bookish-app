import 'dart:io';

import 'package:bookish/native/native_image_picker.dart';
import 'package:bookish/onboarding/data/auth_api_service.dart';
import 'package:bookish/onboarding/data/onboarding_repository.dart';
import 'package:bookish/onboarding/data/login_request.dart';
import 'package:bookish/topics/screens/select_topics_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_service/util/user_store.dart';

class EditProfileController extends GetxController {
  final String? phoneNumber;

  EditProfileController({this.phoneNumber});

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Rx<XFile?> imageFile = Rx(null);

  final ImagePicker _imagePicker = ImagePicker();
  RxString imageDownloadUrl = "".obs;

  final RxBool _imageLoading = false.obs;

  RxBool get imageLoading => _imageLoading;

  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  late IOnboardingRepository _repository;

  @override
  onInit() {
    _repository = Get.put(OnboardingRepository(services: {AuthApiService()}));
    super.onInit();
  }

  Future<void> onCameraClicked(ImageSource imageSource) async {
    Get.back();
    if (Platform.isAndroid) {
      final List<String> paths = imageSource == ImageSource.gallery
          ? await NativeImagePicker.instance.pickFromGallery()
          : await NativeImagePicker.instance.pickFromCamera();
      if (paths.isEmpty) {
        return;
      }
      final XFile pickedFile = XFile(paths.first);
      imageFile.value = pickedFile;
      _uploadImageFile(pickedFile);
      return;
    }
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: imageSource,
      imageQuality: 25,
    );
    imageFile.value = pickedFile;
    _uploadImageFile(pickedFile);
  }

  void _uploadImageFile(XFile? imageFile) async {
    if (imageFile == null) return;
    try {
      _imageLoading.value = true;
      final file = File(imageFile.path);
      var storageRef = FirebaseStorage.instance.ref(
        "images/${imageFile.name}.jpg",
      );
      final TaskSnapshot snapshot = await storageRef.putFile(
        file,
        SettableMetadata(contentType: "image/jpeg"),
      );
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageDownloadUrl.value = downloadUrl.toString();
      debugPrint("Downloaded url$imageDownloadUrl");
      _imageLoading.value = false;
    } on FirebaseException catch (e) {
      debugPrint("Error occurred while uploading image: $e");
    }
  }

  Future<void> onSubmitClicked() async {
    _isLoading.value = true;
    final payload = await _getUserDetails();
    _repository
        .updateProfile(payload)
        .then((response) {
          _isLoading.value = false;
          if (imageDownloadUrl.isNotEmpty) {
            UserStore.saveUserProfileIcon(imageDownloadUrl.value);
          }
          Get.back();
          // Get.offAll(() => SelectTopicsScreen());
        })
        .onError((e, s) {
          _isLoading.value = false;
          debugPrint("$e : $s");
        });
  }

  Future<LoginRequest> _getUserDetails() async {
    return LoginRequest(
      userName: userNameController.text,
      name: nameController.text,
      profileIcon: imageDownloadUrl.value,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      phoneNumber: phoneNumber,
    );
  }

  @override
  void onClose() {
    userNameController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
