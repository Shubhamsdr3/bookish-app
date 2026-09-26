import 'package:bookish_module/commnets/comments_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_service/data/reader.dart';

import '../data/user_comment.dart';

class CommentsScreen extends GetView<CommentsController> {
  static String routeName = "/comments-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("Likes & comments"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: ListView(
              controller: controller.scrollController,
              children: [
                LikeWidget(),
                SizedBox(
                  height: 8.r,
                ),
                Text(
                  "Comments",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 8.r,
                ),
                CommentWidget(),
                SizedBox(
                  height: 60.r,
                )
              ],
            ),
          ),
          Positioned(
              bottom: 0, child: CommentInputField(hint: "Type your message.."))
        ],
      ),
    );
  }
}

class CommentInputField extends StatelessWidget {
  final String hint;

  CommentInputField({super.key, required this.hint});

  late final CommentsController _controller = Get.find<CommentsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.07,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: EdgeInsets.only(left: 16.r, top: 4.r),
        child: TextFormField(
          focusNode: _controller.focusNode,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  GoogleFonts.roboto(fontSize: 18, color: Colors.black45),
              border: InputBorder.none,
              suffixIcon: InkWell(
                child: Icon(Icons.send),
                onTap: () {
                  final comment = _controller.commentController.text;
                  _controller.postComment(comment);
                  _controller.commentController.clear();
                  if (_controller.scrollController.hasClients) {
                    _controller.scrollController.animateTo(
                      _controller.scrollController.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 200),
                    );
                  }
                },
              )),
          scrollPadding: EdgeInsets.all(20.r),
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          autofocus: true,
          onChanged: (newValue) {
            _controller.commentController.text = newValue;
          },
          controller: _controller.commentController,
        ),
      ),
    );
  }
}

class LikeWidget extends StatelessWidget {
  LikeWidget({super.key});

  late final CommentsController _controller = Get.find<CommentsController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Reader>>(
        stream: _controller.getUserList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userList = snapshot.data;
            if (userList == null || userList.isEmpty == true) {
              return Container();
            } else {
              return Container(
                  height: 60.r,
                  padding: EdgeInsets.symmetric(vertical: 10.r),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = userList[index];
                        return Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: item.profileIcon == null
                                  ? AssetImage('assets/image/user.png')
                                  : NetworkImage(item.profileIcon ?? "")
                              as ImageProvider,
                              radius: 24.r,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2.r,
                              child: Icon(
                                size: 16.r,
                                Icons.favorite,
                                color: Colors.red.shade300,
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            width: 10.r,
                          ),
                      itemCount: userList.length));
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class CommentWidget extends StatelessWidget {
  late final CommentsController _controller = Get.find<CommentsController>();

  CommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserComment>>(
        stream: _controller.getComments(),
        builder: (context, snapshot) {
          final comments = snapshot.data;
          if (comments == null || comments.isEmpty) {
            return Align(
                alignment: Alignment.topCenter,
                child: Text("Unable to load comments"));
          }
          _controller.commentCount.value = comments.length;
          if (snapshot.hasData) {
            return ListView.separated(
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return SingleRowComment(comment: comment);
                },
                separatorBuilder: (context, index) => SizedBox(
                      width: 10.r,
                    ),
                itemCount: comments.length);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Container();
        });
  }
}

class SingleRowComment extends StatelessWidget {
  final UserComment comment;

  const SingleRowComment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.r),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: (comment.user?.profileIcon == null ||
                comment.user?.profileIcon?.isEmpty == true)
                ? AssetImage('assets/image/user.png')
                : NetworkImage(comment.user?.profileIcon ?? "")
            as ImageProvider,
            radius: 20.r,
          ),
          Card(
            elevation: 0,
            color: Colors.grey.shade200,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.user?.name ?? "",
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 4.r,
                              ),
                              Text(
                                comment.comments ?? "",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
