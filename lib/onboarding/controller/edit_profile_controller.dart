import 'dart:io';

import 'package:bookish/firebase/firestore_util.dart';
import 'package:bookish/onboarding/data/auth_api_service.dart';
import 'package:bookish/onboarding/data/onboarding_repository.dart';
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

  final ImagePicker _imagePicker = new ImagePicker();
  RxString imageDownloadUrl = "".obs;

  RxBool _imageLoading = false.obs;

  RxBool get imageLoading => _imageLoading;

  RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  late IOnboardingRepository _repository;

  @override
  onInit() {
    _repository = Get.put(OnboardingRepository(services: {AuthApiService()}));
    super.onInit();
  }

  Future<void> onCameraClicked(ImageSource imageSource) async {
    Get.back();
    _imagePicker
        .pickImage(source: imageSource, imageQuality: 25)
        .then((pickedFile) {
      imageFile.value = pickedFile;
      _uploadImageFile(imageFile.value);
    });
  }

  void _uploadImageFile(XFile? imageFile) async {
    if (imageFile == null) return;
    try {
      _imageLoading.value = true;
      final file = File(imageFile.path);
      var storageRef =
          FirebaseStorage.instance.ref("images/${imageFile.name}.jpg");
      final TaskSnapshot snapshot = await storageRef.putFile(
          file,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageDownloadUrl.value = downloadUrl.toString();
      print("Downloaded url$imageDownloadUrl");
      _imageLoading.value = false;
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> onSubmitClicked() async {
    _isLoading.value = true;
    final payload = await _getUserDetails();
    _repository.loginUser(payload).then((response) {
      _isLoading.value = false;
      if (imageDownloadUrl.isNotEmpty)
        UserStore.saveUserProfileIcon(imageDownloadUrl.value);
      Get.offAll(() => SelectTopicsScreen());
    }).onError((e, s) {
      _isLoading.value = false;
      debugPrint("$e : $s");
    });
  }

  Future<Map<String, dynamic>> _getUserDetails() async {
    final String userId = await UserStore.getUserId();
    final String? idToken = await FireStoreUtil.getFirebaseIdToken();
    return <String, dynamic>{
      if (idToken != null && idToken.isNotEmpty) 'idToken': idToken,
      if (userId.isNotEmpty) 'userId': userId,
      if (userNameController.text.isNotEmpty)
        'userName': userNameController.text,
      if (nameController.text.isNotEmpty) 'name': nameController.text,
      if (imageDownloadUrl.value.isNotEmpty)
        'profileIcon': imageDownloadUrl.value,
      'privacy': 0,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'connections': 0,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  void onClose() {
    userNameController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
