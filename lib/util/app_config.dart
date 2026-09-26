import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_service/util/constants.dart';

import '../firebase_options.dart';

class AppConfig {

  initialize(Environment env) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug
    );
    Constants.setEnvironment(env);
    // final notificationService = FBNotificationService();
    // notificationService.initialize();
    // notificationService.getToken();
  }
}