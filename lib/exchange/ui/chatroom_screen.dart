import 'package:bookish/commnets/comments_screen.dart';
import 'package:bookish/data/chat_message.dart';
import 'package:bookish/exchange/controller/chatroom_controller.dart';
import 'package:bookish/widgets/bookish_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoomScreen extends GetView<ChatRoomController> {
  static String routeName = "/chatScreen";

  @override
  Widget build(BuildContext context) {
    print("Channel id: ${controller.chatUser.channelId}");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('${controller.chatUser.name ?? ""}'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 48),
            child: Container(child: _buildChatWidget()),
          ),
          Positioned(
              bottom: 0,
              child: _commentInputField(context, "Type your message here."))
        ],
      ),
    );
  }

  StreamBuilder<List<ChatMessage>> _buildChatWidget() {
    return StreamBuilder<List<ChatMessage>>(
        stream: controller.chatMessages,
        builder: (context, snapshot) {
          print("Snapshot: ${snapshot.data}");
          if (snapshot.hasData) {
            return SingleChildScrollView(
                child: Column(
              children: [
                _buildCommentWidget(snapshot.data),
                SizedBox(
                  height: 10,
                )
              ],
            ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildCommentWidget(List<ChatMessage>? data) {
    if (data == null || data.isEmpty) {
      return Text("Unable to load");
    }
    return ListView.separated(
        shrinkWrap: true,
        controller: controller.scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final message = data[index];
          return _buildSingleChat(context, message);

          // if(feedPost != null) {
          //   if(feedPost?.user?.userId == _currentUser?.userId) {
          //     return _createQuoteWidget(message);
          //   } else {
          //     return _createAcceptDeny(message);
          //   }
          // } else if(message.messageType == MessageType.PRIVATE.name && message.userId != _currentUser?.userId) {
          //   return Container();
          // } else {
          //
          // }
        },
        separatorBuilder: (context, index) => SizedBox(
              width: 10,
            ),
        itemCount: data.length);
  }

  Widget _createQuoteWidget(ChatMessage chatMessage) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.feedPost?.user?.name ?? "",
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          controller.feedPost?.post?.caption ?? "",
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                    if ((controller.feedPost != null &&
                        (controller.feedPost?.post?.images?.length ?? 0) >
                            0)) ...[
                      Card(
                        child: BookishNetworkImage(
                          imageUrl: controller.feedPost!.post!.images![0],
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.cover,
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
            Container(
                color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Html(data: chatMessage.message ?? ""),
                        SizedBox(
                          height: 4,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: _buildDurationWidget(chatMessage.createdAt))
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  Widget _buildSingleChat(
    BuildContext context,
    ChatMessage? chatMessage,
  ) {
    return Row(
      mainAxisAlignment: controller.isOutGoingMessage(chatMessage)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: Card(
            elevation: 0,
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chatMessage?.message ?? "",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.normal, fontSize: 16)),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: _buildDurationWidget(chatMessage?.createdAt))
                  ],
                )),
          ),
        )
      ],
    );
  }

  Widget _createAcceptDeny(ChatMessage? chatMessage) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                "Shubham has shown interest, would you like accept it?",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Html(data: '${controller.feedPost?.post?.bookName ?? ""}'),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 48,
                width: MediaQuery.sizeOf(Get.context!).width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.teal,
                  ),
                  child: Text(
                    "Accept",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    _updateAccepted();
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 48,
                width: MediaQuery.sizeOf(Get.context!).width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.grey))),
                  child: Text("Deny",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  onPressed: () {
                    _postComment("Noted!", true);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentInputField(BuildContext context, String hint) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.07,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 4),
        child: TextField(
          decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  GoogleFonts.roboto(fontSize: 18, color: Colors.black45),
              border: InputBorder.none,
              suffixIcon: InkWell(
                child: Icon(Icons.send),
                onTap: () {
                  final comment = controller.commentController.text;
                  // _postComment(comment, false);
                  controller.sendMessage(comment, false);
                  controller.commentController.clear();
                  controller.scrollController.jumpTo(
                    controller.scrollController.position.maxScrollExtent,
                    // curve: Curves.easeOut,
                    // duration: const Duration(milliseconds: 200)
                  );
                },
              )),
          scrollPadding: EdgeInsets.all(20.0),
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          // enabled: _isChannelAccepted,
          onChanged: (newValue) {
            controller.commentController.text = newValue;
          },
          controller: controller.commentController,
        ),
      ),
    );
  }

  void _postComment(String message, bool isPrivate) async {
    final chatMessage = ChatMessage(
        message: message,
        senderId: controller.currentUserId.value,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        messageType: isPrivate ? MessageType.PRIVATE.name : null);
    FirebaseFirestore.instance
        .collection("chat_channel")
        .doc(controller.chatUser.channelId ?? "")
        .collection("chats")
        .add(chatMessage.toJson());
  }

  Widget _buildDurationWidget(int? timestamp) {
    if (timestamp == null) return Container();
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
    return Text(
      '${d12}',
      style: GoogleFonts.roboto(
          fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black54),
    );
  }

  void _getChannelInfo() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chat_channel")
        .doc(controller.chatUser.channelId ?? "")
        .get();
    var channelInfo = snapshot.data() as Map<String, dynamic>?;
    print("Channel info: ${channelInfo}");

    // setState(() {
    //   // _isChannelAccepted = channelInfo?['isAccepted'];
    // });
  }

  void _updateAccepted() async {
    FirebaseFirestore.instance
        .collection("chat_channel")
        .doc(controller.chatUser.channelId ?? "")
        .update({'isAccepted': true});
    // setState(() {
    //   _isChannelAccepted = true;
    // });
  }
}
