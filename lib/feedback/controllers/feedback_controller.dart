import 'package:bookish/feedback/data/feedback_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_service/util/user_store.dart';

import '../../util/utility.dart';

class FeedbackController extends GetxController {
  Rx<Color> subjectEditBorder = Colors.grey.obs;
  Rx<Color> feedbackEditBorder = Colors.grey.obs;
  RxInt rating = 0.obs;
  RxBool isLoading = false.obs;

  late IFeedbackRepository _repository;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  @override
  onInit() {
    _repository = Get.put(FeedbackRepository());
    super.onInit();
  }

  onSubmitClicked() {
    if (rating.value == 0) {
      Utility.showSnackBar(Get.context!, "Please provide rating");
      return;
    } else if (subjectController.text.isEmpty || feedbackController.text.isEmpty) {
      Utility.showSnackBar(Get.context!, "Please add subject and description");
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    _postFeedback(Get.context!);
  }

  Future<void> _postFeedback(BuildContext context) async {
    isLoading.value = true;
    final userId = await UserStore.getUserId();
    final requestBody = {
      'userId': userId,
      'rating': rating.value,
      'subject': subjectController.text,
      'description': feedbackController.text,
    };
    try {
      final response = await _repository.submitFeedback(requestBody);
      if (response.statusCode == 200) {
        Get.back();
        debugPrint("Feedback submitted successfully");
      } else {
        throw Exception("Failed to update feedback");
      }
    } catch (ex) {
      debugPrint("Error occurred while submitting feedback: ${ex}");
    } finally {
      isLoading.value = false;
    }
  }
}
