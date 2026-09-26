import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:network_service/util/user_store.dart';

import '../../firebase/firestore_util.dart';

class HomeScreenController extends GetxController {
  final FireStoreUtil _fireStoreUtil = FireStoreUtil();

  RxBool get showPostExitDialog => false.obs;

  @override
  void onInit() {
    _getFcmToken();
    super.onInit();
  }

  void _addTokenToFirebase(String? token) async {
    if (token == null || token.isEmpty) return;
    final userId = await UserStore.getUserId();
    _fireStoreUtil.saveFCMToke(userId, token);
  }

  _getFcmToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print("FCM token: ${token}");
      _addTokenToFirebase(token);
    }).onError((err) {
      print("Error in getting token: ${err}");
    });

    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM token: ${token}");
      _addTokenToFirebase(token);
    });
  }
}
