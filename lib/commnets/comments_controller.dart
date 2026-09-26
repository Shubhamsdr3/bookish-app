import 'package:bookish_module/data/feed_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:network_service/util/user_store.dart';

import '../firebase/firestore_util.dart';

class CommentsController extends GetxController {
  final FeedData? feedData;

  CommentsController({required this.feedData});

  final FireStoreUtil _fireStoreUtil = new FireStoreUtil();
  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = new FocusNode();
  RxInt commentCount = 0.obs;

  void postComment(String comment) async {
    String postId = feedData?.post?.postId ?? "";
    final user = await UserStore.getUserDetail();
    final userId = await UserStore.getUserId();
    FirebaseFirestore.instance.collection("comments").doc(postId).collection("comment").add({
      "user": user?.toJson(),
      "comments": comment,
      "createdAt": DateTime.now().millisecondsSinceEpoch
    });
    _fireStoreUtil.updatePostComment(postId, userId, commentCount.value++);
  }

  getComments() => _fireStoreUtil.getComments(feedData?.post?.postId ?? "");

  getUserList() => _fireStoreUtil.getUserList(feedData?.like?.userIds ?? []);

  @override
  void onClose() {
    focusNode.unfocus();
    super.onClose();
  }
}
