import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookishNetworkImage extends StatelessWidget {
  final String imageUrl;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? height;
  final double? width;
  final BoxFit fit;

  const BookishNetworkImage(
      {super.key,
      required this.imageUrl,
      this.placeholder,
      this.errorWidget,
      this.height,
      this.width,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ?? Image.asset('assets/image/image_gallery.png'),
      errorWidget: (context, url, error) {
        debugPrint("Error loading image: $url $error");
        return errorWidget ?? Image.asset('assets/image/image_gallery.png');
      },
    );
  }
}
