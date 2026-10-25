import 'package:bookish/data/chat_message.dart';
import 'package:bookish/data/notification_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:network_service/data/reader.dart';
import 'package:bookish/data/user_comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FireStoreUtil {
  /// Returns the current Firebase Auth user's ID token, or null if signed out.
  static Future<String?> getFirebaseIdToken({bool forceRefresh = true}) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user.getIdToken(forceRefresh);
  }


  final String _POST_COLLECTION = "posts";
  final String _NOTIFICATION_COLLECTION = "notifications";

  final _fireStoreDb = FirebaseFirestore.instance;

  final _firebase = FirebaseAuth.instance;

  void updatePostLike(String? postId, String likedByUserId, bool isLiked, int likeCount) {
    if(postId == null || postId.isEmpty) return;
    final docRef = _fireStoreDb.collection(_POST_COLLECTION).doc(postId);
    if(isLiked) {
      docRef.update({'isLiked': isLiked, 'like.count': likeCount, 'like.userIds': FieldValue.arrayUnion([likedByUserId])});
    } else {
      docRef.update({'isLiked': isLiked, 'like.count': likeCount, 'like.userIds': FieldValue.arrayRemove([likedByUserId])});
    }
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>?;
      debugPrint(data.toString());
    },
      onError: (e) => debugPrint("Error getting document: $e"),
    );
  }

  void updatePostComment(String? postId, String commentUserId, int commentCount) {
    if(postId == null || postId.isEmpty) return;
    debugPrint("Updating comment count..$commentCount");
    final docRef = _fireStoreDb.collection(_POST_COLLECTION).doc(postId);
    docRef.update({'comment.count': commentCount, 'comment.userIds': FieldValue.arrayUnion([commentUserId])});
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      debugPrint(data.toString());
    },
      onError: (e) => debugPrint("Error getting document: $e"),
    );
  }

  void updatePostShare(String? postId, String shareUserId, int sharedCount) {
    if(postId == null || postId.isEmpty) return;
    final docRef = _fireStoreDb.collection(_POST_COLLECTION).doc(postId);
    docRef.update({'share.count': sharedCount, 'share.userIds': FieldValue.arrayUnion([shareUserId])});
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      debugPrint("updated share..${data['share']['count']}");
    },
      onError: (e) => debugPrint("Error getting document: $e"),
    );
  }

  void addNotification(String userId, NotificationInfo notification) {
    _fireStoreDb.collection(_NOTIFICATION_COLLECTION)
        .doc(userId)
        .collection("data")
        .add(notification.toJson());
  }

  void saveFCMToken(String userId, String token) {
    _fireStoreDb.collection(_NOTIFICATION_COLLECTION)
        .doc(userId).set({"fcmToken": token});
  }

  Stream<List<Reader>> getUserList(List<String> userIds) {
    return _fireStoreDb.collection('readers')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .where((element) => userIds.contains(element.id))
        .map((document) => Reader.fromJson(document.data()))
        .toList());
  }

  Stream<List<UserComment>> getComments(String postId) {
    return _fireStoreDb.collection("comments")
        .doc(postId)
        .collection('comment')
        .orderBy('createdAt')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => UserComment.fromJson(document.data()))
        .toList()
    );
  }

  Stream<List<ChatMessage>> getChatMessage(String channelId) {
    return _fireStoreDb.collection("chat_channel")
        .doc(channelId)
        .collection('chats')
        .orderBy('createdAt')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => ChatMessage.fromJson(document.data()))
        .toList()
    );
  }

  Stream<Map<String, dynamic>> getPostLikes(String postId) {
    return _fireStoreDb.collection("posts")
        .doc(postId)
        .snapshots()
        .map((snapshot) => snapshot.data() as Map<String, dynamic>);
  }

  Stream<List<NotificationInfo>> getNotifications(String userId) {
    return _fireStoreDb.collection("notifications")
        .doc(userId)
        .collection("data")
        .orderBy('createdAt')
        .snapshots()
        .map((snapShot) => snapShot.docs
        .map((document) => NotificationInfo.fromJson(document.data()))
        .toList()
    );
  }

  Future<int> getNewNotificationCount(String userId) async {
    var count = 0;
    await _fireStoreDb
        .collection('notifications')
        .doc(userId)
        .collection("data")
        .get()
        .then((value) => value.docs.forEach((element) {
              final notification = element.data();
              if (notification['isRead'] == false) {
                count++;
              }
            }));
    return count;
  }

  void updateNotification(String userId) async {
    _fireStoreDb.collection("notifications")
        .doc(userId)
        .collection("data")
        .get()
        .then((value) => {
          value.docs.forEach((document) {
            document.reference.update({"isRead": true});
          })
        });
  }

  Future<Reader?> getCurrentUserDetail(String userId) async {
    final DocumentSnapshot snapshot = await _fireStoreDb.collection("readers").doc(userId).get();
    final userJson = snapshot.data() as Map<String, dynamic>?;
    return Reader.fromJson(userJson);
  }

  Future<void> logout() async {
    _firebase.signOut();
  }
}