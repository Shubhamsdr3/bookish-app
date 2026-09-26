import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookishErrorWidget extends StatelessWidget {
  final String errorMessage;
  final Function onRetryClicked;

  const BookishErrorWidget(
      {super.key, required this.errorMessage, required this.onRetryClicked});

  @override
  Widget build(BuildContext context) {
    final iconWidth = MediaQuery.sizeOf(context).width * 0.2;
    final iconHeight = MediaQuery.sizeOf(context).height * 0.2;
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/image/network_error.png',
          width: iconWidth,
          height: iconHeight,
        ),
        SizedBox(
          height: 24.r,
        ),
        TextButton(
            onPressed: () {
              onRetryClicked();
            },
            child: Text(errorMessage))
      ],
    ));
  }
}
