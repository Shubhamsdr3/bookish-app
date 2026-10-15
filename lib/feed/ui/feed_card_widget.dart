import 'package:bookish/commnets/comments_screen.dart';
import 'package:bookish/feed/controller/feed_widget_controller.dart';
import 'package:bookish/feeddetail/screens/feed_detail_screen.dart';
import 'package:bookish/util/utility.dart';
import 'package:bookish/widgets/image_carousel_widget.dart';
import 'package:bookish/widgets/menu_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/feed_data.dart';
import '../activity/post_activity_widget.dart';

typedef void DeletePostCallback(String postId);

class FeedCardWidget extends GetView<FeedWidgetController> {
  final DeletePostCallback callback;
  final FeedData feedData;

  FeedCardWidget({required this.feedData, required this.callback});

  @override
  Widget build(BuildContext context) {
    Get.put(FeedWidgetController(feedData));
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: feedData.user?.profileIcon != null
                        ? NetworkImage(
                            feedData.user?.profileIcon ?? "",
                          )
                        : AssetImage('assets/image/user.png') as ImageProvider,
                    radius: 24.r,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.r, right: 12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(feedData.user?.userName ?? "",
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.6,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(children: [
                              Image.asset(
                                'assets/image/open_book.png',
                                width: 16.r,
                                height: 16.r,
                              ),
                              SizedBox(
                                width: 4.r,
                              ),
                              Expanded(
                                child: Text(
                                  Utility.getBookName(feedData.post?.bookName),
                                  style: GoogleFonts.roboto(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Icon(Icons.more_vert),
                          onTap: () {
                            _onPostOptionClicked(context);
                          },
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 16.r,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    feedData.post?.caption ?? "",
                    style: GoogleFonts.roboto(fontSize: 16),
                  )),
              SizedBox(
                height: 12,
              ),
              if ((feedData.post?.images?.length ?? 0) > 0) ...[
                SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.35,
                    child: ImageCarouselWidget(
                        images: feedData.post!.images!,
                        onImageClick: () {
                          controller.openPreViewScreen(feedData);
                        }))
              ],
              SizedBox(
                height: 12.r,
              ),
              const Divider(
                color: Colors.black12,
              ),
              SizedBox(
                height: 12.r,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(CommentsScreen.routeName,
                      arguments: FeedDetailArgs(feedData));
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r, right: 16.r),
                  child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.04,
                      child: PostActivityWidget(
                        postData: feedData,
                      )),
                ),
              )
            ],
          ),
        ),
        if (feedData.post?.isAvailableForRent == true) ...[
          GestureDetector(
            onTap: () {
              controller.openExchangeScreen(feedData);
            },
            child: Container(
              color: Colors.green.shade50,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("This book is available for exchange.")),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18.r,
                    )
                  ],
                ),
              ),
            ),
          )
        ]
      ]),
    );
  }

  void _onPostOptionClicked(BuildContext context) {
    bool isAdminUser = controller.currentUserId == feedData.user?.userId;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) => MenuOptionWidget(
              isAdminUser: isAdminUser,
              onMenuClick: (MenuActions action) {
                onMenuOptionClicked(action, context);
              },
            )
    );
  }

  void onMenuOptionClicked(MenuActions action, BuildContext context) {
    switch (action) {
      case MenuActions.SAVE:
        controller.onSaveClicked();
      case MenuActions.DELETE:
        Navigator.pop(context);
        callback(feedData.post?.postId ?? "");
    }
  }
}
