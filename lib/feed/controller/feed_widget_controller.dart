import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:network_service/util/user_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/feed_data.dart';
import '../../exchange/controller/chatlist_controller.dart';
import '../../exchange/ui/chat_list_screen.dart';
import '../../firebase/firestore_util.dart';
import '../../preview/screen/post_preview_screen.dart';
import '../../util/utility.dart';

class FeedWidgetController extends GetxController {
  RxString _currentUserId = "".obs;

  RxString get currentUserId => _currentUserId;

  final String _POST_COLLECTION = "posts";

  final FeedData feedData;

  FeedWidgetController(this.feedData);

  final FireStoreUtil _fireStoreUtil = FireStoreUtil();

  @override
  void onInit() {
    _getUserId();
    _getPostShareDetail();
    super.onInit();
  }

  void _getUserId() async {
    final userId = await UserStore.getUserId();
    _currentUserId.value = userId;
  }

  void _getPostShareDetail() async {
    String postId = feedData.post?.postId ?? "";
    FirebaseFirestore.instance.collection(_POST_COLLECTION).doc(postId).get().then((snapshot) {
      final data = snapshot.data();
      debugPrint("Shubham: This post details : ${data}");
      // _shareCount.value = data?['share']['count'] ?? 0;
      // _isPostLiked.value = data?['isLiked'];
    }).onError((e, s) {
      debugPrint("$e $s");
    });
  }

  void onLikeClicked(FeedData post, bool isPostLiked, int likeCount, int shareCount) async {
    if (isPostLiked) {
      if (likeCount > 0) likeCount--;
    } else {
      likeCount++;
    }
    _fireStoreUtil.updatePostLike(post.post?.postId, currentUserId.value, !isPostLiked, likeCount);
  }

  void onSaveClicked() {
    Utility.showToast("Saved");
  }

  void onShareClicked(String? postId, int shareCount) async {
    if (postId == null || postId.isEmpty) return;
    final postImages = feedData.post?.images;
    if (postImages != null && postImages.isNotEmpty) {
      final url = Uri.parse(postImages[0]);
      final response = await http.get(url);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final filePath = '${temp.path}/post_image.jpg';
      File(filePath).writeAsBytesSync(bytes);
      final shareLink =
          "${feedData.post?.caption ?? ""} \n\n Checkout this post on Bookish: \n https://bookissh-web.web.app/post/${postId}";
      Share.shareXFiles([XFile(filePath)], subject: feedData.post?.caption ?? "", text: shareLink);
    } else {
      final shareLink =
          "${feedData.post?.caption ?? ""} \n\n Checkout this post on Bookish: \n https://bookissh-web.web.app/post/${postId}";
      Share.share(
        shareLink,
        subject: feedData.post?.caption ?? "",
      );
    }
    _fireStoreUtil.updatePostShare(postId, currentUserId.value, ++shareCount);
  }

  getPostLikes(String postId) => _fireStoreUtil.getPostLikes(postId);

  void openPreViewScreen(FeedData feedData) {
    Get.toNamed(PostPreviewScreen.routeName, arguments: feedData);
  }

  void openExchangeScreen(FeedData feedData) {
    Get.toNamed(UserChatListScreen.routeName, arguments: (ChatListScreenArgs(feedPost: feedData)));
  }
}
