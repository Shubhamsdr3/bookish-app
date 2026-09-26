import 'dart:async';

import 'package:bookish_module/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_service/util/user_store.dart';

import '../home/screens/home_screen.dart';
import '../onboarding/screen/bookish_login_screen.dart';
import '../util/dimensions.dart';


class SplashScreen extends StatefulWidget {
  static String routeName = "/splash-screen";

  const SplashScreen({
    super.key,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _navigateToHome);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Utility.showToast("On pop invoked");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
                child: Container(
              width: Get.width * 0.2,
              height: Get.height * 0.2,
              color: Colors.white,
            )),
            const SizedBox(
              height: Dimensions.dimen120,
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimensions.dimen40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.dimen8),
                  child: Image.asset(
                    'assets/image/logo.png',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome() async {
    final userLogged = await UserStore.isUserLoggedIn();
    if (userLogged) {
      Get.offNamed(HomeScreen.routeName);
    } else {
      Get.offNamed(LoginScreen.routeName);
    }
  }
}
