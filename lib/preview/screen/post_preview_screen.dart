import 'package:bookish/preview/controller/post_preview_controller.dart';
import 'package:bookish/widgets/bookish_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PostPreviewScreen extends GetView<PostPreviewController> {
  static String routeName = "/post-preview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            controller.feedData.post?.caption ?? "",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
              controller: controller.pagerController,
              itemCount: controller.feedData.post?.images?.length ?? 0,
              onPageChanged: (int page) {
                controller.setActivePage(page);
              },
              itemBuilder: (BuildContext context, int index) {
                String? imageUrl = controller.feedData.post?.images?[index];
                return BookishNetworkImage(
                    imageUrl: imageUrl!, fit: BoxFit.cover);
              }),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: controller.buildIndicator())
              ],
            ),
          )
        ],
      ),
    );
  }
}
