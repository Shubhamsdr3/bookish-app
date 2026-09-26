import 'package:bookish_module/data/chat_user.dart';
import 'package:bookish_module/exchange/controller/chatlist_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_service/bookish_result.dart';

class UserChatListScreen extends GetView<ChatListController> {
  static String routeName = "/chat_user_list";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Messages"),
        scrolledUnderElevation: 0,
      ),
      body: Container(
        child: Obx(() {
          switch(controller.chatUsers.value) {
            case Success(data: final chatList):
              return Padding(
                padding: EdgeInsets.all(16.r),
                child: _buildChatList(chatList));

            case Failure(error: final error):
              return Center(child: Text(error.toString()));

            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        }),
      )
    );
  }

  Widget _buildChatList(List<ChatUser>? data) {
    if (data == null || data.isEmpty) {
      return Center(
        child: Text("Unable to load users."),
      );
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final chatUser = data[index];
        return _buildSingleChatWidget(chatUser);
      },
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: 10.r,
      ),
    );
  }

  Widget _buildSingleChatWidget(ChatUser chatUser) {
    return GestureDetector(
      onTap: () {
        controller.navigateToChatRoom(chatUser);
      },
      child: Container(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 14.r),
              child: CircleAvatar(
                backgroundImage: chatUser.profileIcon != null
                    ? NetworkImage(
                        chatUser.profileIcon ?? "",
                      )
                    : AssetImage('assets/image/user.png') as ImageProvider,
                radius: 24.r,
              ),
            ),
            SizedBox(
              width: 12.r,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${chatUser.name ?? ""}',
                  style: GoogleFonts.roboto(
                      fontSize: 16.r, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4.r,
                ),
                if (chatUser.updatedAt != null) ...[
                  _showTimeStamp(chatUser.updatedAt!)
                ],
                SizedBox(
                  height: 4.r,
                ),
                Divider(
                  color: Colors.grey.shade400,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _showTimeStamp(int timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
    return Text(
      d12,
      style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
    );
  }
}
