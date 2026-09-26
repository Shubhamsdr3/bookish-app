import 'package:bookish_module/data/notification_info.dart';
import 'package:bookish_module/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationScreen extends GetView<NotificationController> {

  static String routeName = "/notification";

  final String currentUserId;

  NotificationScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController(currentUserId));

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
        appBar: AppBar(title: Text("Notifications"),),
        body: Center(
            child: StreamBuilder<List<NotificationInfo>>(
              stream: controller.getNotifications(),
              builder: (context,snapshot) {
                if(snapshot.hasData) {
                  return _buildNotificationList(snapshot.data);
                } else if(snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator(),);
              },
            )
        )
    );
  }

  Widget _buildNotificationList(List<NotificationInfo>? data) {
    if(data == null || data.isEmpty) {
      return Center(child: Text("Unable to load notification"),);
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final notification = data[index];
        return GestureDetector(
            onTap: () {
              _processDeeplink(notification.deeplink);
            },
            child: _buildNotificationItem(notification)
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationInfo notification) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Card(
        elevation: 0,
        color: Colors.white ,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: notification.icon != null ? NetworkImage(notification.icon ?? ""): AssetImage('assets/image/user.png') as ImageProvider,
                radius: 24,
              ),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title ?? "", style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 4),
                  Text(notification.message ?? "", style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _processDeeplink(String? deeplink) {
    if(deeplink == null || deeplink.isEmpty) return;
    Uri deeplinkUri = Uri.parse(deeplink);
    List<String> segments = deeplinkUri.pathSegments;
    String postId = segments[segments.length - 1];
    Get.toNamed("/navigation");
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => NavigationWidget(postId: postId)));
  }
}