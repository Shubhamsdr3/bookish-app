import 'dart:async';

import 'app_routes.dart';
import 'splash/splash_screen.dart';
import 'uikit/bookish_size_impl.dart';
import 'uikit/dark_bookish_color.dart';
import 'uikit/light_bookish_color.dart';
import 'uikit/light_text_style.dart';
import 'util/dimensions.dart';
import 'util/logger.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:network_service/base_api_service.dart';
import 'package:network_service/util/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
import 'notification/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // BASE_URL starts null. Set it before any await so a later startup
  // failure cannot leave Dio with a null host.
  Constants.setEnvironment(_startupEnvironment());
  // Draw before any startup await. preserve() keeps Android's pre-draw
  // listener false until remove(), and the release Play Integrity call below
  // does not return, so the system splash never leaves.
  runApp(const MyApp());
  try {
    await _startCoreServices();
  } catch (error, stackTrace) {
    debugPrint('Startup failed: $error\n$stackTrace');
  } finally {
    if (!appStartup.isCompleted) {
      appStartup.complete();
    }
  }
  unawaited(_activateAppCheck());
  try {
    await FirebaseMessaging.instance.getInitialMessage();
  } catch (error, stackTrace) {
    debugPrint('getInitialMessage failed: $error\n$stackTrace');
  }
}

Future<void> _startCoreServices() async {
  // The flavor google-services.json already created [DEFAULT].
  // Debug FirebaseOptions clash with the prod project and throw duplicate-app.
  await Firebase.initializeApp(
    options: defaultTargetPlatform == TargetPlatform.android
        ? null
        : DefaultFirebaseOptions.currentPlatform,
  );
  _handleUncaughtErrors();
  await ApiService().initialize(
    onSessionExpired: () {
      debugPrint('Session expired! Redirecting to login...');
    },
  );
  try {
    final bool notificationDenied = await Permission.notification.isDenied;
    if (notificationDenied) {
      unawaited(Permission.notification.request());
    }
    await PushNotificationService().setupInteractedMessage();
  } catch (error, stackTrace) {
    debugPrint('Notification setup failed: $error\n$stackTrace');
  }
}

Environment _startupEnvironment() {
  const String rawAppEnv = String.fromEnvironment('APP_ENV');
  if (rawAppEnv == 'production') {
    return Environment.production;
  } else {
    return Environment.staging;
  }
}

Future<void> _activateAppCheck() async {
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: kReleaseMode
          ? AndroidProvider.playIntegrity
          : AndroidProvider.debug,
    );
  } catch (error, stackTrace) {
    debugPrint('App Check activate failed: $error\n$stackTrace');
  }
  if (kDebugMode) {
    debugPrint(
      'App Check: using debug provider. If phone auth fails with '
      '"App attestation failed" (403), run ./scripts/setup_app_check_debug.sh '
      'and register .appcheck_debug_token in Firebase Console '
      '(project bookish-debug-58f4c, package com.newaura.bookish.dev).',
    );
  }
}

void _handleUncaughtErrors() {
  FlutterError.onError = (flutterErrorDetails) {
    if (flutterErrorDetails.silent) {
      FirebaseCrashlytics.instance.recordFlutterError(flutterErrorDetails);
    } else {
      FirebaseCrashlytics.instance.recordFlutterFatalError(flutterErrorDetails);
    }
  };
  PlatformDispatcher.instance.onError = ((exception, stackTrace) {
    FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      fatal: false,
    );
    return true;
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        child: GetMaterialApp(
          getPages: appRoutes,
          title: 'Bookish',
          navigatorKey: ApiService().aliceNavigatorKey,
          home: SplashScreen(),
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: Colors.white,
            appBarTheme: const AppBarTheme(
              color: Colors.white,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.dimen20,
              ),
            ),
            extensions: <ThemeExtension<dynamic>>[
              BookishSizeImpl(),
              LightTextStyle(),
              LightBookishColor(),
            ],
          ),
          darkTheme: ThemeData().copyWith(
            extensions: <ThemeExtension<dynamic>>[
              BookishSizeImpl(),
              LightTextStyle(),
              DarkBookishColor(),
            ],
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
