import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/notification_info.dart';
import '../../firebase/firestore_util.dart';

class NotificationController extends GetxController {

  final String currentUserId;

  NotificationController(this.currentUserId);

  FireStoreUtil _fireStoreUtil = new FireStoreUtil();

  @override
  void onInit() {
    _updateAllNotification();
    super.onInit();
  }

  Stream<List<NotificationInfo>> getNotifications() => _fireStoreUtil.getNotifications(currentUserId);

  void _updateAllNotification() async {
    try {
      _fireStoreUtil.updateNotification(currentUserId);
    } on FirebaseException catch (error) {
      print(error);
    }
  }
}