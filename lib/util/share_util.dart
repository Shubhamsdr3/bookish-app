import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtil {

  static void sharePost(String postId, String caption, List<String> postImages) async {
    if (postImages.isNotEmpty) {
      final url = Uri.parse(postImages[0]);
      final response = await http.get(url);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final filePath = '${temp.path}/post_image.jpg';
      File(filePath).writeAsBytesSync(bytes);
      final shareLink =
          "$caption \n\n Checkout this post on Bookish: \n https://bookissh-web.web.app/post/${postId}";
      Share.shareXFiles([XFile(filePath)],
          subject: caption, text: shareLink);
    } else {
      final shareLink =
          "$caption \n\n Checkout this post on Bookish: \n https://bookissh-web.web.app/post/${postId}";
      Share.share(
        shareLink,
        subject: caption,
      );
    }
  }
}