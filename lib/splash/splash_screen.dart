import 'dart:async';

import 'package:bookish/util/utility.dart';
import 'package:bookish/webview/webview_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_service/util/user_store.dart';

import '../home/screens/home_screen.dart';
import '../onboarding/screen/bookish_login_screen.dart';

/// Completed after Firebase and API startup. App Check is not part of this.
/// The splash widget waits on it, but the first frame is already on screen.
final Completer<void> appStartup = Completer<void>();

/// Flutter splash must match native splash (white + centered logo).
/// Native assets are generated from [flutter_native_splash.yaml].
class SplashScreen extends StatefulWidget {
  static String routeName = '/splash-screen';

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          Utility.showToast('On pop invoked');
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.55,
            child: Image(
              image: AssetImage('assets/image/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToHome() async {
    await appStartup.future;
    final userLogged = await UserStore.isUserLoggedIn();
    if (!mounted) return;
    if (userLogged) {
      Get.offNamed(HomeScreen.routeName);
    } else {
      Get.offNamed(LoginScreen.routeName);
    }
  }
}
