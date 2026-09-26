import 'package:bookish_module/uikit/bookish_size.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookishSizeImpl extends BookishSize {

  @override
  ThemeExtension<BookishSize> copyWith() {
    return BookishSizeImpl();
  }

  @override
  ThemeExtension<BookishSize> lerp(covariant ThemeExtension<BookishSize>? other, double t) {
    return BookishSizeImpl();
  }

  @override
  double get largePadding => 20.r;

  @override
  double get mediumPadding => 18.r;

  @override
  double get regularPadding => 16.r;

  @override
  double get smallPadding => 12.r;

  @override
  double get xLargePadding => 24.r;

  @override
  double get xsPadding => 6.r;

  @override
  double get xxLargePadding => 32.r;

  @override
  double get xxsPadding => 4.r;
  
}