import 'package:bookish_module/widgets/animator_dot_indicator.dart';
import 'package:bookish_module/widgets/bookish_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageCarouselWidget extends StatefulWidget {
  final List<String> images;
  final VoidCallback? onImageClick;

  ImageCarouselWidget({super.key, required this.images, this.onImageClick});

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  final RxInt _index = 0.obs;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
            physics: PageScrollPhysics(),
            itemCount: widget.images.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              _index.value = index;
            },
            itemBuilder: (context, index) {
              final imageUrl = widget.images[index];
              if (imageUrl.isNotEmpty) {
                return GestureDetector(
                    onTap: () {
                      widget.onImageClick?.call();
                    },
                    child: _buildSingleImageCard(context, imageUrl, index));
              } else {
                return Container();
              }
            }),
        if (widget.images.length > 1) ...[
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(() => AnimatedDotIndicator(
                  currentIndex: _index.value, itemCount: widget.images.length)))
        ]
      ],
    );
  }

  Widget _buildSingleImageCard(
      BuildContext context, String imageUrl, int index) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: BookishNetworkImage(
        imageUrl: imageUrl,
        width: MediaQuery.sizeOf(context).width * 0.8,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
