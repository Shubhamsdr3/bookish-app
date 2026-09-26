import 'package:bookish_module/onboarding/controller/bookish_login_controller.dart';
import 'package:bookish_module/uikit/bookish_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends GetView<BookishLoginController> {
  static String routeName = "/bookish_login";

  @override
  Widget build(BuildContext context) {
    BookishColor color = Theme.of(context).extension<BookishColor>()!;
    return Scaffold(
        backgroundColor: color.backgroundColor,
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SizedBox(
                    height: 24.r,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Enter our mobile number",
                        style: GoogleFonts.roboto(
                            color: color.primaryText, fontWeight: FontWeight.w500, fontSize: 16),
                      )),
                  SizedBox(
                    height: 6,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("You will receive OTP on your phone.",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400, fontSize: 14, color: color.secondaryText))),
                  SizedBox(
                    height: 32.r,
                  ),
                  PhoneInputField(),
                  SizedBox(
                    height: 16.r,
                  ),
                  SizedBox(
                    height: 8.r,
                  ),
                  SizedBox(
                    height: 50.r,
                    width: 140.r,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.onLoginClicked();
                      },
                      label: Text(
                        "Login",
                        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      icon: controller.isLoading.value ? _showLoader() : Container(),
                      style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.teal)),
                    ),
                  ),
                  SizedBox(
                    height: 16.r,
                  ),
                  Visibility(
                    visible: false,
                    child: TextButton(
                        onPressed: () {
                          _showToast(context);
                        },
                        child: Text(
                          "Help ?",
                          style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                  ),
                  Spacer(),
                  TnCTextWidget(onClick: controller.openTnCUrl),
                ]),
              ),
            ),
          ],
        ));
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(content: Text('On help clicked')),
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
}

class PhoneInputField extends StatelessWidget {
  PhoneInputField({super.key});

  final BookishLoginController controller = Get.find<BookishLoginController>();

  @override
  Widget build(BuildContext context) {
    BookishColor color = Theme.of(context).extension<BookishColor>()!;
    return TextFormField(
      decoration: InputDecoration(
        label: Text("Phone number"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(),
        prefix: Text("+91  "),
        hintText: "9999999999",
        hintStyle: TextStyle(color: Colors.grey),
        prefixStyle: TextStyle(color: color.primaryText, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(color: color.primaryText, fontWeight: FontWeight.w400),
      keyboardType: TextInputType.number,
      maxLength: 10,
      onChanged: (newValue) {
        controller.setPhoneNumber(newValue);
      },
      autofocus: true,
      controller: controller.phoneEditController,
    );
  }
}

class TnCTextWidget extends StatelessWidget {
  final VoidCallback onClick;

  const TnCTextWidget({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    BookishColor color = Theme.of(context).extension<BookishColor>()!;
    TextStyle defaultStyle =
        GoogleFonts.roboto(color: color.secondaryText, fontSize: 12.0, fontWeight: FontWeight.w400);
    TextStyle linkStyle = GoogleFonts.roboto(
        color: Colors.blueAccent.shade200,
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        decoration: TextDecoration.underline);
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: 'By clicking login, you agree to our '),
          TextSpan(
              text: 'Terms of Service & Privacy Policy.',
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onClick.call();
                }),
        ],
      ),
    );
  }
}
