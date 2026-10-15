import 'package:bookish/feed/controller/feed_widget_controller.dart';
import 'package:bookish/feeddetail/screens/feed_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../commnets/comments_screen.dart';
import '../../data/feed_data.dart';

class PostActivityWidget extends GetView<FeedWidgetController> {

  final FeedData postData;
  final List<String> _userIds = [];
  final RxInt likeCount = 0.obs;
  final RxBool isPostLiked = false.obs;
  final RxInt shareCount = 0.obs;
  final RxInt commentCount = 0.obs;

  PostActivityWidget({required this.postData});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FeedWidgetController>()) {
      Get.put(FeedWidgetController(postData));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<Map<String, dynamic>>(
          stream: controller.getPostLikes(postData.post?.postId ?? ""),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              _userIds.clear();
              List likedUsers = snapshot.data?['like']['userIds'];
              likedUsers.map((e) => _userIds.add(e));
              likeCount.value = snapshot.data?['like']['count'] ?? 0;
              shareCount.value = snapshot.data?['share']['count'] ?? 0;
              commentCount.value = snapshot.data?['comment']['count'] ?? 0;
              isPostLiked.value = snapshot.data?['isLiked'] ?? false;
            }
            return Obx(() => PostActionItem(
                postData: postData,
                isPostLiked: isPostLiked.value,
                likeCount: likeCount.value,
                shareCount: shareCount.value,
                commentCount: commentCount.value,
            ));
          },
        ));
  }
}

class PostActionItem extends StatelessWidget {
  final FeedData postData;
  final bool isPostLiked;
  final int likeCount;
  final int shareCount;
  final int commentCount;

  PostActionItem(
      {super.key,
      required this.postData,
      required this.isPostLiked,
      required this.likeCount,
      required this.shareCount,
      required this.commentCount});

  late FeedWidgetController _controller = Get.find<FeedWidgetController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              child: (isPostLiked)
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(Icons.favorite_border),
              onTap: () {
                _controller.onLikeClicked(postData, isPostLiked, likeCount, shareCount);
              },
            ),
            SizedBox(
              width: 4.r,
            ),
            if (likeCount > 0) ...[
              Text('${(likeCount)}',
                  style: GoogleFonts.roboto(
                      fontSize: 12, fontWeight: FontWeight.normal))
            ]
          ],
        ),
        Row(
          children: [
            InkWell(
              child: Icon(Icons.comment),
              onTap: () {
                Get.toNamed(CommentsScreen.routeName,
                    arguments: FeedDetailArgs(postData));
              },
            ),
            SizedBox(width: 4.r),
            if (commentCount > 0) ...[
              Text(
                '${(commentCount)}',
                style: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.normal),
              )
            ]
          ],
        ),
        Row(
          children: [
            InkWell(
              child: const Icon(Icons.share),
              onTap: () {
                _controller.onShareClicked(
                    postData.post?.postId, (postData.share?.count ?? 0));
              },
            ),
            SizedBox(width: 4.r),
            if (shareCount > 0) ...[
              Text('${(shareCount)}',
                  style: GoogleFonts.roboto(
                      fontSize: 12, fontWeight: FontWeight.normal))
            ]
          ],
        )
      ],
    );
  }
}
