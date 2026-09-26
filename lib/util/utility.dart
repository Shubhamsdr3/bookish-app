import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {

  static void bookishPrint(String text) {
    debugPrint("Bookish:: $text");
  }

  static void showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
       SnackBar(content: Text(message)
      ),
    );
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.r
    );
  }

  static String getBookName(String? bookName) {
    if (bookName == null || bookName.isEmpty) return "";
    return bookName.split(':')[0];
  }

  static String getAuthors(List<String>? authors) {
    final buffer = StringBuffer();
    var len = authors?.length ?? 0;
    for (var i = 0; i < len; i++) {
      buffer.write(authors?[i] ?? "" + ", ");
    }
    return buffer.toString();
  }
}