import 'package:bookish_module/feedback/controllers/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  static String routeName = "/feedback";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share feedback"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please share your experience",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 18.r,
              ),
              EmojiFeedback(
                animDuration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                inactiveElementScale: .5,
                onChanged: (value) {
                  controller.rating.value = value ?? 0;
                },
              ),
              SizedBox(
                height: 20.r,
              ),
              _searchInputField(context, "Subject"),
              SizedBox(
                height: 24.r,
              ),
              Obx(() => _buildPostEditWidget(context)),
              SizedBox(height: 32.r),
              SizedBox(
                height: 50.r,
                width: MediaQuery.sizeOf(context).width,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Colors.teal.shade500),
                  icon: Obx(() =>
                      controller.isLoading.value ? _showLoader() : Container()),
                  label: Text(
                    "Submit",
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {
                    controller.onSubmitClicked();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showLoader() {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(2.0),
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }

  Widget _searchInputField(BuildContext context, String hint) {
    return Obx(
      () => Container(
        height: MediaQuery.sizeOf(context).height * 0.06,
        decoration: BoxDecoration(
            border: Border.all(color: controller.subjectEditBorder.value),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Focus(
          onFocusChange: (hasFocus) => {
            if (hasFocus)
              {controller.subjectEditBorder.value = Colors.lightBlue}
            else
              {controller.subjectEditBorder.value = Colors.grey}
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.r),
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    GoogleFonts.roboto(fontSize: 18, color: Colors.black45),
                border: InputBorder.none,
              ),
              scrollPadding: EdgeInsets.all(20.0),
              keyboardType: TextInputType.text,
              maxLines: 2,
              enabled: true,
              autofocus: true,
              onChanged: (newValue) {
                // setState(() {
                //   _subjectController.text = newValue;
                // });
              },
              controller: controller.subjectController,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostEditWidget(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.35,
      decoration: BoxDecoration(
          border: Border.all(color: controller.feedbackEditBorder.value),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Focus(
              onFocusChange: (hasFocus) => {
                if (hasFocus)
                  {controller.feedbackEditBorder.value = Colors.lightBlue}
                else
                  {controller.feedbackEditBorder.value = Colors.grey}
              },
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Description..",
                  hintStyle:
                      GoogleFonts.roboto(fontSize: 18, color: Colors.black45),
                  border: InputBorder.none,
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.text,
                maxLines: 10,
                onChanged: (newValue) {
                  controller.feedbackController.text = newValue;
                },
                controller: controller.feedbackController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showLoaderDialog(BuildContext context) {
    final iconSize = MediaQuery.sizeOf(context).height * 0.1;
    AlertDialog dialog = AlertDialog(
      content: Container(
        height: MediaQuery.sizeOf(context).height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/right_check.json',
                repeat: false, width: iconSize, height: iconSize),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Your feedback is submitted, thank you!",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
